// Static class
import "package:flutter_reactive_ble/flutter_reactive_ble.dart";
import "device.dart";
import "dart:convert";

class QualifiedCharacteristic {
  final Uuid serviceId;
  final Uuid characteristicId;
  final String deviceId;

  QualifiedCharacteristic(
      {required this.serviceId,
      required this.characteristicId,
      required this.deviceId});

  Future<List<int>> readCharacteristic() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () {
        if (characteristicId == Device.characteristics["Battery"]) {
          return utf8.encode("97");
        } else if (characteristicId == Device.characteristics["Weight"]) {
          return utf8.encode("130");
        } else {
          throw Exception("Wrong Chracteristic");
        }
      },
    );
  }
}
