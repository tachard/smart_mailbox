// Screen where we can connect to the smart mailbox.

import 'package:flutter/material.dart';
import "package:flutter_reactive_ble/flutter_reactive_ble.dart";
import 'package:permission_handler/permission_handler.dart';
import 'device_connection_checker.dart';

class BleStatusChecker extends StatefulWidget {
  const BleStatusChecker({super.key});

  @override
  State<BleStatusChecker> createState() => _BleStatusCheckerState();
}

class _BleStatusCheckerState extends State<BleStatusChecker> {
  // Bluetooth Low Energy Variables.
  final _ble = FlutterReactiveBle();

  @override
  Widget build(BuildContext context) {
    // Show something epending on host BLE status
    return StreamBuilder(
      stream: _ble.statusStream,
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasError) {
          children = [
            Card(
              child: ListTile(
                leading: Icon(Icons.error_outline,
                    color: Theme.of(context).colorScheme.error),
                title: Text("Erreur de flux du statut BLE."),
              ),
            )
          ];
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              children = [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.error_outline,
                        color: Theme.of(context).colorScheme.error),
                    title: Text("Flux du statut BLE déconnecté."),
                  ),
                )
              ];
              break;
            case ConnectionState.waiting:
              children = [
                SizedBox(
                    width: 60, height: 60, child: CircularProgressIndicator())
              ];
              break;
            default:
              // ConnectionState.active || ConnectionState.done
              switch (snapshot.data) {
                case BleStatus.ready:
                  children = [DeviceConnectionChecker(ble:_ble)];
                  break;
                case BleStatus.unauthorized:
                  Permission.location.request();
                  Permission.bluetoothScan.request();
                  Permission.bluetoothConnect.request();
                  children = [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.error_outline,
                            color: Theme.of(context).colorScheme.error),
                        title: Text(
                            "Bluetooth non autorisé pour l'app. Veuillez l'autoriser dans les paramètres."),
                        onTap: openAppSettings,
                      ),
                    )
                  ];
                  break;
                case BleStatus.locationServicesDisabled:
                  children = [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.error_outline,
                            color: Theme.of(context).colorScheme.error),
                        title: Text(
                            "Services de localisation non autorisés pour l'app. Veuillez les activer dans les paramètres."),
                        onTap: openAppSettings,
                      ),
                    )
                  ];
                  break;
                case BleStatus.unsupported:
                  children = [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.error_outline,
                            color: Theme.of(context).colorScheme.error),
                        title: Text(
                            "Bluetooth Low Energy non supporté par votre téléphone."),
                      ),
                    )
                  ];
                  break;
                default: //BLE Status unknown
                  children = [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.error_outline,
                            color: Theme.of(context).colorScheme.error),
                        title: Text("Statut du Bluetooth Low Energy inconnu."),
                      ),
                    )
                  ];
              }
          }
        }

        return Column(
            mainAxisAlignment: MainAxisAlignment.center, children: children);
      },
    );
  }
}
