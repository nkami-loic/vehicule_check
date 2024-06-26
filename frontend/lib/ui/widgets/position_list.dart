import 'package:flutter/material.dart';
import '../../models/position.dart';

class PositionList extends StatelessWidget {
  final List<Position> positions;

  const PositionList({super.key, required this.positions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: positions.length,
      itemBuilder: (context, index) {
        final position = positions[index];
        return ListTile(
          title: Text('Vehicle ID: ${position.vehicleId}'),
          subtitle: Text(
              'Lat: ${position.lat}, Lon: ${position.lon}, Timestamp: ${position.timestamp}'),
        );
      },
    );
  }
}
