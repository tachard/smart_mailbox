import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:location_permissions/location_permissions.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'battery_card.dart';
import 'connectivity_card.dart';
import 'weight_card.dart';

class SmartMailBox extends StatefulWidget {
  //Constructor
  const SmartMailBox({super.key});

  @override
  State<SmartMailBox> createState() => _SmartMailBoxState();
}

class _SmartMailBoxState extends State<SmartMailBox> {
  // Some state management stuff
  bool _scanStarted = false;
  bool _connected = false;
// Bluetooth related variables
  late DiscoveredDevice _device;
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late QualifiedCharacteristic _batteryCharacteristic;
  late QualifiedCharacteristic _weightCharacteristic;
  late List<int> _battery;
  late List<int> _weight;

  final example = {
    "BatteryLevel": "95",
    "ConnectivityStatus": "2",
    "Weight": "300",
  };
  final bleServices = {
    "Battery": Uuid.parse("0000180F-0000-1000-8000-00805f9b34fb"),
    "Weight": Uuid.parse("c961649c-2b90-4add-ad60-21a9f26c048a"),
  };
  final bleCharacteristics = {
    "Battery": Uuid.parse("00002a19-0000-1000-8000-00805f9b34fb"),
    "Weight": Uuid.parse("99e8a6f3-85c2-4fb8-98d8-7e748c61b9c7"),
  };

  void _startScan() async {
// Platform permissions handling stuff
    bool permGranted = false;
    setState(() {
      _scanStarted = true;
    });
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted) permGranted = true;
    } else if (Platform.isIOS) {
      permGranted = true;
    }
// Main scanning logic happens here ⤵️
    if (permGranted) {
      _scanStream = flutterReactiveBle
          .scanForDevices(withServices: bleServices.values.toList())
          .listen((device) {
        if (device.name == "SmartMailboxAchard") {
          setState(() {
            _device = device;
          });
        }
      });
    }
  }

  void _connectToDevice() {
    // We're done scanning, we can cancel it
    _scanStream.cancel();
    // Let's listen to our connection so we can make updates on a state change
    Stream<ConnectionStateUpdate> currentConnectionStream =
        flutterReactiveBle.connectToAdvertisingDevice(
            id: _device.id,
            prescanDuration: const Duration(seconds: 1),
            withServices: bleServices.values.toList());

    currentConnectionStream.listen((event) {
      switch (event.connectionState) {
        // We're connected and good to go!
        case DeviceConnectionState.connected:
          {
            _batteryCharacteristic = QualifiedCharacteristic(
                serviceId: bleServices["Battery"]!,
                characteristicId: bleCharacteristics["Battery"]!,
                deviceId: event.deviceId);
            _weightCharacteristic = QualifiedCharacteristic(
                characteristicId: bleCharacteristics["Weight"]!,
                serviceId: bleServices["Weight"]!,
                deviceId: event.deviceId);

            setState(() {
              _connected = true;
            });
            break;
          }
        default:
          break;
      }
    });
  }

  void _readCharacteristics(QualifiedCharacteristic batteryCharac,
      QualifiedCharacteristic weightCarac) {
    flutterReactiveBle.subscribeToCharacteristic(batteryCharac).listen((event) {
      setState(() {
        _battery = event;
      });
    });
    flutterReactiveBle.subscribeToCharacteristic(weightCarac).listen((event) {
      setState(() {
        _weight = event;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startScan();
    _connectToDevice();
    _readCharacteristics(_batteryCharacteristic, _weightCharacteristic);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WeightCard(_weight.length),
        BatteryCard(_battery.length),
        ConnectivityCard(_connected, _scanStarted),
      ],
    );
  }
}
