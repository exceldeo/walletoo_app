import 'package:walletoo_app/data/models/category_spending.dart';

class CategoryRepo {
  final List<CategorySpendingModel> _categories = [
    CategorySpendingModel(id: 1, name: "category 1"),
    CategorySpendingModel(id: 2, name: "category 2"),
    CategorySpendingModel(id: 3, name: "category 3"),
  ];

  List<CategorySpendingModel> get categories => _categories;
}
