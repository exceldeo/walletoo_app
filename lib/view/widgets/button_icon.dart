import 'package:flutter/material.dart';
import 'package:walletoo_app/utils/color_resources.dart';

class CustomButtonIcon extends StatelessWidget {
  late IconData iconData;
  late VoidCallback onPressedData;

  CustomButtonIcon(
      {Key? key, required this.iconData, required this.onPressedData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: IconButton(
            onPressed: onPressedData,
            icon: Icon(
              iconData,
              color: ColorResources.COLOR_PRIMARY,
            )));
  }
}
