import 'package:flutter/material.dart';
import 'screens/smart_mailbox.dart';

//Root of the app
void main() => runApp(const SmartMailboxApp());

class SmartMailboxApp extends StatelessWidget {
  const SmartMailboxApp({super.key});

  // Every Widget must return a build fonction
  @override
  Widget build(BuildContext context) {
    // MaterialApp allows the use of Material (Google's design system)
    return MaterialApp(
        title: 'Smart Mailbox',
        debugShowCheckedModeBanner:
            false, //By default, show a debug banner. It's now disabled.
        theme: ThemeData(
            //Basics design rules applied to whole app
            useMaterial3: true, //Most recent Material version
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.amber)), //Generate a palette based on a color
        home: Scaffold(
          appBar: AppBar(
              leading: const Icon(Icons.mail_outline),
              title: const Text("Smart Mailbox"),
              backgroundColor: Colors.amber),
          body: const SmartMailBox(),
        ));
  }
}
