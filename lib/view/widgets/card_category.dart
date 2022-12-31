import 'package:flutter/material.dart';
import 'package:walletoo_app/data/models/category_spending.dart';
import 'package:walletoo_app/data/models/wallet.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/currency_format.dart';
import 'package:walletoo_app/utils/dimensions.dart';

class CardListCategory extends StatelessWidget {
  final List<CategorySpendingModel> categories;

  const CardListCategory({
    Key? key,
    required this.categories,
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
              "Category Spending",
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
            constraints: BoxConstraints(
              minHeight: 100,
            ),
            child: Column(
              mainAxisAlignment: categories.length == 0
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: categories.length == 0
                  ? [Center(child: Text("No data"))]
                  : categories
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
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
