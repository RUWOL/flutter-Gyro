import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

GyroscopeEvent? gyroscopeEvent;

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Gyro()),
        ],
        child: const MyApp(),
      )
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GyroBuild(),
    );
  }
}

class Gyro with ChangeNotifier{
  GyroscopeEvent? get  gyroEvent => gyroscopeEvent;

  void setGyroEvent(GyroscopeEvent event) {
    gyroscopeEvent = event;
    print(gyroscopeEvent);
      notifyListeners();
  }
}

class SetGyro extends StatelessWidget {
  const SetGyro({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Text("X: ${context.watch<Gyro>().gyroEvent?.x.toStringAsFixed(2)?? 'null'}"),
        Text("Y: ${context.watch<Gyro>().gyroEvent?.y.toStringAsFixed(2)?? 'null'}"),
        Text("Z: ${context.watch<Gyro>().gyroEvent?.z.toStringAsFixed(2)?? 'null'}"),
      ],
    );
  }
}

class GyroBuild extends StatelessWidget {
  GyroBuild({super.key});

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  Widget build(BuildContext context) {
    _streamSubscriptions.add(
      gyroscopeEventStream().listen(
            (GyroscopeEvent event) {
          gyroscopeEvent = event;
        },

      ),
    );
    // if you adjust sensor sampling period, Change the duration of the timer
    Timer.periodic(const Duration(seconds: 1), (timer) {context.read<Gyro>().setGyroEvent(gyroscopeEvent?? GyroscopeEvent(0, 0, 0));});
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(

        child: SetGyro(),
        ),
    );
  }
}
