import 'package:walletoo_app/data/models/category_spending.dart';
import 'package:walletoo_app/data/models/spending.dart';

class SpendingRepo {
  final List<SpendingModel> _spendings = [
    SpendingModel(
        id: 1,
        name: "spending 1",
        balance: 1000,
        category: CategorySpendingModel(id: 1, name: "category 1"),
        date: DateTime.now()),
    SpendingModel(
        id: 2,
        name: "spending 2",
        balance: 2000,
        category: CategorySpendingModel(id: 2, name: "category 2"),
        date: DateTime.now()),
    SpendingModel(
        id: 3,
        name: "spending 3",
        balance: 3000,
        category: CategorySpendingModel(id: 3, name: "category 3"),
        date: DateTime.now()),
  ];

  List<SpendingModel> get spendings => _spendings;
}
