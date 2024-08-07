import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor App'),
      ),
      body: Consumer<SensorProvider>(
        builder: (context, sensorProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Accelerometer: ${sensorProvider.accelerometerValues}'),
              Text('Light Level: ${sensorProvider.lightLevel}'),
              Text('Current Position: ${sensorProvider.currentPosition}'),
              Text('Motion Detected: ${sensorProvider.motionDetected}'),
            ],
          );
        },
      ),
    );
  }
}
//0788407761