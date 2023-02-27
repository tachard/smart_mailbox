import 'package:flutter/material.dart';
import "package:flutter_reactive_ble/flutter_reactive_ble.dart";
import 'dart:async';
import 'package:location_permissions/location_permissions.dart';
import 'package:smart_mailbox/widgets/battery_card.dart';
import 'package:smart_mailbox/widgets/connectivity_card.dart';
import 'dart:io' show Platform;

import 'package:smart_mailbox/widgets/weight_card.dart';

class SmartMailBox extends StatefulWidget {
  const SmartMailBox({super.key});

  @override
  State<SmartMailBox> createState() => _SmartMailBoxState();
}

class _SmartMailBoxState extends State<SmartMailBox> {
  var _scanning = false;
  var _discovered = false;
  var _connected = false;

  final _deviceName = "SmartMailboxAchard";
  final _bleServices = {
    "Battery": Uuid.parse("0000180F-0000-1000-8000-00805f9b34fb"),
    "Weight": Uuid.parse("c961649c-2b90-4add-ad60-21a9f26c048a")
  };
  final _bleCharacteristics = {
    "Battery": Uuid.parse("00002a19-0000-1000-8000-00805f9b34fb"),
    "Weight": Uuid.parse("99e8a6f3-85c2-4fb8-98d8-7e748c61b9c7")
  };
  final _ble = FlutterReactiveBle();
  DiscoveredDevice? _device;
  late QualifiedCharacteristic _batteryCharac;
  late QualifiedCharacteristic _weightCharac;

  void _connectToDevice() async {
// Platform permissions handling stuff
    bool permGranted = false;
    setState(() {
      _scanning = true;
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
      _ble
          .scanForDevices(withServices: _bleServices.values.toList())
          .listen((device) {
        if (device.name == _deviceName) {
          setState(() {
            _device = device;
            _discovered = true;
          });
        }
      });
      setState(() {
        _scanning = false;
      });
    }

    // Let's listen to our connection so we can make updates on a state change
    Stream<ConnectionStateUpdate> currentConnectionStream =
        _ble.connectToAdvertisingDevice(
            id: _device.id,
            prescanDuration: const Duration(seconds: 1),
            withServices: _bleServices.values.toList());
    currentConnectionStream.listen((event) {
      switch (event.connectionState) {
        // We're connected and good to go!
        case DeviceConnectionState.connected:
          {
            _batteryCharac = QualifiedCharacteristic(
                serviceId: _bleServices["Battery"]!,
                characteristicId: _bleCharacteristics["Battery"]!,
                deviceId: event.deviceId);

            _weightCharac = QualifiedCharacteristic(
                serviceId: _bleServices["Weight"]!,
                characteristicId: _bleCharacteristics["Weight"]!,
                deviceId: event.deviceId);

            setState(() {
              _scanning = false;
              _discovered = false;
              _connected = true;
            });
            break;
          }
        // Can add various state state updates on disconnect
        case DeviceConnectionState.disconnected:
          {
            setState(() {
              _connected = false;
            });
            break;
          }
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _connectToDevice();
    int readWeight = -1;
    int readBattery = -1;

    if (_connected) {
      _ble
          .readCharacteristic(_weightCharac)
          .then((value) => readWeight = int.parse(String.fromCharCodes(value)));
      _ble.readCharacteristic(_batteryCharac).then(
          (value) => readBattery = int.parse(String.fromCharCodes(value)));
    }

    return (!_connected
        ? Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                ConnectivityCard(
                    _scanning, _discovered, _connected, _connectToDevice)
              ],
            ),
          )
        : Center(
            child: Column(
              children: [
                WeightCard(readWeight),
                BatteryCard(readBattery),
                ConnectivityCard(
                    _scanning, _discovered, _connected, _connectToDevice)
              ],
            ),
          ));
  }
}
