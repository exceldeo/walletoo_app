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
    SpendingModel(
        id: 4,
        name: "spending 4",
        balance: 3000,
        category: CategorySpendingModel(id: 3, name: "category 3"),
        date: DateTime.now().add(Duration(days: 1))),
    SpendingModel(
        id: 5,
        name: "spending 5",
        balance: 3000,
        category: CategorySpendingModel(id: 3, name: "category 3"),
        date: DateTime.now().add(Duration(days: 1))),
    SpendingModel(
        id: 6,
        name: "spending 6",
        balance: 3000,
        category: CategorySpendingModel(id: 3, name: "category 3"),
        date: DateTime.now().add(Duration(days: 2))),
  ];

  List<SpendingModel> get spendings => _spendings;
}
