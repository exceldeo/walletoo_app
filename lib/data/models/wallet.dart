class Wallet {
  late int id;
  late String name;
  late double balance;

  Wallet({required this.id, required this.name, required this.balance});

  Wallet.fromJson(Map<String, dynamic> json) {
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
