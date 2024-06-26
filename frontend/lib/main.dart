import 'package:flutter/material.dart';
import 'package:npm_check/ui/screens/login_screen.dart';
import 'package:npm_check/ui/screens/welcome_page.dart';
import '../models/position.dart';
import '../models/alert.dart';
import 'ui/widgets/position_list.dart';
import 'ui/widgets/alert_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<dynamic> rawPositions;
  final List<dynamic> rawAlerts;

  const HomeScreen({
    required this.rawPositions,
    required this.rawAlerts,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Position> positions =
        rawPositions.map((json) => Position.fromJson(json)).toList();
    List<Alert> alerts = rawAlerts.map((json) => Alert.fromJson(json)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PositionList(positions: positions),
          ),
        ],
      ),
    );
  }
}
