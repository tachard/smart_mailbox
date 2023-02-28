import 'package:flutter/material.dart';
import "package:flutter_reactive_ble/flutter_reactive_ble.dart";
import 'dart:async';
import 'package:smart_mailbox/widgets/battery_card.dart';
import 'package:smart_mailbox/widgets/connectivity_card.dart';
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_mailbox/widgets/weight_card.dart';

class SmartMailBox extends StatefulWidget {
  const SmartMailBox({super.key});

  @override
  State<SmartMailBox> createState() => _SmartMailBoxState();
}

class _SmartMailBoxState extends State<SmartMailBox> {
  var _failed = false;
  var _connected = false;
  var _scanning = false;

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

  late int _batteryValue;
  late int _weightValue;

  void _scanDevice() async {
    // Handling permission
    print("WAITING PERMISSIONS");
    bool permGranted = false;

    if (Platform.isAndroid) {
      PermissionStatus locationPermission = await Permission.location.request();
      PermissionStatus bleScan = await Permission.bluetoothScan.request();
      PermissionStatus bleConnect = await Permission.bluetoothConnect.request();
      if (locationPermission == PermissionStatus.granted &&
          bleScan == PermissionStatus.granted &&
          bleConnect == PermissionStatus.granted) permGranted = true;
    } else if (Platform.isIOS) {
      permGranted = true;
    }

    if (permGranted) {
      print("SCAN MAIN LOGIC");
      setState(() {
        _scanning = true;
      });
      var scanStream = _ble.scanForDevices(
        withServices: [_bleServices["Battery"]!],
      );
      print("LISTENING");

      var myDevice =
          await scanStream.firstWhere((device) => device.name == _deviceName);
      setState(() {
        _device = myDevice;
        _scanning = false;
      });
      print("FOUND IT");
    }
  }

  void _connectToDevice() async {
    print("CONNECTING");
    _ble.connectToAdvertisingDevice(
        id: _device!.id,
        prescanDuration: const Duration(seconds: 1),
        withServices: [_bleServices["Battery"]!]).listen((event) {
      switch (event.connectionState) {
        // We're connected and good to go!
        case DeviceConnectionState.connected:
          {
            _batteryCharac = QualifiedCharacteristic(
                serviceId: _bleServices["Battery"]!,
                characteristicId: _bleCharacteristics["Battery"]!,
                deviceId: event.deviceId);
            _weightCharac = QualifiedCharacteristic(
                characteristicId: _bleCharacteristics["Weight"]!,
                serviceId: _bleServices["Weight"]!,
                deviceId: event.deviceId);
            setState(() {
              _connected = true;
            });
            print("CONNECTED");
            break;
          }
        // Can add various state state updates on disconnect
        case DeviceConnectionState.disconnected:
          {
            break;
          }
        default:
      }
    });
  }

  void _readCharacteristics(QualifiedCharacteristic batteryCharac,
      QualifiedCharacteristic weightCharac) {
    _ble.subscribeToCharacteristic(batteryCharac).listen((data) {
      // code to handle incoming data
      setState(() {
        _batteryValue = int.parse(String.fromCharCodes(data));
      });
    }, onError: (dynamic error) {
      // code to handle errors
      setState(() {
        _batteryValue = -1;
      });
    });
    _ble.subscribeToCharacteristic(weightCharac).listen((data) {
      // code to handle incoming data
      setState(() {
        _weightValue = int.parse(String.fromCharCodes(data));
      });
    }, onError: (dynamic error) {
      // code to handle errors
      setState(() {
        _weightValue = -1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Not connected nor scanning
    if (!_connected && !_scanning && _device == null) {
      return (Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: _scanDevice,
              child: ConnectivityCard(
                _scanning,
                _device == null,
                _connected,
              ))
        ],
      ));
    }
    //Waiting to connect
    if (!_connected && (_scanning || _device != null)) {
      if (!_scanning) {
        _connectToDevice();
      }

      return (Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          ConnectivityCard(_scanning, _device == null, _connected)
        ],
      ));
    }

    // Ready to go
    if (_connected) {
      _readCharacteristics(_batteryCharac, _weightCharac);
      return (Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        WeightCard(_weightValue),
        BatteryCard(_batteryValue),
        ConnectivityCard(_scanning, _device == null, _connected)
      ]));
    }

    if (_failed) {
      return (Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Something went wrong with scanning")],
      ));
    }

    return (Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("Something went wrong")],
    ));
  }
}
