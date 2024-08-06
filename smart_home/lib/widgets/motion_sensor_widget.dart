import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';

class MotionSensorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sensorProvider = Provider.of<SensorProvider>(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Motion Sensor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
                'X: ${sensorProvider.accelerometerValues[0].toStringAsFixed(2)}'),
            Text(
                'Y: ${sensorProvider.accelerometerValues[1].toStringAsFixed(2)}'),
            Text(
                'Z: ${sensorProvider.accelerometerValues[2].toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
