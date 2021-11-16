import 'package:flutter/material.dart';

import 'drawer.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: MainPage(),
  ));
}

class MainPage extends StatefulWidget {
  static const String title = 'Phone Connect';

  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Phone Connect'),
        ),
        drawer: const AppDrawer(),
        body: const Center(
          child: Text(
            'test',
            style: TextStyle(
              fontSize: 32,
            ),
          ),
        ));
  }
}
