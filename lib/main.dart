import 'package:flutter/material.dart';

void main() {
  runApp(const NaturaApp());
}

class NaturaApp extends StatelessWidget {
  const NaturaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Natura',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text(
            'Natura\nDemo APK\nFunctioneaza ✔',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
