import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:walletoo_app/utils/color_resources.dart';

class Button extends StatelessWidget {
  late String ButtonType;
  late String ButtonText;
  late String Size; // sm, md, lg
  // function callback
  late VoidCallback onPressed;

  Button(
      {Key? key,
      required this.ButtonType,
      required this.ButtonText,
      required this.Size,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Size == "sm"
          ? 30
          : Size == "md"
              ? 40
              : Size == "lg"
                  ? 50
                  : 40,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(ButtonText),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(ButtonType == "primary"
                  ? ColorResources.COLOR_PRIMARY
                  : ButtonType == "secondary"
                      ? ColorResources.color_secondary
                      : ButtonType == "danger"
                          ? ColorResources.COLOR_RED
                          : ColorResources.COLOR_PRIMARY),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      ),
    );
  }
}
