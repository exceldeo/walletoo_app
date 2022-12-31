import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:walletoo_app/data/models/spending.dart';
import 'package:walletoo_app/provider/spending_provider.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/dimensions.dart';
import 'package:walletoo_app/utils/router_name.dart';
import 'package:walletoo_app/utils/string_resourses.dart';
import 'package:walletoo_app/view/screens/spending/history_screen.dart';
import 'package:walletoo_app/view/widgets/button.dart';
import 'package:walletoo_app/view/widgets/spendingPage/card_spending.dart';

class SpendingScreen extends StatefulWidget {
  SpendingScreen({Key? key}) : super(key: key);

  @override
  State<SpendingScreen> createState() => _SpendingScreenState();
}

class _SpendingScreenState extends State<SpendingScreen> {
  late SpendingProvider spendingProvider;
  late DateTime date = DateTime.now();
  List<SpendingModel> _spendings = [];
  late bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      _fetchSpendings();
      _fetchSpendingsByDate(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(Strings.spending,
                      style: TextStyle(
                        fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                        fontWeight: FontWeight.w300,
                        color: ColorResources.COLOR_PRIMARY,
                      )),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat('dd-MM-yyyy').format(date),
                      style: TextStyle(
                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                        fontWeight: FontWeight.w300,
                        color: ColorResources.COLOR_PRIMARY,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
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
                          onPressed: () {
                            _selectDate(context);
                          },
                          icon: Icon(Icons.calendar_month))),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: CardSpendingDaily(
                      spendings: _spendings,
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            Button(
              ButtonType: 'primary',
              ButtonText: Strings.spendingAdd,
              Size: 'md',
              onPressed: () {
                print("tset");
              },
            ),
            SizedBox(
              height: 20,
            ),
            Button(
              ButtonType: 'secondary',
              ButtonText: Strings.spendingHistory,
              Size: 'md',
              onPressed: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: SpendingHistoryScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
          ],
        ),
      )),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        _fetchSpendingsByDate(date);
      });
    }
  }

  // fetch spending
  Future<void> _fetchSpendings() async {
    spendingProvider = Provider.of<SpendingProvider>(context, listen: false);
    await spendingProvider.fetchSpendings();
  }

  Future<void> _fetchSpendingsByDate(DateTime date) async {
    setState(() {
      isLoading = true;
      _spendings = [];
    });
    spendingProvider = Provider.of<SpendingProvider>(context, listen: false);
    var spendingTemp = await spendingProvider.spendingByDate(date);
    setState(() {
      _spendings = spendingTemp;
      isLoading = false;
    });
  }
}
