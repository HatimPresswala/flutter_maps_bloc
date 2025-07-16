import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/features/home/bloc/home_event.dart';
import 'package:flutter_map/features/home/ui/home_screen.dart';

import 'core/services/location_service.dart';
import 'features/home/bloc/home_bloc.dart';
import 'features/saved_locations/bloc/saved_locations_bloc.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationService = LocationService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SavedLocationsBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(
            locationService,
            BlocProvider.of<SavedLocationsBloc>(context),
          )..add(LoadUserLocationEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Maps BLoC',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}
