import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:walletoo_app/data/models/category_spending.dart';
import 'package:walletoo_app/data/models/spending.dart';
import 'package:walletoo_app/data/models/wallet.dart';

class DatabaseProvider with ChangeNotifier {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const tableWallet = {
    'table': 'wallet',
    'columnId': 'id',
    'columnName': 'name',
    'columnBalance': 'balance',
  };

  static const tableCategory = {
    'table': 'category',
    'columnId': 'id',
    'columnName': 'name',
  };

  static const tableSpending = {
    'table': 'spending',
    'columnId': 'id',
    'columnName': 'name',
    'columnBalance': 'balance',
    'columnCategoryId': 'category_id',
    'columnWalletId': 'wallet_id',
    'columnDate': 'date',
  };

  Database? _database;
  Future<Database> get database async {
    // full path
    final path = join(await getDatabasesPath(), _databaseName);
    final exists = await databaseExists(path);

    if (exists) {
      // open the database
      _database = await openDatabase(path);
      return _database!;
    }

    // if database exist, copy to assets
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    }

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDb, // will create this separately
    );

    return _database!;
  }

  static const createTableWallet = '''
    CREATE TABLE wallet (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      balance INTEGER NOT NULL
    );
  ''';

  static const createTableCategory = '''
    CREATE TABLE category (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    );
  ''';

  static const createTableSpending = '''
    CREATE TABLE spending (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      balance INTEGER NOT NULL,
      category_id INTEGER NOT NULL,
      wallet_id INTEGER NOT NULL,
      date DATE NOT NULL
    );
  ''';

  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      // category table
      await txn.execute(createTableCategory);
      // wallet table
      await txn.execute(createTableWallet);
      // spending table
      await txn.execute(createTableSpending);
    });
  }

  // categories
  List<CategorySpendingModel> _categories = [];

  List<CategorySpendingModel> get categories => _categories;

  Future<List<CategorySpendingModel>> getCategories() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(tableCategory["table"]!).then((data) {
        // 'data' is our fetched value
        // convert it from "Map<String, object>" to "Map<String, dynamic>"
        final converted = List<Map<String, dynamic>>.from(data);
        // create a 'ExpenseCategory'from every 'map' in this 'converted'
        List<CategorySpendingModel> nList = List.generate(converted.length,
            (index) => CategorySpendingModel.fromJson(converted[index]));
        // set the value of 'categories' to 'nList'
        _categories = nList;
        // return the '_categories'
        return _categories;
      });
    });
  }

  Future<void> addCategory(CategorySpendingModel category) async {
    final db = await database;
    return await db.transaction((txn) async {
      await txn.insert(tableCategory["table"]!, category.toJson());
      notifyListeners();
    });
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    return await db.transaction((txn) async {
      await txn.delete(tableCategory["table"]!,
          where: '${tableCategory["columnId"]} = ?', whereArgs: [id]);
      notifyListeners();
    });
  }

  Future<void> updateCategory(CategorySpendingModel category) async {
    final db = await database;
    return await db.transaction((txn) async {
      await txn.update(tableCategory["table"]!, category.toJson(),
          where: '${tableCategory["columnId"]} = ?', whereArgs: [category.id]);
      notifyListeners();
    });
  }

  // wallets
  List<WalletModel> _wallets = [];

  List<WalletModel> get wallets => _wallets;

  int balance = 0;

  Future<void> getWallets() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(tableWallet["table"]!).then((data) {
        if (data == null) return;
        // 'data' is our fetched value
        // convert it from "Map<String, object>" to "Map<String, dynamic>"
        final converted = List<Map<String, dynamic>>.from(data);
        // create a 'ExpenseCategory'from every 'map' in this 'converted'
        List<WalletModel> nList = List.generate(converted.length,
            (index) => WalletModel.fromJson(converted[index]));
        // set the value of 'categories' to 'nList'
        _wallets = nList;
      });
    });
  }

  Future<void> getBalance() async {
    balance = 0;
    _wallets.forEach((element) {
      balance += element.balance;
    });
  }

  Future<void> getWalletsAndBalance() async {
    await getWallets();
    await getBalance();
  }

  Future<WalletModel?> getWalletByWalletID(int id) async {
    WalletModel? wallet = null;
    _wallets.forEach((element) {
      if (element.id == id) {
        wallet = element;
      }
    });
    return wallet;
  }

  Future<void> addWallet(WalletModel wallet) async {
    final db = await database;
    return await db.transaction((txn) async {
      await txn.insert(tableWallet["table"]!, wallet.toJson());
      notifyListeners();
    });
  }

  Future<void> deleteWallet(int id) async {
    final db = await database;
    return await db.transaction((txn) async {
      await txn.delete(tableWallet["table"]!,
          where: '${tableWallet["columnId"]} = ?', whereArgs: [id]);
      notifyListeners();
    });
  }

  Future<void> updateWallet(WalletModel wallet) async {
    final db = await database;
    return await db.transaction((txn) async {
      await txn.update(tableWallet["table"]!, wallet.toJson(),
          where: '${tableWallet["columnId"]} = ?', whereArgs: [wallet.id]);
      notifyListeners();
    });
  }

  Future<void> topUpWallet({required int walletId, required int amount}) async {
    final db = await database;
    return await db.transaction((txn) async {
      await txn.rawUpdate('''
        UPDATE ${tableWallet["table"]} SET ${tableWallet["columnBalance"]} = ${tableWallet["columnBalance"]} + $amount WHERE ${tableWallet["columnId"]} = $walletId
      ''');
      notifyListeners();
    });
  }

  // spendings
  List<SpendingModel> _spendings = [];
  List<SpendingModel> _spendingsByDateRange = [];
  List<SpendingModel> _spendingsByDate = [];
  List<SpendingModel> _spendingsByCategory = [];
  List<CategoryTotalSpendingModel> _categoryTotalSpendings = [];
  int totalSpending = 0;

  List<SpendingModel> get spendings => _spendings;
  List<SpendingModel> get spendingsByDateRange => _spendingsByDateRange;
  List<SpendingModel> get spendingsByDate => _spendingsByDate;
  List<SpendingModel> get spendingsByCategory => _spendingsByCategory;
  List<CategoryTotalSpendingModel> get categoryTotalSpendings =>
      _categoryTotalSpendings;

  Future<int> getTotalSpending() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.rawQuery('''
        SELECT SUM(${tableSpending["columnBalance"]}) AS total FROM ${tableSpending["table"]}
      ''').then((data) {
        // 'data' is our fetched value
        // convert it from "Map<String, object>" to "Map<String, dynamic>"
        final converted = List<Map<String, dynamic>>.from(data);
        // create a 'ExpenseCategory'from every 'map' in this 'converted'
        List<int> nList = List.generate(
            converted.length, (index) => converted[index]["total"] as int);
        // set the value of 'categories' to 'nList'
        totalSpending = nList[0];
        // return the '_categories'
        return totalSpending;
      });
    });
  }

  Future<List<SpendingModel>> getSpendings() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(tableSpending["table"]!).then((data) {
        // 'data' is our fetched value
        // convert it from "Map<String, object>" to "Map<String, dynamic>"
        final converted = List<Map<String, dynamic>>.from(data);
        // create a 'ExpenseCategory'from every 'map' in this 'converted'
        List<SpendingModel> nList = List.generate(converted.length,
            (index) => SpendingModel.fromJson(converted[index]));
        // set the value of 'categories' to 'nList'
        _spendings = nList;
        // return the '_categories'
        return _spendings;
      });
    });
  }

  Future<List<SpendingModel>> getSpendingsByDateRange(
      String startDate, String endDate) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.rawQuery('''
        SELECT * FROM ${tableSpending["table"]} WHERE ${tableSpending["columnDate"]} BETWEEN '$startDate' AND '$endDate'
      ''').then((data) {
        // 'data' is our fetched value
        // convert it from "Map<String, object>" to "Map<String, dynamic>"
        final converted = List<Map<String, dynamic>>.from(data);
        // create a 'ExpenseCategory'from every 'map' in this 'converted'
        List<SpendingModel> nList = List.generate(converted.length,
            (index) => SpendingModel.fromJson(converted[index]));
        // set the value of 'categories' to 'nList'
        _spendingsByDateRange = nList;
        // return the '_categories'
        return _spendingsByDateRange;
      });
    });
  }

  Future<List<SpendingModel>> getSpendingsByDate(String date) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.rawQuery('''
        SELECT * FROM ${tableSpending["table"]} WHERE ${tableSpending["columnDate"]} BETWEEN '$date' AND '$date'
      ''').then((data) {
        // 'data' is our fetched value
        // convert it from "Map<String, object>" to "Map<String, dynamic>"
        final converted = List<Map<String, dynamic>>.from(data);
        // create a 'ExpenseCategory'from every 'map' in this 'converted'
        List<SpendingModel> nList = List.generate(converted.length,
            (index) => SpendingModel.fromJson(converted[index]));
        // set the value of 'categories' to 'nList'
        _spendingsByDate = nList;
        // return the '_categories'
        return _spendingsByDate;
      });
    });
  }

  Future<List<SpendingModel>> getSpendingsByCategory(int categoryId) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.rawQuery('''
        SELECT * FROM ${tableSpending["table"]} WHERE ${tableSpending["columnCategoryId"]} = $categoryId
      ''').then((data) {
        // 'data' is our fetched value
        // convert it from "Map<String, object>" to "Map<String, dynamic>"
        final converted = List<Map<String, dynamic>>.from(data);
        // create a 'ExpenseCategory'from every 'map' in this 'converted'
        List<SpendingModel> nList = List.generate(converted.length,
            (index) => SpendingModel.fromJson(converted[index]));
        // set the value of 'categories' to 'nList'
        _spendingsByCategory = nList;
        // return the '_categories'
        return _spendingsByCategory;
      });
    });
  }

  Future<void> getCategoryTotalSpending() async {
    final db = await database;
    return await db.transaction((txn) async {
      await txn.rawQuery('''
        SELECT ${tableCategory["table"]}.${tableCategory["columnName"]} AS category_name, SUM(${tableSpending["columnBalance"]}) AS total_spending FROM ${tableSpending["table"]} INNER JOIN ${tableCategory["table"]} ON ${tableSpending["columnCategoryId"]} = ${tableCategory["table"]}.${tableCategory["columnId"]} GROUP BY ${tableSpending["columnCategoryId"]}
      ''').then((data) {
        if (data == null) return;
        // 'data' is our fetched value
        // convert it from "Map<String, object>" to "Map<String, dynamic>"
        final converted = List<Map<String, dynamic>>.from(data);
        // create a 'ExpenseCategory'from every 'map' in this 'converted'
        List<CategoryTotalSpendingModel> nList = List.generate(converted.length,
            (index) => CategoryTotalSpendingModel.fromJson(converted[index]));
        // set the value of 'categories' to 'nList'
        _categoryTotalSpendings = nList;
        // return the '_categories'
        // return _categoryTotalSpendings;
      });
    });
  }

  Future<void> addSpending(SpendingModel spending) async {
    final db = await database;
    return await db.transaction((txn) async {
      getWalletByWalletID(spending.walletId).then((value) {
        if (value == null) return;
        value.balance = value.balance - spending.balance;
        updateWallet(value);
      });
      await txn.insert(tableSpending["table"]!, spending.toJson());
      notifyListeners();
    });
  }

  Future<void> deleteSpending(int id) async {
    final db = await database;
    return await db.transaction((txn) async {
      await txn.delete(tableSpending["table"]!,
          where: '${tableSpending["columnId"]} = ?', whereArgs: [id]);
      notifyListeners();
    });
  }

  Future<void> updateSpending(SpendingModel spending) async {
    final db = await database;
    return await db.transaction((txn) async {
      await txn.update(tableSpending["table"]!, spending.toJson(),
          where: '${tableSpending["columnId"]} = ?', whereArgs: [spending.id]);
      notifyListeners();
    });
  }
}
