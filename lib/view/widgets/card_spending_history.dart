import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walletoo_app/data/models/spending.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/currency_format.dart';
import 'package:walletoo_app/utils/dimensions.dart';
import 'package:walletoo_app/utils/string_resourses.dart';
import 'package:walletoo_app/utils/text_style.dart';

class CardSpendingHistory extends StatelessWidget {
  late String date;
  List<SpendingModel> spendingList;

  CardSpendingHistory(
      {Key? key, required this.date, required this.spendingList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
              DateFormat('EEEE, dd MMMM yyyy').format(DateTime.parse(date)),
              textAlign: TextAlign.left,
              style: CustomTypography.jakartaSans(
                  size: Dimensions.FONT_SIZE_LARGE),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            child: Text(
              Strings.spendingList,
              textAlign: TextAlign.left,
              style: CustomTypography.jakartaSans(
                  size: Dimensions.FONT_SIZE_SMALL),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            child: Column(
              children: spendingList
                  .map(
                    (e) => Container(
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
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.total,
                  style: CustomTypography.jakartaSans(),
                ),
                Text(
                  CurrencyFormat.convertToIdr(
                      spendingList.fold(0, (a, b) => a + b.balance.toInt()), 0),
                  style: CustomTypography.jakartaSans(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
