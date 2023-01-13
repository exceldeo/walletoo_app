class CategorySpendingModel {
  late int? id = null;
  late String name;

  CategorySpendingModel({required this.id, required this.name});

  CategorySpendingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class CategoryTotalSpendingModel {
  late String categoryName;
  late int totalSpending;

  CategoryTotalSpendingModel(
      {required this.categoryName, required this.totalSpending});

  CategoryTotalSpendingModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    totalSpending = json['total_spending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_name'] = this.categoryName;
    data['total_spending'] = this.totalSpending;
    return data;
  }
}
