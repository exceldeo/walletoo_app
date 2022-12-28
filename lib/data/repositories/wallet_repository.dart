import 'package:walletoo_app/data/models/wallet.dart';

class WalletRepo {
  final List<Wallet> _wallets = [
    Wallet(id: 1, name: "wallet 1", balance: 1000),
    Wallet(id: 2, name: "wallet 2", balance: 2000),
    Wallet(id: 3, name: "wallet 3", balance: 3000),
  ];

  List<Wallet> get wallets => _wallets;
}
