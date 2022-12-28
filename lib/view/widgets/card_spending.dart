import 'package:flutter/material.dart';
import 'package:walletoo_app/data/models/wallet.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/currency_format.dart';
import 'package:walletoo_app/utils/dimensions.dart';

class CardSpending extends StatelessWidget {
  final double balance;
  final List<Map<String, dynamic>> spendings;

  const CardSpending({
    Key? key,
    required this.balance,
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
            child: Row(
              children: [
                Text(
                  "From",
                  style: TextStyle(
                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    color: ColorResources.COLOR_GREY,
                  ),
                ),
                Spacer(),
                Text("27 Jan 2021",
                    style: TextStyle(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      color: ColorResources.COLOR_GREY,
                    )),
                IconButton(onPressed: () {}, icon: Icon(Icons.calendar_today))
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  "To",
                  style: TextStyle(
                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    color: ColorResources.COLOR_GREY,
                  ),
                ),
                Spacer(),
                Text("27 Jan 2021",
                    style: TextStyle(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      color: ColorResources.COLOR_GREY,
                    )),
                IconButton(onPressed: () {}, icon: Icon(Icons.calendar_today))
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            child: Text(
              "Total Spending",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                color: ColorResources.COLOR_GREY,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Text(CurrencyFormat.convertToIdr(balance, 0),
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                    fontWeight: FontWeight.bold,
                    color: ColorResources.COLOR_PRIMARY)),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            child: Text(
              "List Spending By Category",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                color: ColorResources.COLOR_GREY,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            child: Column(
                children: spendings.isNotEmpty
                    ? spendings
                        .map(
                          (e) => Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e['name'],
                                  style: TextStyle(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.COLOR_PRIMARY,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  CurrencyFormat.convertToIdr(e['balance'], 0),
                                  style: TextStyle(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.COLOR_GREY,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList()
                    : []),
          ),
        ],
      ),
    );
  }
}
