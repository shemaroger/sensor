import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';

class LocationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sensorProvider = Provider.of<SensorProvider>(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            if (sensorProvider.currentPosition != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Latitude: ${sensorProvider.currentPosition!.latitude.toStringAsFixed(4)}'),
                  Text(
                      'Longitude: ${sensorProvider.currentPosition!.longitude.toStringAsFixed(4)}'),
                ],
              )
            else
              Text('Location not available'),
          ],
        ),
      ),
    );
  }
}
