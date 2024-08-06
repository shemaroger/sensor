import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import '../services/notification_service.dart';

class SensorProvider with ChangeNotifier {
  List<double> _accelerometerValues = [0, 0, 0];
  double _lightLevel = 0;
  Position? _currentPosition;
  bool _motionDetected = false;

  List<double> get accelerometerValues => _accelerometerValues;
  double get lightLevel => _lightLevel;
  Position? get currentPosition => _currentPosition;
  bool get motionDetected => _motionDetected;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<Position>? _positionSubscription;
  static const EventChannel _lightSensorChannel = EventChannel('light_sensor');
  StreamSubscription<dynamic>? _lightSensorSubscription;

  SensorProvider() {
    _initSensors();
  }

  void _initSensors() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      _accelerometerValues = [event.x, event.y, event.z];
      _detectMotion();
      notifyListeners();
    });

    _lightSensorSubscription =
        _lightSensorChannel.receiveBroadcastStream().listen((event) {
      _lightLevel = event;
      notifyListeners();
    });

    _initLocation();
  }

  void _detectMotion() {
    if (_accelerometerValues.any((value) => value.abs() > 1.5)) {
      _motionDetected = true;
      NotificationService.showNotification(
        title: 'Motion Detected',
        body: 'Motion has been detected by the sensor.',
      );
    } else {
      _motionDetected = false;
    }
  }

  void _initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    _positionSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      _currentPosition = position;
      notifyListeners();
      _checkGeofence();
    });
  }

  void _checkGeofence() {
    double homeLat = 37.4219999;
    double homeLong = -122.0840575;
    double distance = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      homeLat,
      homeLong,
    );
    if (distance < 100) {
      // Trigger action for entering geofence
      NotificationService.showNotification(
        title: 'Geofence Alert',
        body: 'You have entered the geofence area.',
      );
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _positionSubscription?.cancel();
    _lightSensorSubscription?.cancel();
    super.dispose();
  }
}
