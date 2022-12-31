import 'package:flutter/material.dart';
import 'package:walletoo_app/utils/string_resourses.dart';
import 'package:walletoo_app/view/widgets/custom_appbar.dart';

class SpendingHistoryScreen extends StatefulWidget {
  SpendingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SpendingHistoryScreen> createState() => _SpendingHistoryScreenState();
}

class _SpendingHistoryScreenState extends State<SpendingHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: Strings.spendingHistory),
            const Center(
              child: Text('Spending History'),
            ),
          ],
        ),
      ),
    );
  }
}
