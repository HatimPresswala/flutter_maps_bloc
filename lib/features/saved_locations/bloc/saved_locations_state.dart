import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class SavedLocationsState {
  List<LatLng> get pins;
}
class SavedLocationsLoaded extends SavedLocationsState {
  @override
  final List<LatLng> pins;
  SavedLocationsLoaded(this.pins);
}