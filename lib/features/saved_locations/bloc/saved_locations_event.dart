import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class SavedLocationsEvent {}
class LoadSavedLocationsEvent extends SavedLocationsEvent {}
class AddSavedLocationEvent extends SavedLocationsEvent {
  final LatLng pin;
  AddSavedLocationEvent(this.pin);
}