import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter/material.dart';


class DeviceFullyOperational extends StatefulWidget {
  DeviceFullyOperational(
      {super.key,
      required this.ble,
      required this.battery,
      required this.weight});

  final FlutterReactiveBle ble;
  final QualifiedCharacteristic battery;
  final QualifiedCharacteristic weight;

  @override
  State<DeviceFullyOperational> createState() =>
      _DeviceFullyOperationalState();
}

class _DeviceFullyOperationalState extends State<DeviceFullyOperational> {}
