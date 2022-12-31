import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletoo_app/data/models/wallet.dart';
import 'package:walletoo_app/provider/spending_provider.dart';
import 'package:walletoo_app/provider/wallet_provider.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/dimensions.dart';
import 'package:walletoo_app/utils/string_resourses.dart';
import 'package:walletoo_app/view/widgets/card_spending.dart';
import 'package:walletoo_app/view/widgets/card_wallet_balance.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WalletProvider walletProvider;
  late SpendingProvider spendingProvider;
  double balance = 0;
  double balanceSpending = 0;
  List<Wallet> _wallets = [];
  List<Map<String, dynamic>> _spendings = [];

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
                    child: Text(Strings.wallet,
                        style: TextStyle(
                          fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                          fontWeight: FontWeight.w300,
                          color: ColorResources.COLOR_PRIMARY,
                        )),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: IconButton(
                              onPressed: () {}, icon: Icon(Icons.add)))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: CardSpending(
                          balance: balanceSpending, spendings: _spendings))
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
    walletProvider = Provider.of<WalletProvider>(context, listen: false);
    await walletProvider.fechWallets();
    setState(() {
      balance = walletProvider.balance;
      _wallets = walletProvider.wallets;
    });
  }

  Future<void> _fetchSpendings() async {
    _spendings = [];
    spendingProvider = Provider.of<SpendingProvider>(context, listen: false);
    await spendingProvider.fetchSpendings();
    setState(() {
      balanceSpending = spendingProvider.balance;
      _spendings = spendingProvider.spendingByCategory;
    });
  }
}
