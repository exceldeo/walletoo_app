import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletoo_app/data/models/category_spending.dart';
import 'package:walletoo_app/data/models/wallet.dart';
import 'package:walletoo_app/provider/category_provider.dart';
import 'package:walletoo_app/provider/wallet_provider.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/currency_format.dart';
import 'package:walletoo_app/utils/dimensions.dart';
import 'package:walletoo_app/utils/string_resourses.dart';
import 'package:walletoo_app/view/widgets/button.dart';
import 'package:walletoo_app/view/widgets/card_category.dart';
import 'package:walletoo_app/view/widgets/card_wallet_balance.dart';
import 'package:walletoo_app/view/widgets/editText/custom_text_field.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Map<String, TextEditingController> mapTextControllerWallet = {
    "walletName": TextEditingController(),
  };

  Map<String, TextEditingController> mapTextControllerTopUp = {
    "walletId": TextEditingController(),
    "amount": TextEditingController(),
  };

  late String _selectedWalletName = "";

  Map<String, TextEditingController> mapTextControllerCategory = {
    "categoryName": TextEditingController(),
  };

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
                        height: 20,
                      ),
                      Button(
                          ButtonType: 'secondary',
                          ButtonText: Strings.walletAdd,
                          Size: 'md',
                          onPressed: () {
                            _DialogAddWallet(context);
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      Button(
                          ButtonType: 'primary',
                          ButtonText: Strings.topUp,
                          Size: 'md',
                          onPressed: () {
                            _DialogTopUp(context);
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(Strings.categoriesSpending,
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
                          ButtonText: Strings.categoryAdd,
                          ButtonType: 'primary',
                          Size: 'md',
                          onPressed: () {
                            _DialogAddCategory(context);
                          }),
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

  Future<void> _DialogAddWallet(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Wallet Name'),
              content: TextField(
                controller: mapTextControllerWallet["walletName"],
                decoration: InputDecoration(hintText: "Wallet Name"),
              ),
              actions: [
                Button(
                    ButtonType: 'primary',
                    ButtonText: Strings.walletAdd,
                    Size: 'md',
                    onPressed: () {
                      walletProvider.addWallet(
                          walletName:
                              mapTextControllerWallet["walletName"]!.text);
                      mapTextControllerWallet["walletName"]!.clear();
                      Navigator.of(context).pop();
                    }),
              ]);
        });
  }

  Future<void> _DialogTopUp(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('TopUp Wallet'),
              content: Container(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: _selectedWalletName == ""
                          ? null
                          : _selectedWalletName,
                      items: _wallets.map((Wallet wallet) {
                        return DropdownMenuItem(
                          value: wallet.id,
                          child: Text(wallet.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        mapTextControllerTopUp["walletId"]!.text =
                            value.toString();
                        setState(() {});
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: mapTextControllerTopUp["amount"]!,
                      textInputType: TextInputType.number,
                      hintTxt: "Amount",
                      onChanged: (value) {
                        // print(mapTextControllerTopUp["amount"]!.text);
                        setState(() {});
                      },
                    ),
                    Text(CurrencyFormat.convertToIdr(
                        int.parse(mapTextControllerTopUp["amount"]!.text == ""
                            ? "0"
                            : mapTextControllerTopUp["amount"]!.text),
                        0)),
                  ],
                ),
              ),
              actions: [
                Button(
                    ButtonType: 'primary',
                    ButtonText: Strings.topUp,
                    Size: 'md',
                    onPressed: () {
                      if (mapTextControllerTopUp["walletId"]!.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(Strings.spendingAddFormTitleEmpty),
                        ));
                      } else if (mapTextControllerTopUp["amount"]!.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(Strings.spendingAddFormTotalEmpty),
                        ));
                      } else {
                        print(mapTextControllerTopUp["walletId"]!.text +
                            " " +
                            mapTextControllerTopUp["amount"]!.text);
                        walletProvider.topUpWallet(
                            walletId: int.parse(
                                mapTextControllerTopUp["walletId"]!.text),
                            amount: double.parse(
                                mapTextControllerTopUp["amount"]!.text));
                        mapTextControllerTopUp["walletId"]!.clear();
                        mapTextControllerTopUp["amount"]!.clear();
                        _fetchWallets();
                        Navigator.of(context).pop();
                      }
                    }),
              ]);
        });
  }

  Future<void> _DialogAddCategory(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Category Name'),
              content: TextField(
                controller: mapTextControllerCategory["categoryName"],
                decoration: InputDecoration(hintText: "Category Name"),
              ),
              actions: [
                Button(
                    ButtonType: 'primary',
                    ButtonText: Strings.categoryAdd,
                    Size: 'md',
                    onPressed: () {
                      categoryProvider.addCategory(
                          categoryName:
                              mapTextControllerCategory["categoryName"]!.text);
                      mapTextControllerCategory["categoryName"]!.clear();
                      Navigator.of(context).pop();
                    }),
              ]);
        });
  }
}
