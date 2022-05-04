import 'package:flutter/material.dart';

Color _backgroundColor = const Color.fromARGB(255, 190, 146, 160);

class VenuePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Venue'),
      ),
      body: const Center(
          child: Text(
        'Name of the Venue',
        style: TextStyle(fontSize: 60),
      )),
    );
  }
}
