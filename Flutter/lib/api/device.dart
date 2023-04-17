// Static class
import 'package:flutter/foundation.dart';
import "package:flutter_reactive_ble/flutter_reactive_ble.dart";

class Device {
  // Static variables
  static var name = "SmartMailboxAchard";
  static var services = {
    "Battery": Uuid.parse("0000180F-0000-1000-8000-00805f9b34fb"),
    "Weight": Uuid.parse("c961649c-2b90-4add-ad60-21a9f26c048a")
  };
  static var characteristics = {
    "Battery": Uuid.parse("00002a19-0000-1000-8000-00805f9b34fb"),
    "Weight": Uuid.parse("99e8a6f3-85c2-4fb8-98d8-7e748c61b9c7")
  };

  // Static streams simulating ESP32 functionnalities
  static Stream<DiscoveredDevice> scanForDevices(
      {required List<Uuid> withServices}) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield DiscoveredDevice(
          id: "1",
          name: "Smart Mailbox",
          serviceData: {},
          manufacturerData: Uint8List(1),
          rssi: 1,
          serviceUuids: services.values.toList());
    }
  }

  static Stream<DeviceConnectionState> connectToAdvertisingDevice(
      {required String id,
      required Duration prescanDuration,
      required List<Uuid> withServices}) async* {
    await Future.delayed(const Duration(seconds: 1));
    yield DeviceConnectionState.connected;
  }
}
