import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletoo_app/data/models/category_spending.dart';
import 'package:walletoo_app/data/models/wallet.dart';
import 'package:walletoo_app/provider/category_provider.dart';
import 'package:walletoo_app/provider/wallet_provider.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/dimensions.dart';
import 'package:walletoo_app/view/widgets/button.dart';
import 'package:walletoo_app/view/widgets/card_category.dart';
import 'package:walletoo_app/view/widgets/card_wallet_balance.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late WalletProvider walletProvider;
  double balance = 0;
  List<Wallet> _wallets = [];

  late CategoryProvider categoryProvider;
  List<CategorySpendingModel> _categories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      _fetchWallets();
      _fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _fetchWallets();
        await _fetchCategories();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text("Wallet",
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
                        height: 20,
                      ),
                      Button(
                          ButtonType: 'primary',
                          ButtonText: 'Top Up',
                          Size: 'md',
                          onPressed: () {}),
                      SizedBox(
                        height: 10,
                      ),
                      Button(
                          ButtonType: 'secondary',
                          ButtonText: 'Add Wallet',
                          Size: 'md',
                          onPressed: () {}),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text("Categories Spending",
                            style: TextStyle(
                              fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                              fontWeight: FontWeight.w300,
                              color: ColorResources.COLOR_PRIMARY,
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CardListCategory(
                        categories: _categories,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Button(
                          ButtonText: 'Add Category',
                          ButtonType: 'primary',
                          Size: 'md',
                          onPressed: () {}),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
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

  Future<void> _fetchCategories() async {
    _categories = [];
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.fetchCategories();
    setState(() {
      _categories = categoryProvider.categories;
    });
  }
}
