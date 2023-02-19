import 'package:flutter/material.dart';

class ConnectivityCard extends StatelessWidget {
  ConnectivityCard(this.connectivity);

  final int connectivity;

  @override
  Widget build(BuildContext context) {
    Icon icon;
    Text text;
    switch (connectivity) {
      case 0:
        icon = Icon(
          Icons.bluetooth_disabled,
          color: Colors.red,
          size: 48,
        );
        text = Text("Bluetooth désactivé", style: TextStyle(fontSize: 20));
        break;
      case 1:
        icon = Icon(
          Icons.bluetooth_searching,
          color: Colors.orange,
          size: 48,
        );
        text = Text("Recherche de la boîte aux lettres",
            style: TextStyle(fontSize: 20));
        break;
      case 2:
        icon = Icon(
          Icons.bluetooth_connected,
          color: Colors.blue,
          size: 48,
        );
        text = Text("Connecté à la boîte aux lettres",
            style: TextStyle(fontSize: 20));
        break;
      default:
        throw Exception("Connectivity status $connectivity not implemented");
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
