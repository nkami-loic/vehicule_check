class Position {
  final String vehicleId;
  final double lat;
  final double lon;
  final int timestamp;

  Position({
    required this.vehicleId,
    required this.lat,
    required this.lon,
    required this.timestamp,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      vehicleId: json['vehicleId'],
      lat: json['position']['lat'],
      lon: json['position']['lon'],
      timestamp: json['position']['timestamp'],
    );
  }
}
