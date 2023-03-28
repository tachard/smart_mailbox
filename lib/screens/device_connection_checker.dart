import 'package:flutter/material.dart';
import "package:flutter_reactive_ble/flutter_reactive_ble.dart";
import "../api/device.dart";

class DeviceConnectionChecker extends StatefulWidget {
  DeviceConnectionChecker({super.key, required this.ble});

  final FlutterReactiveBle ble;

  @override
  State<DeviceConnectionChecker> createState() =>
      _DeviceConnectionCheckerState();
}

class _DeviceConnectionCheckerState extends State<DeviceConnectionChecker> {
  @override
  Widget build(BuildContext context) {
    var device = Device.create(widget.ble);
    return Container();
  }
}
