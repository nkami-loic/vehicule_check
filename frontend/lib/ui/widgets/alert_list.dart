import 'package:flutter/material.dart';
import '../../models/alert.dart';

class AlertList extends StatelessWidget {
  final List<Alert> alerts;

  const AlertList({required this.alerts, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return ListTile(
          title: Text('Vehicle ID: ${alert.vehicleId}'),
          subtitle: Text('Message: ${alert.message}'),
        );
      },
    );
  }
}
