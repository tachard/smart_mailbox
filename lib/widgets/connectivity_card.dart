import 'package:flutter/material.dart';

class ConnectivityCard extends StatelessWidget {
  ConnectivityCard(
      this._scanning, this._discovered, this._connected, this._onNotConnected);

  final bool _scanning;
  final bool _discovered;
  final bool _connected;
  final Function _onNotConnected;

  @override
  Widget build(BuildContext context) {
    Icon icon;
    Text text;

    if (_scanning) {
      icon = Icon(
        Icons.bluetooth_searching,
        color: Colors.amber,
        size: 48,
      );
      text = Text("En recherche de boîte aux lettres",
          style: TextStyle(fontSize: 20));
    }

    if (_discovered) {
      icon = Icon(
        Icons.bluetooth,
        color: Colors.amber,
        size: 48,
      );
      text = Text("Pairage", style: TextStyle(fontSize: 20));
    }
    if (_connected) {
      icon = Icon(
        Icons.bluetooth_connected,
        color: Colors.blue,
        size: 48,
      );
      text = Text("Connecté à la boîte aux lettres",
          style: TextStyle(fontSize: 20));
    } else {
      icon = Icon(
        Icons.bluetooth_disabled,
        color: Colors.red,
        size: 48,
      );
      text = Text("Boîte aux lettres non connectée",
          style: TextStyle(fontSize: 20));
    }

    return InkWell(
        onTap: ((() => !_connected ? _onNotConnected : {})),
        child: Center(
          child: Card(
            child: ListTile(
              leading: icon,
              title: text,
            ),
          ),
        ));
  }
}
