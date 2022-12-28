import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletoo_app/data/repositories/wallet_repository.dart';
import 'package:walletoo_app/provider/spending_provider.dart';
import 'package:walletoo_app/provider/wallet_provider.dart';
import 'package:walletoo_app/view/screens/startup_screen.dart';
import 'di_container.dart' as di;

Future<void> main() async {
  await di.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => di.sl<WalletProvider>(),
        ),
        ChangeNotifierProvider(create: (context) => di.sl<SpendingProvider>())
      ],
      child: MyApp(),
    ),
  );
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
      home: StartUpScreen(),
    );
  }
}
