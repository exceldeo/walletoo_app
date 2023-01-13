import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walletoo_app/data/models/category_spending.dart';
import 'package:walletoo_app/data/models/spending.dart';
import 'package:walletoo_app/data/models/wallet.dart';
import 'package:walletoo_app/provider/database_provider.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/currency_format.dart';
import 'package:walletoo_app/utils/router_name.dart';
import 'package:walletoo_app/utils/string_resourses.dart';
import 'package:walletoo_app/utils/text_style.dart';
import 'package:walletoo_app/view/widgets/button.dart';
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

  late DatabaseProvider databaseProvider;
  late DateTime _selectedDate = DateTime.now();

  late List<WalletModel> _walletList = [];
  late String _selectedWalletName = "";

  late List<CategorySpendingModel> _categoryList = [];
  late String _selectedCategoryName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapTextController["date"]!.text =
        DateFormat("dd/MM/yyyy").format(DateTime.now());
    _selectedDate = DateTime.now();
    // get wallet list
    Future.delayed(Duration.zero, () async {
      await _getWalletList();
      await _getCategoryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                mapTextController["date"]!
                                                            .text ==
                                                        ""
                                                    ? DateTime.now()
                                                    : DateFormat("dd/MM/yyyy")
                                                        .parse(
                                                            mapTextController[
                                                                    "date"]!
                                                                .text),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return Theme(
                                                data:
                                                    ThemeData.light().copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
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
                                            _selectedDate = value;
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
                    SizedBox(
                      height: 10,
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
                              ),
                              value: _selectedWalletName == ""
                                  ? null
                                  : _selectedWalletName,
                              items: _walletList.map((WalletModel wallet) {
                                return DropdownMenuItem(
                                  value: wallet.id,
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              Strings.spendingAddFormCategory,
                              textAlign: TextAlign.left,
                              style: CustomTypography.jakartaSans(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            width: double.infinity,
                            // selected category
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                              ),
                              value: _selectedCategoryName == ""
                                  ? null
                                  : _selectedCategoryName,
                              items: _categoryList
                                  .map((CategorySpendingModel category) {
                                return DropdownMenuItem(
                                  value: category.id,
                                  child: Text(category.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                mapTextController["category"]!.text =
                                    value.toString();
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              Strings.spendingAddFormTitle,
                              textAlign: TextAlign.left,
                              style: CustomTypography.jakartaSans(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            width: double.infinity,
                            child: CustomTextField(
                              controller: mapTextController["title"]!,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              Strings.spendingAddFormTotal,
                              textAlign: TextAlign.left,
                              style: CustomTypography.jakartaSans(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                child: CustomTextField(
                                  controller: mapTextController["total"]!,
                                  textInputType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                              ),
                              Text(CurrencyFormat.convertToIdr(
                                  int.parse(
                                      mapTextController["total"]!.text == ""
                                          ? "0"
                                          : mapTextController["total"]!.text),
                                  0)),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Button(
                  ButtonType: 'primary',
                  ButtonText: Strings.save,
                  Size: 'md',
                  onPressed: () {
                    if (mapTextController["title"]!.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(Strings.spendingAddFormTitleEmpty),
                      ));
                    } else if (mapTextController["total"]!.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(Strings.spendingAddFormTotalEmpty),
                      ));
                    } else if (mapTextController["wallet"]!.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(Strings.spendingAddFormWalletEmpty),
                      ));
                    } else if (mapTextController["category"]!.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(Strings.spendingAddFormCategoryEmpty),
                      ));
                    } else {
                      _addSpending();
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Button(
                  ButtonType: 'secondary',
                  ButtonText: Strings.clear,
                  Size: 'md',
                  onPressed: () {
                    mapTextController["title"]!.text = "";
                    mapTextController["total"]!.text = "";
                    setState(() {});
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _getWalletList() async {
    _walletList = [];
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    await databaseProvider.getWallets();
    setState(() {
      _walletList = databaseProvider.wallets;
    });
  }

  Future<void> _getCategoryList() async {
    _categoryList = [];
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    await databaseProvider.getCategories();
    setState(() {
      _categoryList = databaseProvider.categories;
    });
  }

  Future<void> _addSpending() async {
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    SpendingModel data = SpendingModel(
        name: mapTextController["title"]!.text,
        balance: int.parse(mapTextController["total"]!.text),
        categoryId: int.parse(mapTextController["category"]!.text),
        walletId: int.parse(mapTextController["wallet"]!.text),
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        id: null);
    databaseProvider.addSpending(data);
    Navigator.pop(context);
  }
}
