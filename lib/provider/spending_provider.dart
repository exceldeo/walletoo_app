import 'package:flutter/material.dart';
import 'package:walletoo_app/data/models/spending.dart';
import 'package:walletoo_app/data/repositories/spending_repository.dart';

class SpendingProvider extends ChangeNotifier {
  final SpendingRepo spendingRepo;
  SpendingProvider({required this.spendingRepo});

  List<SpendingModel> _spendings = [];
  List<SpendingModel> get spendings => _spendings;

  double get balance =>
      _spendings.fold(0, (sum, spending) => sum + spending.balance);

  List<Map<String, dynamic>> get spendingByCategory =>
      _spendings.fold(<Map<String, dynamic>>[],
          (List<Map<String, dynamic>> list, SpendingModel spending) {
        if (list.any((element) => element['id'] == spending.category.id) &&
            list.firstWhere(
                    (element) => element['id'] == spending.category.id) !=
                null) {
          list.firstWhere((element) => element['id'] == spending.category.id)[
              'balance'] = (list.firstWhere((element) =>
                  element['id'] == spending.category.id)['balance']! +
              spending.balance.toInt());
        } else {
          list.add({
            'id': spending.category.id,
            'name': spending.category.name,
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
}
