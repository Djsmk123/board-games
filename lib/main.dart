import 'package:flutter/material.dart';
import 'package:games/feature/game/presentations/gameview.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GameViewState();
  }
}
