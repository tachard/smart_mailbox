import 'package:flutter/material.dart';

class ConnectivityCard extends StatelessWidget {
  ConnectivityCard(this._connected, this._scanStarted);

  final bool _connected;
  final bool _scanStarted;

  @override
  Widget build(BuildContext context) {
    Icon icon;
    Text text;
    if (_scanStarted) {
      icon = Icon(
        Icons.bluetooth_searching,
        color: Colors.amber,
        size: 48,
      );
      text = Text("En recherche de boîte aux lettres",
          style: TextStyle(fontSize: 20));
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
      text = Text("Boîte au lettres non connectée",
          style: TextStyle(fontSize: 20));
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
