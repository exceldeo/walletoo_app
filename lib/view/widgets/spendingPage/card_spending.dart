import 'package:flutter/material.dart';
import 'package:walletoo_app/data/models/spending.dart';
import 'package:walletoo_app/data/models/wallet.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/currency_format.dart';
import 'package:walletoo_app/utils/dimensions.dart';
import 'package:walletoo_app/utils/string_resourses.dart';
import 'package:walletoo_app/utils/text_style.dart';

class CardSpendingDaily extends StatelessWidget {
  List<SpendingModel> spendings = [];

  CardSpendingDaily({
    Key? key,
    required this.spendings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Text(
              Strings.spendingList,
              textAlign: TextAlign.left,
              style: CustomTypography.jakartaSans(
                  size: Dimensions.FONT_SIZE_LARGE),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          spendings.length == 0
              ? Container(
                  width: double.infinity,
                  height: 100,
                  child: Center(
                    child: Text(
                      "No Spending",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                        color: ColorResources.COLOR_GREY,
                      ),
                    ),
                  ),
                )
              : Container(
                  constraints: BoxConstraints(minHeight: 100),
                  width: double.infinity,
                  child: Column(
                    children: spendings.map((e) {
                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.name,
                              style: TextStyle(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: ColorResources.COLOR_PRIMARY,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              CurrencyFormat.convertToIdr(e.balance, 0),
                              style: TextStyle(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: ColorResources.COLOR_GREY,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }
}
