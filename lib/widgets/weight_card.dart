import 'package:flutter/material.dart';

class WeightCard extends StatelessWidget {
  WeightCard(this.weight);

  final int weight;

  @override
  Widget build(BuildContext context) {
    TextStyle infoStyle = TextStyle(
      fontSize: 20,
      fontStyle: FontStyle.italic,
    );
    Text info;
    if (weight < 10) {
      info = Text("Peu ou pas de courrier", style: infoStyle);
    } else if (weight >= 10 && weight < 100) {
      info = Text("Une ou plusieurs lettres", style: infoStyle);
    } else if (weight >= 100 && weight < 1000) {
      info = Text("Beaucoup de lettres ou un colis", style: infoStyle);
    } else {
      info = Text("Des lettres et des colis", style: infoStyle);
    }
    return Center(
      child: Card(
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
                    style: TextStyle(fontSize: 20),
                  ),
                  Text('${weight}g',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      )),
                  info,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
