import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap Titans Lite',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Tap Titans Lite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // TODO: create dynamic enemies
  Random _random = Random();
  int _playerLevel = 1;
  int _playerXp = 0;
  int _titanHp = 25;
  FloatingActionButtonLocation _attackButtonLocation =
      FloatingActionButtonLocation.centerDocked;

  FloatingActionButtonLocation _randomAttackLocation() {
    switch (_random.nextInt(3)) {
      case 1:
        {
          return FloatingActionButtonLocation.centerDocked;
        }
      case 2:
        {
          return FloatingActionButtonLocation.endDocked;
        }
    }

    return FloatingActionButtonLocation.startDocked;
  }

  void _attackTitan() {
    setState(() {
      // TODO: add some RNG to damage dealt
      int _damageDealt = _playerLevel;
      if (_titanHp > _damageDealt) {
        // the player deals normal damage
        _titanHp -= _damageDealt;
      } else {
        // the player gains an XP
        _playerXp++;
        // a new titan spawns
        // TODO: choose a random, level-appropriate monster
        _titanHp = 25;
      }
      if (_playerXp == 4) {
        // the player gains a level
        _playerLevel++;
        _playerXp = 0;
      }
      _attackButtonLocation = _randomAttackLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _attackTitan method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              Text('Your are level $_playerLevel'),
              Text('XP to next level $_playerXp / 4'),
              Spacer(),
              Text('Titan HP'),
              Text(
                '$_titanHp',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(height: 65),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _attackTitan,
          tooltip: 'Attack Titan',
          child: const Icon(
            Icons.api_rounded,
            size: 36,
          ),
        ),
        floatingActionButtonLocation: _attackButtonLocation);
  }
}
