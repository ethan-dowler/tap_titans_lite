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
  // RNG
  final Random _random = Random();

  // player init
  int _playerLevel = 1;
  int _playerXp = 0;
  int _xpToNextLevel = 100;

  // titan init
  int _titanMaxHp = 5;
  int _titanCurrentHp = 5;

  // UI init
  FloatingActionButtonLocation _attackButtonLocation =
      FloatingActionButtonLocation.centerDocked;

  FloatingActionButtonLocation _randomAttackLocation() {
    switch (_random.nextInt(3)) {
      case 1:
        {
          return FloatingActionButtonLocation.startDocked;
        }
      case 2:
        {
          return FloatingActionButtonLocation.endDocked;
        }
    }

    return FloatingActionButtonLocation.centerDocked;
  }

  void _attackTitan() {
    setState(() {
      bool isCrit = _random.nextInt(20) == 0;
      int damageDealt = isCrit ? _playerLevel * 2 : _playerLevel;
      // TODO: display damage numbers; emphasize if it's a crit
      if (_titanCurrentHp > damageDealt) {
        // the player deals damage to the titan
        _titanCurrentHp -= damageDealt;
      } else {
        // the player defeats the titan!

        // the player gains XP
        // TODO: display XP gained
        int xpGained = _titanMaxHp * 2;
        int extraXp = xpGained - (_xpToNextLevel - _playerXp);
        _playerXp += xpGained;

        // the player gains a level if they have enough XP
        if (_playerXp >= _xpToNextLevel) {
          _playerLevel++;
          // XP carries over from one level to the next
          _playerXp = extraXp;
          _xpToNextLevel = (_xpToNextLevel * 1.4).round();
        }

        // a new titan spawns
        _titanMaxHp = (_playerLevel * 3) + _random.nextInt(_playerLevel);
        _titanCurrentHp = _titanMaxHp;
      }

      // move the attack button!
      _attackButtonLocation = _randomAttackLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              Text('XP $_playerXp / $_xpToNextLevel'),
              Spacer(),
              Text('Titan HP'),
              Text(
                '$_titanCurrentHp / $_titanMaxHp',
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
