import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'battery_card.dart';
import 'connectivity_card.dart';
import 'weight_card.dart';

class SmartMailBox extends StatelessWidget {
  final example = {
    "BatteryLevel": "95",
    "ConnectivityStatus": "2",
    "Weight": "300",
  };

  //BLE
  final flutterReactiveBle = FlutterReactiveBle();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WeightCard(int.parse(example['Weight']!)),
        BatteryCard(int.parse(example['BatteryLevel']!)),
        ConnectivityCard(int.parse(example["ConnectivityStatus"]!)),
      ],
    );
  }
}
