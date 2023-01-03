import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walletoo_app/data/models/wallet.dart';
import 'package:walletoo_app/provider/wallet_provider.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/string_resourses.dart';
import 'package:walletoo_app/utils/text_style.dart';
import 'package:walletoo_app/view/widgets/custom_appbar.dart';
import 'package:walletoo_app/view/widgets/editText/custom_text_field.dart';

class AddSpendingScreen extends StatefulWidget {
  AddSpendingScreen({Key? key}) : super(key: key);

  @override
  State<AddSpendingScreen> createState() => _AddSpendingScreenState();
}

class _AddSpendingScreenState extends State<AddSpendingScreen> {
  Map<String, TextEditingController> mapTextController = {
    "date": TextEditingController(),
    "wallet": TextEditingController(),
    "category": TextEditingController(),
    "title": TextEditingController(),
    "total": TextEditingController(),
  };

  late WalletProvider walletProvider;
  late List<Wallet> _walletList = [];

  late String _selectedWalletName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapTextController["date"]!.text =
        DateFormat("dd/MM/yyyy").format(DateTime.now());

    // get wallet list
    Future.delayed(Duration.zero, () async {
      await _getWalletList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(children: [
            CustomAppBar(title: Strings.spendingAdd),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: ColorResources.COLOR_WHITE,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
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
                      Strings.spendingAddForm,
                      textAlign: TextAlign.left,
                      style: CustomTypography.jakartaSans(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            Strings.spendingAddFormDate,
                            textAlign: TextAlign.left,
                            style: CustomTypography.jakartaSans(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  mapTextController["date"]!.text,
                                  textAlign: TextAlign.left,
                                  style: CustomTypography.jakartaSans(),
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate:
                                              mapTextController["date"]!.text ==
                                                      ""
                                                  ? DateTime.now()
                                                  : DateFormat("dd/MM/yyyy")
                                                      .parse(mapTextController[
                                                              "date"]!
                                                          .text),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: ColorResources
                                                      .COLOR_PRIMARY,
                                                ),
                                                buttonTheme: ButtonThemeData(
                                                  textTheme:
                                                      ButtonTextTheme.primary,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          }).then((value) {
                                        if (value != null) {
                                          mapTextController["date"]!.text =
                                              DateFormat("dd/MM/yyyy")
                                                  .format(value);
                                          setState(() {});
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      Icons.calendar_today,
                                      color: ColorResources.COLOR_PRIMARY,
                                    ))
                              ],
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            Strings.spendingAddFormWallet,
                            textAlign: TextAlign.left,
                            style: CustomTypography.jakartaSans(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          // selected wallet
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: _selectedWalletName == ""
                                ? null
                                : _selectedWalletName,
                            items: _walletList.map((Wallet wallet) {
                              return DropdownMenuItem(
                                value: wallet,
                                child: Text(wallet.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              mapTextController["wallet"]!.text =
                                  value.toString();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> _getWalletList() async {
    _walletList = [];
    walletProvider = Provider.of<WalletProvider>(context, listen: false);
    await walletProvider.fechWallets();
    setState(() {
      _walletList = walletProvider.wallets;
      print(_walletList.length);
    });
  }
}
