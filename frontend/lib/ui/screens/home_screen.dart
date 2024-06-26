import 'dart:async';
import 'package:flutter/material.dart';
import 'package:npm_check/ui/screens/login_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:in_app_notification/in_app_notification.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class StreamSocket {
  final _positionResponse = StreamController<String>.broadcast();
  final _alertResponse = StreamController<String>.broadcast();

  final List<String> _positions = [];
  final List<String> _alerts = [];

  void Function(String) get addPositionResponse => (String message) {
        _positions.add(message);
        _positionResponse.sink.add(message);
      };

  void Function(String) get addAlertResponse => (String message) {
        _alerts.add(message);
        _alertResponse.sink.add(message);
      };

  Stream<List<String>> get getPositionResponse =>
      _positionResponse.stream.map((_) => _positions);

  Stream<List<String>> get getAlertResponse =>
      _alertResponse.stream.map((_) => _alerts);

  void dispose() {
    _positionResponse.close();
    _alertResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();

void connectAndListen(GlobalKey<NavigatorState> navigatorKey) {
  IO.Socket socket = IO.io(
    'http://localhost:5000',
    IO.OptionBuilder().setTransports(['websocket']).build(),
  );

  socket.onConnect((_) {
    print('connect');
    socket.emit('msg', 'test');
  });

  socket.on(
      'position', (data) => streamSocket.addPositionResponse(data.toString()));
  socket.on('alert', (data) {
    streamSocket.addAlertResponse(data.toString());
    if (navigatorKey.currentContext != null) {
      InAppNotification.show(
        context: navigatorKey.currentContext!,
        child: NotificationBody(message: data.toString()),
        onTap: () => print('Notification tapped!'),
      );
    }
  });
  socket.onDisconnect((_) => print('disconnect'));
}

class NotificationBody extends StatelessWidget {
  final String message;

  NotificationBody({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.red,
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    connectAndListen(navigatorKey);
  }

  @override
  void dispose() {
    streamSocket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InAppNotification(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Position Vehicule',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder<List<String>>(
                    stream: streamSocket.getPositionResponse,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No positions received yet.'));
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border(
                              left: BorderSide(
                                color: Colors.green,
                                width: 3,
                              ),
                            ),
                          ),
                          height: 20,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data![index]),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder<List<String>>(
                    stream: streamSocket.getAlertResponse,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('Pas d alert actuellement.'));
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border(
                              left: BorderSide(
                                color: Colors.red,
                                width: 3,
                              ),
                            ),
                          ),
                          height: 10,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data![index]),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
