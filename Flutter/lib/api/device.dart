// Static class 
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
}
