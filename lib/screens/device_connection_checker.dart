import 'package:flutter/material.dart';
import "package:flutter_reactive_ble/flutter_reactive_ble.dart";
import "../api/device.dart";
import "device_fully_operational.dart";

class DeviceConnectionChecker extends StatefulWidget {
  DeviceConnectionChecker({super.key, required this.ble});

  final FlutterReactiveBle ble;

  @override
  State<DeviceConnectionChecker> createState() =>
      _DeviceConnectionCheckerState();
}

class _DeviceConnectionCheckerState extends State<DeviceConnectionChecker> {
  DiscoveredDevice? device;

  @override
  Widget build(BuildContext context) {
    if (device == null) {
      return StreamBuilder(
        stream: widget.ble
            .scanForDevices(withServices: Device.services.values.toList()),
        builder: (context, snapshot) {
          List<Widget> children;
          if (snapshot.hasError) {
            children = [
              Card(
                child: ListTile(
                  leading: Icon(Icons.error_outline,
                      color: Theme.of(context).colorScheme.error),
                  title: Text("Erreur de scan de l'appareil."),
                ),
              )
            ];
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                children = [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.check, color: Colors.green),
                      title: Text("Appareil trouvé !"),
                    ),
                  )
                ];
                setState(() {
                  device = snapshot.data;
                });
                break;
              default:
                // while device is not found
                children = [CircularProgressIndicator()];
            }
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          );
        },
      );
    } else {
      // Device found
      return StreamBuilder(
          stream: widget.ble.connectToAdvertisingDevice(
              id: device!.id,
              prescanDuration: Duration(seconds: 1),
              withServices: Device.services.values.toList()),
          builder: ((context, snapshot) {
            List<Widget> children;
            if (snapshot.hasError) {
              children = [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.error_outline,
                        color: Theme.of(context).colorScheme.error),
                    title: Text("Erreur de connexion à l'appareil."),
                  ),
                )
              ];
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  switch (snapshot.data!.connectionState) {
                    case DeviceConnectionState.connected:
                      var batteryCharacteristic = QualifiedCharacteristic(
                          serviceId: Device.services["Battery"]!,
                          characteristicId: Device.characteristics["Battery"]!,
                          deviceId: device!.id);
                      var weightCharacteristic = QualifiedCharacteristic(
                          serviceId: Device.services["Battery"]!,
                          characteristicId: Device.characteristics["Battery"]!,
                          deviceId: device!.id);

                      children = [
                        DeviceFullyOperational(
                            ble: widget.ble,
                            battery: batteryCharacteristic,
                            weight: weightCharacteristic),
                        Card(
                          child: ListTile(
                              leading: Icon(
                                Icons.bluetooth_connected,
                                color: Colors.blue,
                                size: 48,
                              ),
                              title: Text("Connecté à la boîte aux lettres",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold))),
                        )
                      ];
                      break;
                    default:
                      children = [CircularProgressIndicator()];
                  }
                  break;
                default:
                  children = [CircularProgressIndicator()];
                  break;
              }
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            );
          }));
    }
  }
}
