import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('About Page'),
        ),
        body: const Center(
          child: Text('A simple description ;)'),
        ),
      );
}
