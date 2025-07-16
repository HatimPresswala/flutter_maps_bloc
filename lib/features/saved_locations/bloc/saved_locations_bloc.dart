import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'saved_locations_event.dart';
import 'saved_locations_state.dart';

class SavedLocationsBloc
    extends HydratedBloc<SavedLocationsEvent, SavedLocationsState> {
  SavedLocationsBloc() : super(SavedLocationsLoaded([])) {
    on<AddSavedLocationEvent>(_onAdd);
  }

  void _onAdd(
      AddSavedLocationEvent event, Emitter<SavedLocationsState> emit) {
    final currentPins = (state is SavedLocationsLoaded)
        ? (state as SavedLocationsLoaded).pins
        : <LatLng>[];
    emit(SavedLocationsLoaded([...currentPins, event.pin]));
  }

  @override
  SavedLocationsState? fromJson(Map<String, dynamic> json) {
    try {
      final pinsJson = json['pins'] as List<dynamic>? ?? [];
      final pins = pinsJson.map((e) {
        final m = e as Map<String, dynamic>;
        return LatLng((m['lat'] as num).toDouble(), (m['lng'] as num).toDouble());
      }).toList();
      return SavedLocationsLoaded(pins);
    } catch (_) {
      return SavedLocationsLoaded([]);
    }
  }

  @override
  Map<String, dynamic>? toJson(SavedLocationsState state) {
    if (state is SavedLocationsLoaded) {
      return {
        'pins': state.pins
            .map((p) => {'lat': p.latitude, 'lng': p.longitude})
            .toList(),
      };
    }
    return null;
  }
}
