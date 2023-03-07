import 'package:flutter/material.dart';

class BatteryCard extends StatelessWidget {
  BatteryCard(this.battery);

  final int battery;

  @override
  Widget build(BuildContext context) {
    Icon icon;
    if (battery >= 67) {
      icon = Icon(
        Icons.battery_6_bar,
        color: Colors.green,
        size: 48,
      );
    } else if (battery <= 33) {
      icon = Icon(
        Icons.battery_2_bar,
        color: Colors.red,
        size: 48,
      );
    } else {
      icon = Icon(
        Icons.battery_4_bar,
        color: Colors.orange,
        size: 48,
      );
    }
    return Center(
      child: Card(
        child: ListTile(
          leading: icon,
          title: Text('Niveau de batterie : $battery%',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
