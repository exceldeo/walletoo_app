import 'dart:async';

import 'package:flutter/material.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/images_resources.dart';
import 'package:walletoo_app/utils/router_name.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, MyRoute.startup);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.COLOR_WHITE,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              MyImages.splashLogo,
              height: 300,
              width: 320,
            ),
            // loading indicator
            CircularProgressIndicator(
              color: ColorResources.COLOR_PRIMARY,
            ),
          ],
        ),
      ),
    );
  }
}
