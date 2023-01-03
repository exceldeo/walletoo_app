import 'package:flutter/material.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/dimensions.dart';
import 'package:walletoo_app/utils/text_style.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorResources.COLOR_PRIMARY,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Container(
              padding: EdgeInsets.only(left: 3),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: ColorResources.COLOR_WHITE,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              title,
              style: CustomTypography.jakartaSans(
                  size: Dimensions.FONT_SIZE_EXTRA_LARGE,
                  weight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
