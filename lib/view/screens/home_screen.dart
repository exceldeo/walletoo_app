import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:walletoo_app/data/models/category_spending.dart';
import 'package:walletoo_app/data/models/wallet.dart';
import 'package:walletoo_app/provider/database_provider.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/dimensions.dart';
import 'package:walletoo_app/utils/string_resourses.dart';
import 'package:walletoo_app/view/screens/spending/add_spending_screen.dart';
import 'package:walletoo_app/view/widgets/card_spending.dart';
import 'package:walletoo_app/view/widgets/card_wallet_balance.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseProvider databaseProvider;
  int balance = 0;
  int totalSpending = 0;
  List<WalletModel> _wallets = [];
  List<CategoryTotalSpendingModel> _categoryTotalSpendings = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      _fetchWallets();
      _fetchSpendings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _fetchWallets();
        await _fetchSpendings();
      },
      child: Scaffold(
        backgroundColor: ColorResources.COLOR_HOME_BACKGROUND,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Text(Strings.wallet,
                            style: TextStyle(
                              fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                              fontWeight: FontWeight.w300,
                              color: ColorResources.COLOR_PRIMARY,
                            )),
                        IconButton(
                            onPressed: () {
                              _fetchSpendings();
                              _fetchWallets();
                            },
                            icon: Icon(Icons.refresh,
                                size: 30, color: ColorResources.COLOR_PRIMARY)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: CardWalletBalance(
                      balance: balance,
                      wallets: _wallets,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Strings.spending,
                          style: TextStyle(
                            fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                            fontWeight: FontWeight.w300,
                            color: ColorResources.COLOR_PRIMARY,
                          )),
                      Container(
                          decoration: BoxDecoration(
                            color: ColorResources.COLOR_PRIMARY,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                              onPressed: () {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: AddSpendingScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                              icon: Icon(Icons.add,
                                  size: 30, color: ColorResources.COLOR_WHITE)))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: CardSpending(
                          balance: totalSpending,
                          spendings: _categoryTotalSpendings))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchWallets() async {
    balance = 0;
    _wallets = [];
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    await databaseProvider.getWallets();
    await databaseProvider.getBalance();
    setState(() {
      balance = databaseProvider.balance;
      _wallets = databaseProvider.wallets;
    });
  }

  Future<void> _fetchSpendings() async {
    _categoryTotalSpendings = [];
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    await databaseProvider.getCategoryTotalSpending();
    await databaseProvider.getTotalSpending();
    setState(() {
      totalSpending = databaseProvider.totalSpending;
      _categoryTotalSpendings = databaseProvider.categoryTotalSpendings;
    });
  }
}
