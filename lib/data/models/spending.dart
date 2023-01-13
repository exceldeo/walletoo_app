import 'package:walletoo_app/data/models/category_spending.dart';
import 'package:walletoo_app/data/models/wallet.dart';

class SpendingModel {
  late int? id = null;
  late String name;
  late int balance;
  late int categoryId;
  late int walletId;
  late String date;

  SpendingModel(
      {required this.id,
      required this.name,
      required this.balance,
      required this.categoryId,
      required this.walletId,
      required this.date});

  SpendingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    balance = json['balance'];
    categoryId = json['category_id'];
    walletId = json['wallet_id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['balance'] = this.balance;
    data['category_id'] = this.categoryId;
    data['wallet_id'] = this.walletId;
    data['date'] = this.date;
    return data;
  }
}
