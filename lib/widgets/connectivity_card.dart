import 'package:flutter/material.dart';

class ConnectivityCard extends StatelessWidget {
  ConnectivityCard(this._scanning, this._discovered, this._connected);

  final bool _scanning;
  final bool _discovered;
  final bool _connected;

  @override
  Widget build(BuildContext context) {
    Icon icon;
    Text text;

    // Choose icon and text depending on the state of the system.
    if (_scanning) {
      icon = Icon(
        Icons.bluetooth_searching,
        color: Colors.amber,
        size: 48,
      );
      text = Text("En recherche de boîte aux lettres",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold));
    }

    if (_discovered) {
      icon = Icon(
        Icons.bluetooth,
        color: Colors.amber,
        size: 48,
      );
      text = Text("Pairage",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold));
    }
    if (_connected) {
      icon = Icon(
        Icons.bluetooth_connected,
        color: Colors.blue,
        size: 48,
      );
      text = Text("Connecté à la boîte aux lettres",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold));
    } else {
      icon = Icon(
        Icons.bluetooth_disabled,
        color: Colors.red,
        size: 48,
      );
      text = Text("Boîte aux lettres non connectée. Se connecter ?",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold));
    }

    return Center(
      child: Card(
        child: ListTile(
          leading: icon,
          title: text,
        ),
      ),
    );
  }
}
