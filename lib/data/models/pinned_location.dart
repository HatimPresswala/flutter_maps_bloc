class PinnedLocation {
  final double latitude;
  final double longitude;

  PinnedLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() => '($latitude, $longitude)';
}
