import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final Position position;
  final List<LatLng> pins;
  HomeLoaded({required this.position, this.pins = const []});

  HomeLoaded copyWith({Position? position, List<LatLng>? pins}) {
    return HomeLoaded(
      position: position ?? this.position,
      pins: pins ?? this.pins,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
