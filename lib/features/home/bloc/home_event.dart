import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

abstract class HomeEvent {}

class LoadUserLocationEvent extends HomeEvent {}

class DropPinEvent extends HomeEvent {
  final LatLng pin;
  DropPinEvent(this.pin);
}
class StartLocationUpdatesEvent extends HomeEvent {}

class LocationChangedEvent extends HomeEvent {
  final Position position;
  LocationChangedEvent(this.position);
}
