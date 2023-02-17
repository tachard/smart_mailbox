import 'package:flutter/material.dart';

void main() => runApp(const SmartMailboxApp());

class SmartMailboxApp extends StatelessWidget {
  const SmartMailboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Learn',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style =
        theme.textTheme.bodyText2!.copyWith(color: theme.colorScheme.onPrimary);
    Widget page;

    switch (currentPageIndex) {
      case 0:
        page = SmartMailBox();
        break;
      case 1:
        page = LaPosteApi();
        break;
      default:
        throw UnimplementedError("A page with this value is not implemented");
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: theme.colorScheme.surface,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.mail),
            label: 'Boîte aux lettres',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_shipping),
            label: 'Suivi des colis',
          ),
        ],
      ),
      body: page,
    );
  }
}

class SmartMailBox extends StatelessWidget {
  final example = {
    "BatteryLevel": "95",
    "ConnectivityStatus": "2",
    "Weight": "300",
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WeightCard(int.parse(example['Weight']!)),
        BatteryCard(int.parse(example['BatteryLevel']!)),
        ConnectivityCard(int.parse(example["ConnectivityStatus"]!)),
      ],
    );
  }
}

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
              style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}

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

class LaPosteApi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Center(child: Text("API La Poste"))],
    );
  }
}
