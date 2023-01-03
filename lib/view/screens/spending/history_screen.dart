import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walletoo_app/data/models/category_spending.dart';
import 'package:walletoo_app/data/models/spending.dart';
import 'package:walletoo_app/provider/spending_provider.dart';
import 'package:walletoo_app/utils/color_resources.dart';
import 'package:walletoo_app/utils/string_resourses.dart';
import 'package:walletoo_app/utils/text_style.dart';
import 'package:walletoo_app/view/widgets/button_icon.dart';
import 'package:walletoo_app/view/widgets/card_spending_history.dart';
import 'package:walletoo_app/view/widgets/custom_appbar.dart';

class SpendingHistoryScreen extends StatefulWidget {
  SpendingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SpendingHistoryScreen> createState() => _SpendingHistoryScreenState();
}

class _SpendingHistoryScreenState extends State<SpendingHistoryScreen> {
  late SpendingProvider spendingProvider;
  late DateTimeRange _dateRange;
  List<List<SpendingModel>> _spendingListByDateRange = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateRange = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 30)),
      end: DateTime.now(),
    );

    // get spending list by date range
    Future.delayed(Duration.zero, () async {
      await _getSpendingListByDateRange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _getSpendingListByDateRange();
      },
      child: Scaffold(
        backgroundColor: ColorResources.COLOR_HOME_BACKGROUND,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                CustomAppBar(title: Strings.spendingHistory),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'From: ${DateFormat('dd/MM/yyyy').format(_dateRange.start)}',
                        style: CustomTypography.jakartaSans(),
                      ),
                      Text(
                          'To: ${DateFormat('dd/MM/yyyy').format(_dateRange.end)}',
                          style: CustomTypography.jakartaSans()),
                      Container(
                          decoration: BoxDecoration(
                            color: ColorResources.COLOR_PRIMARY,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                              onPressed: () {
                                _selectDateRange(context);
                              },
                              icon: Icon(Icons.calendar_month,
                                  size: 25,
                                  color: ColorResources.COLOR_WHITE))),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // list of spending
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _spendingListByDateRange.length,
                    itemBuilder: (context, index) {
                      return CardSpendingHistory(
                          date: _spendingListByDateRange[index][0].date,
                          spendingList: _spendingListByDateRange[index]);
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // function date picker range
  void _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        initialDateRange: _dateRange,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.highContrastLight(
                primary: ColorResources.COLOR_PRIMARY,
                onPrimary: ColorResources.COLOR_WHITE,
                surface: ColorResources.COLOR_PRIMARY,
                onSurface: ColorResources.COLOR_PRIMARY,
              ),
              dialogBackgroundColor: ColorResources.COLOR_WHITE,
            ),
            child: child!,
          );
        });
    if (picked != null && picked != _dateRange)
      setState(() {
        _dateRange = picked;
        _getSpendingListByDateRange();
      });
  }

  Future<void> _getSpendingListByDateRange() async {
    _spendingListByDateRange = [];
    spendingProvider = Provider.of<SpendingProvider>(context, listen: false);
    spendingProvider.fetchSpendingsByDateRange(_dateRange);
    setState(() {
      _spendingListByDateRange = spendingProvider.spendingsByDateRange;
    });
  }
}
