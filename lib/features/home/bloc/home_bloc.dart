import 'package:flutter_map/features/saved_locations/bloc/saved_locations_bloc.dart';
import 'package:flutter_map/features/saved_locations/bloc/saved_locations_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/location_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LocationService locationService;
  final SavedLocationsBloc savedLocationsBloc;

  HomeBloc(this.locationService, this.savedLocationsBloc) : super(HomeInitial()) {
    on<LoadUserLocationEvent>(_onLoadLocation);
    on<DropPinEvent>(_onDropPin);
  }

  Future<void> _onLoadLocation(
      LoadUserLocationEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final pos = await locationService.getCurrentLocation();

      // 🟡 Pull saved pins from HydratedBloc
      final savedPins = savedLocationsBloc.state is SavedLocationsLoaded
          ? (savedLocationsBloc.state as SavedLocationsLoaded).pins
          : <LatLng>[];

      emit(HomeLoaded(position: pos, pins: savedPins));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void _onDropPin(DropPinEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      final newPins = List<LatLng>.from(current.pins)..add(event.pin);
      emit(current.copyWith(pins: newPins));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
