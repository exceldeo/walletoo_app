import 'package:flutter/material.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/dimensions.dart';

class CustomTypography {
  static TextStyle jakartaSans(
      {double? size, Color? color, FontWeight? weight}) {
    return TextStyle(
      color: color ?? ColorResources.COLOR_BLACK,
      fontFamily: 'JakartaSans',
      fontWeight: weight ?? FontWeight.normal,
      fontSize: size ?? Dimensions.FONT_SIZE_DEFAULT,
    );
  }
}
