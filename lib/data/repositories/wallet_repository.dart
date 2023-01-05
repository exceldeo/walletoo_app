import 'package:walletoo_app/data/models/wallet.dart';

class WalletRepo {
  final List<Wallet> _wallets = [
    Wallet(id: 1, name: "wallet 1", balance: 1000),
    Wallet(id: 2, name: "wallet 2", balance: 2000),
    Wallet(id: 3, name: "wallet 3", balance: 3000),
  ];

  List<Wallet> get wallets => _wallets;

  void addWallet({required String walletName, double balance = 0}) {
    Wallet wallet =
        Wallet(id: _wallets.length + 1, name: walletName, balance: balance);
    _wallets.add(wallet);
  }

  Wallet getWalletById(int id) {
    return _wallets.firstWhere((element) => element.id == id);
  }

  void topUp({required int walletId, required double amount}) {
    _wallets.firstWhere((wallet) => wallet.id == walletId).balance += amount;
  }
}
