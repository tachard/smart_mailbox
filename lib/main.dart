import 'package:flutter/material.dart';
import 'screens/smart_mailbox.dart';
import 'screens/la_poste_api.dart';

//Root of the app
void main() => runApp(SmartMailboxApp());

class SmartMailboxApp extends StatelessWidget {
  const SmartMailboxApp({super.key});

  // Every Widget must return a build fonction
  @override
  Widget build(BuildContext context) {
    // MaterialApp allows the use of Material (Google's design system)
    return MaterialApp(
        title: 'Smart Mailbox',
        debugShowCheckedModeBanner:
            false, //By default, show a debug banner. It's now disabled
        theme: ThemeData(
            //Basics design rules applied to whole app
            useMaterial3: true, //Most recent Material version
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.amber)), //Generate a palette based on a color
        home: SafeArea(
          // SafeArea protect overflow with hardware constraints (status bar ...)
          child: BottomNavBar(),
        ));
  }
}

// Whole screen size widget with a bottom navbar and the screen chosen with the nav bar
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // State variables of the widget
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    //Use theme defined before
    var theme = Theme.of(context);
    Widget page;

    // Display screen depending on what user chose
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

    // Scaffold is a multipurpose Widget, that can include a bottom navbar
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: theme.colorScheme.surface,
        // When user clicks, compute what to do
        onDestinationSelected: (int index) {
          //setState allows modifying state variables and recompute the StatefulWidget
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        // All available screens with a label and an icon
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
      // Display the chosen screen
      body: page,
    );
  }
}
