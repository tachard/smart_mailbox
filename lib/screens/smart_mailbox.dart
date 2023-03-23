// Screen where we can connect to the smart mailbox.

import 'package:flutter/material.dart';
import "package:flutter_reactive_ble/flutter_reactive_ble.dart";
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
  //State variables
  var _failed = false;
  var _connected = false;
  var _scanning = false;
  var _firstConnection = true;

  //Informations about smart mailbox device
  final _deviceName = "SmartMailboxAchard";
  final _bleServices = {
    "Battery": Uuid.parse("0000180F-0000-1000-8000-00805f9b34fb"),
    "Weight": Uuid.parse("c961649c-2b90-4add-ad60-21a9f26c048a")
  };
  final _bleCharacteristics = {
    "Battery": Uuid.parse("00002a19-0000-1000-8000-00805f9b34fb"),
    "Weight": Uuid.parse("99e8a6f3-85c2-4fb8-98d8-7e748c61b9c7")
  };

  // Bluetooth Low Energy Variables.
  final _ble = FlutterReactiveBle();
  DiscoveredDevice? _device;
  late QualifiedCharacteristic _batteryCharac;
  late QualifiedCharacteristic _weightCharac;

  int _batteryValue = -1;
  int _weightValue = -1;

  // Private function.
  // Authorize bluetooth use. Then search for the wanted device
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
      // Scan for a device with services required
      var scanStream = _ble.scanForDevices(
        withServices: [_bleServices["Battery"]!],
      );
      print("LISTENING");

      // Get the device found
      var myDevice =
          await scanStream.firstWhere((device) => device.name == _deviceName);
      setState(() {
        _device = myDevice;
        _scanning = false;
      });
      print("FOUND IT");
    }
  }

  // Private function.
  // If device is found, connect to it.
  void _connectToDevice() async {
    print("CONNECTING");
    //Try to connect to a device.
    _ble.connectToAdvertisingDevice(
        id: _device!.id,
        prescanDuration: const Duration(seconds: 1),
        withServices: [_bleServices["Battery"]!]).listen((event) {
      switch (event.connectionState) {
        // We're connected and good to go!
        case DeviceConnectionState.connected:
          {
            // Store characteristics in variables
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
              _firstConnection = true;
            });
            print("CONNECTED");
            break;
          }
        // Can add various state state updates on disconnect
        case DeviceConnectionState.disconnected:
          {
            setState(() {
              _connected = false;
              _device = null;
            });
            break;
          }
        default:
      }
    });
  }

  // Private function
  // Once characteristics are stored, retrieve value to them.
  void _readCharacteristics(QualifiedCharacteristic batteryCharac,
      QualifiedCharacteristic weightCharac) {
    print("READING");
    //Read the battery characteristic
    _ble.readCharacteristic(batteryCharac).then(
      (value) {
        print("BATTERY READ");
        setState(() {
          _batteryValue = int.parse(String.fromCharCodes(value));
        });
      },
    );
    //Read the weight caracteristic
    _ble.readCharacteristic(weightCharac).then(
      (value) {
        print("WEIGHT READ");
        setState(() {
          _weightValue = int.parse(String.fromCharCodes(value));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //Display only a touchable ConnectivityCard if not connected nor scanning
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
        // Only called if device is discovered
        _connectToDevice();
      }

      // Return a centered loading spinner.
      return (Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator()),
        ],
      ));
    }

    // Ready to go
    if (_connected) {
      if (_firstConnection) {
        _readCharacteristics(_batteryCharac, _weightCharac);
        _firstConnection = false;
      }

      return (Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        WeightCard(_weightValue),
        SizedBox(height: 20),
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
