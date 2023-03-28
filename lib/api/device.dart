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

  // Private function.
  // Search for the wanted device
  Future<void> _scanDevice() async {
    if (_ble.status != BleStatus.ready) {
      _device = null;
    } else {
      print("SCAN MAIN LOGIC");
      // Scan for a device with services required
      var scanStream = _ble.scanForDevices(
        withServices: [services["Battery"]!],
      );
      print("LISTENING");

      // Get the device found
      _device = await scanStream.firstWhere((device) => device.name == name);
    }
  }

  // Private function.
  // If device is found, connect to it.
  Future<void> _connectToDevice() async {
    print("CONNECTING");
    //Try to connect to a device.
    _ble.connectToAdvertisingDevice(
        id: _device!.id,
        prescanDuration: const Duration(seconds: 1),
        withServices: [services["Battery"]!]).listen((event) {
      switch (event.connectionState) {
        // We're connected and good to go!
        case DeviceConnectionState.connected:
          {
            // Store characteristics in variables
            _batteryCharacteristic = QualifiedCharacteristic(
                serviceId: services["Battery"]!,
                characteristicId: characteristics["Battery"]!,
                deviceId: event.deviceId);
            _weightCharacteristic = QualifiedCharacteristic(
                characteristicId: characteristics["Weight"]!,
                serviceId: services["Weight"]!,
                deviceId: event.deviceId);
            break;
          }
        // Can add various state state updates on disconnect
        case DeviceConnectionState.disconnected:
          _device = null;
          _batteryCharacteristic = null;
          _weightCharacteristic = null;
          break;
        default:
      }
    });
  }
}
