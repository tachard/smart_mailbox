import 'package:flutter/material.dart';
import 'smart_mailbox.dart';
import 'la_poste_api.dart';

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
