import 'package:flutter/material.dart';
import 'package:walletoo_app/data/models/spending.dart';
import 'package:walletoo_app/data/repositories/category_repository.dart';
import 'package:walletoo_app/data/repositories/spending_repository.dart';

class SpendingProvider extends ChangeNotifier {
  final SpendingRepo spendingRepo;
  final CategoryRepo categoryRepo;
  SpendingProvider({required this.spendingRepo, required this.categoryRepo});

  List<SpendingModel> _spendings = [];
  List<SpendingModel> get spendings => _spendings;

  List<List<SpendingModel>> _spendingsByDateRange = [];
  List<List<SpendingModel>> get spendingsByDateRange => _spendingsByDateRange;

  List<SpendingModel> _spendingsByDate = [];
  List<SpendingModel> get spendingsByDate => _spendingsByDate;

  double get balance =>
      _spendings.fold(0, (sum, spending) => sum + spending.balance);

  List<Map<String, dynamic>> get spendingByCategory =>
      _spendings.fold(<Map<String, dynamic>>[],
          (List<Map<String, dynamic>> list, SpendingModel spending) {
        if (list.any((element) => element['id'] == spending.categoryId)) {
          list.firstWhere((element) => element['id'] == spending.categoryId)[
              'balance'] = (list.firstWhere((element) =>
                  element['id'] == spending.categoryId)['balance']! +
              spending.balance.toInt());
        } else {
          list.add({
            'id': spending.categoryId,
            'name': categoryRepo.getCategoryById(spending.categoryId).name,
            'balance': spending.balance.toInt()
          });
        }
        return list;
      });

  Future<void> fetchSpendings() async {
    _spendings = spendingRepo.spendings;
    notifyListeners();
  }

  void addSpending(SpendingModel spending) {
    _spendings.add(spending);
  }

  void removeSpending(SpendingModel spending) {
    _spendings.remove(spending);
  }

  void updateSpending(SpendingModel spending) {
    _spendings[_spendings.indexWhere((element) => element.id == spending.id)] =
        spending;
  }

  void clearSpendings() {
    _spendings.clear();
  }

  Future<void> fetchSpendingsByDate(DateTime date) async {
    _spendingsByDate = spendingByDate(date);
    notifyListeners();
  }

  List<SpendingModel> spendingByDate(DateTime date) {
    return _spendings
        .where((element) =>
            element.date.year == date.year &&
            element.date.month == date.month &&
            element.date.day == date.day)
        .toList();
  }

  Future<void> fetchSpendingsByDateRange(DateTimeRange dateRange) async {
    _spendingsByDateRange = spendingByDateRange(dateRange);
    notifyListeners();
  }

  List<List<SpendingModel>> spendingByDateRange(DateTimeRange dateRange) {
    List<List<SpendingModel>> spendingsByDateRange = [];
    for (int i = dateRange.duration.inDays; i >= 0; i--) {
      List<SpendingModel> spendings =
          spendingByDate(dateRange.start.add(Duration(days: i)));
      if (spendings.isNotEmpty) spendingsByDateRange.add(spendings);
    }
    return spendingsByDateRange;
  }
}
