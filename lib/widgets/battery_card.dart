import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BatteryCard extends StatefulWidget {
  BatteryCard({super.key, required this.ble, required this.battery});

  final QualifiedCharacteristic battery;
  final FlutterReactiveBle ble;

  @override
  State<BatteryCard> createState() => _BatteryCardState();
}

class _BatteryCardState extends State<BatteryCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.ble.readCharacteristic(widget.battery),
      builder: (context, snapshot) {
        Widget leadingIcon;
        String text;

        if (snapshot.hasError) {
          leadingIcon = Icon(Icons.error_outline,
              size: 48, color: Theme.of(context).colorScheme.error);
          text = "Erreur de lecture";
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              var battery = int.parse(String.fromCharCodes(snapshot.data!));
              if (battery >= 67) {
                leadingIcon = Icon(
                  Icons.battery_6_bar,
                  color: Colors.green,
                  size: 48,
                );
              } else if (battery <= 33) {
                leadingIcon = Icon(
                  Icons.battery_2_bar,
                  color: Colors.red,
                  size: 48,
                );
              } else {
                leadingIcon = Icon(
                  Icons.battery_4_bar,
                  color: Colors.orange,
                  size: 48,
                );
              }
              text = 'Niveau de batterie : $battery%';
              break;
            default:
              leadingIcon = CircularProgressIndicator();
              text = "Récupération du niveau de batterie";
              break;
          }
        }

        return Card(
          child: ListTile(
            leading: leadingIcon,
            title: Text(text,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}
