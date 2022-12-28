import 'package:walletoo_app/data/models/category_spending.dart';

class SpendingModel {
  late int id;
  late String name;
  late double balance;
  late CategorySpendingModel category;
  late DateTime date;

  SpendingModel(
      {required this.id,
      required this.name,
      required this.balance,
      required this.category,
      required this.date});

  SpendingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    balance = json['balance'];
    category = (json['category'] != null
        ? new CategorySpendingModel.fromJson(json['category'])
        : null)!;
    date = DateTime.parse(json['date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['balance'] = this.balance;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['date'] = this.date;
    return data;
  }
}
