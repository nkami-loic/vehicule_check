class Alert {
  final String vehicleId;
  final String message;

  Alert({
    required this.vehicleId,
    required this.message,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      vehicleId: json['vehicleId'],
      message: json['message'],
    );
  }
}
