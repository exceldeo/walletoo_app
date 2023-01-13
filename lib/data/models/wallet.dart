class WalletModel {
  late int? id = null;
  late String name;
  late int balance;

  WalletModel({required this.id, required this.name, required this.balance});

  WalletModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['balance'] = this.balance;
    return data;
  }
}
