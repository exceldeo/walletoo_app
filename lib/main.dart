import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletoo_app/provider/database_provider.dart';
import 'package:walletoo_app/utils/router_name.dart';
import 'package:walletoo_app/view/screens/spending/add_spending_screen.dart';
import 'package:walletoo_app/view/screens/spending/history_screen.dart';
import 'package:walletoo_app/view/screens/spending_screen.dart';
import 'package:walletoo_app/view/screens/splash/splash_screen.dart';
import 'package:walletoo_app/view/screens/startup_screen.dart';

Future<void> main() async {
  runApp(ChangeNotifierProvider(
    create: (_) => DatabaseProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walletoo App',
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
        primarySwatch: Colors.blue,
      ),
      initialRoute: MyRoute.splash,
      routes: {
        MyRoute.startup: (context) => StartUpScreen(),
        MyRoute.splash: (context) => SplashScreen(),
        MyRoute.spendingHistory: (context) => SpendingHistoryScreen(),
        MyRoute.addSpending: (context) => AddSpendingScreen(),
        MyRoute.spending: (context) => SpendingScreen(),
      },
    );
  }
}
