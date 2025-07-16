import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/saved_locations_bloc.dart';
import '../bloc/saved_locations_state.dart';

class SavedLocationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved Locations")),
      body: BlocBuilder<SavedLocationsBloc, SavedLocationsState>(
        builder: (context, state) {
          if (state is SavedLocationsLoaded) {
            if (state.pins.isEmpty) {
              return Center(child: Text("No pins saved."));
            }
            return ListView.builder(
              itemCount: state.pins.length,
              itemBuilder: (_, i) {
                final p = state.pins[i];
                return ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("Lat: ${p.latitude}, Lng: ${p.longitude}"),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
