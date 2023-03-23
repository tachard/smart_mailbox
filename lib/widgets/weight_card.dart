import 'package:flutter/material.dart';

class WeightCard extends StatelessWidget {
  WeightCard(this.weight);

  final int weight;

  @override
  Widget build(BuildContext context) {
    var infoStyle = Theme.of(context)
        .textTheme
        .caption!
        .copyWith(fontSize: 20, fontStyle: FontStyle.italic);
    Text info;

    // Choose the info text depending on the weight
    if (weight < 10) {
      info = Text("Peu ou pas de courrier", style: infoStyle);
    } else if (weight >= 10 && weight < 100) {
      info = Text("Une ou plusieurs lettres", style: infoStyle);
    } else if (weight >= 100 && weight < 1000) {
      info = Text("Beaucoup de lettres ou un colis", style: infoStyle);
    } else {
      info = Text("Enormément de lettres et de colis", style: infoStyle);
    }
    
    return Center(
      child: Card(
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
                  Text(
                    '${weight}g',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
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
