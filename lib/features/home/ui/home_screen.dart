import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../saved_locations/bloc/saved_locations_bloc.dart';
import '../../saved_locations/bloc/saved_locations_event.dart';
import '../../saved_locations/ui/saved_locations_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureLocationAndStart();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _ensureLocationAndStart();
    }
  }

  Future<void> _ensureLocationAndStart() async {
    // 1) Check services
    if (!await Geolocator.isLocationServiceEnabled()) {
      await _showDialog(
        title: 'Location Disabled',
        message: 'Please enable location services.',
        actionText: 'Open Settings',
        onAction: Geolocator.openLocationSettings,
      );
      return;
    }

    // 2) Request/verify permissions
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      perm = await Geolocator.requestPermission();
    }
    if (perm != LocationPermission.whileInUse &&
        perm != LocationPermission.always) {
      await _showDialog(
        title: 'Permission Denied',
        message: 'Location permission is required.',
        actionText: 'Grant',
        onAction: () {}, 
      );
      return;
    }

    // 3) Now start streaming
    context.read<HomeBloc>().add(StartLocationUpdatesEvent());
  }

  Future<void> _showDialog({
    required String title,
    required String message,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onAction();
            },
            child: Text(actionText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Map"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeBloc>().add(LoadUserLocationEvent());
            },
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SavedLocationsScreen()),
            ),
          ),
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (ctx, state) {
          if (state is HomeLoaded && _mapController != null) {
            final pos =
                LatLng(state.position.latitude, state.position.longitude);
            _mapController!.animateCamera(CameraUpdate.newLatLng(pos));
          }
        },
        builder: (ctx, state) {
          if (state is HomeInitial || state is HomeLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is HomeError) {
            return Center(child: Text(state.message));
          }
          if (state is HomeLoaded) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  state.position.latitude,
                  state.position.longitude,
                ),
                zoom: 16,
              ),
              myLocationEnabled: true,
              markers: {
                for (var p in state.pins)
                  Marker(markerId: MarkerId(p.toString()), position: p),
              },
              onMapCreated: (c) => _mapController = c,
              onTap: (latLng) {
                context.read<HomeBloc>().add(DropPinEvent(latLng));
                context
                    .read<SavedLocationsBloc>()
                    .add(AddSavedLocationEvent(latLng));
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
