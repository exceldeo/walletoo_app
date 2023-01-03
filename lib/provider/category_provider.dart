import 'package:flutter/material.dart';
import 'package:walletoo_app/data/models/category_spending.dart';
import 'package:walletoo_app/data/models/spending.dart';
import 'package:walletoo_app/data/repositories/category_repository.dart';
import 'package:walletoo_app/data/repositories/spending_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo categoriesRepo;
  CategoryProvider({required this.categoriesRepo});

  List<CategorySpendingModel> _categories = [];
  List<CategorySpendingModel> get categories => _categories;

  Future<void> fetchCategories() async {
    _categories = categoriesRepo.categories;
    notifyListeners();
  }

  Future<void> addCategory(CategorySpendingModel category) async {
    categoriesRepo.addCategory(category);
    _categories = categoriesRepo.categories;
    notifyListeners();
  }
}
