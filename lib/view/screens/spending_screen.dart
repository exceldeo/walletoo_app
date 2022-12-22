import 'package:flutter/material.dart';

class SpendingScreen extends StatefulWidget {
  SpendingScreen({Key? key}) : super(key: key);

  @override
  State<SpendingScreen> createState() => _SpendingScreenState();
}

class _SpendingScreenState extends State<SpendingScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Spending Screen'),
    );
  }
}
