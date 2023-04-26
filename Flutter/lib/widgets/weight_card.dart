// Read weight characteristic, then print it.

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class WeightCard extends StatefulWidget {
  WeightCard({super.key, required this.ble, required this.weight});

  final QualifiedCharacteristic weight;
  final FlutterReactiveBle ble;

  @override
  State<WeightCard> createState() => _WeightCardState();
}

class _WeightCardState extends State<WeightCard> {
  @override
  Widget build(BuildContext context) {
    // Reused info text style
    var infoStyle = Theme.of(context)
        .textTheme
        .caption!
        .copyWith(fontSize: 20, fontStyle: FontStyle.italic);

    // Build depending of Future solve.
    return StreamBuilder(
        stream: widget.ble.subscribeToCharacteristic(widget.weight),
        builder: (context, snapshot) {
          Widget central;
          String info;
          if (snapshot.hasError) {
            central = Icon(Icons.error_outline,
                size: 96, color: Theme.of(context).colorScheme.error);
            info = "Erreur de récupération du poids.";
          } else {
            print(snapshot.connectionState);
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                // weight can be read.
                // Choose the info text depending on the weight
                var weight = int.parse(String.fromCharCodes(snapshot.data!));
                if (weight < 10) {
                  info = "Peu ou pas de courrier";
                } else if (weight >= 10 && weight < 100) {
                  info = "Une ou plusieurs lettres";
                } else if (weight >= 100 && weight < 1000) {
                  info = "Beaucoup de lettres ou un colis";
                } else {
                  info = "Enormément de lettres et de colis";
                }
                central = Text(
                  '${weight}g',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                );
                break;
              default:
                central = CircularProgressIndicator();
                info = "Chargement du poids dans la boîte.";
            }
          }
          return Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox.square(
                dimension: MediaQuery.of(context).size.width * 0.95,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Poids du courrier :",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      central,
                      Text(info, style: infoStyle),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
