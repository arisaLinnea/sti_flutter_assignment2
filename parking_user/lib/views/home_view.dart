import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        // appBar: AppBar(title: const Text('Home')),
        body: Center(
          child: Text(
            'Welcome to Find Me A Spot',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
}
