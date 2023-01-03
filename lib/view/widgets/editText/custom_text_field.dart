import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/string_resourses.dart';
import 'package:walletoo_app/utils/text_style.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintTxt;
  final TextInputType textInputType;
  final int maxLine;
  final TextInputAction textInputAction;
  final bool isPhoneNumber;
  final bool isEmail;

  const CustomTextField(
      {super.key,
      required this.controller,
      this.hintTxt = '',
      this.textInputType = TextInputType.text,
      this.maxLine = 1,
      this.textInputAction = TextInputAction.next,
      this.isEmail = false,
      this.isPhoneNumber = false});

  @override
  Widget build(context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          TextFormField(
            controller: controller,
            maxLines: maxLine,
            keyboardType: textInputType,
            initialValue: null,
            textInputAction: textInputAction,
            inputFormatters: [
              isPhoneNumber
                  ? FilteringTextInputFormatter.digitsOnly
                  : FilteringTextInputFormatter.singleLineFormatter
            ],
            validator: (input) => isEmail
                ? input!.isValidEmail()
                    ? null
                    : Strings.PLEASE_PROVIDE_A_VALID_EMAIL
                : null,
            decoration: InputDecoration(
              hintText: hintTxt,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
              isDense: true,
              hintStyle: CustomTypography.jakartaSans(),
              errorStyle: const TextStyle(height: 1.5),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              color: ColorResources.COLOR_GAINSBORO,
            ),
          ),
        ],
      ),
    );
  }
}
