import 'package:flutter/material.dart';
import 'package:walletoo_app/data/models/wallet.dart';
import 'package:walletoo_app/data/repositories/wallet_repository.dart';

class WalletProvider extends ChangeNotifier {
  final WalletRepo walletRepo;
  WalletProvider({required this.walletRepo});

  List<Wallet> wallets = [];

  double balance = 0;

  Future<void> fechWallets() async {
    wallets = walletRepo.wallets;
    balance = wallets.fold(0, (sum, wallet) => sum + wallet.balance);
    notifyListeners();
  }

  void addWallet(Wallet wallet) {
    wallets.add(wallet);
    notifyListeners();
  }

  void removeWallet(Wallet wallet) {
    wallets.remove(wallet);
    notifyListeners();
  }

  void updateWallet(Wallet wallet) {
    wallets[wallets.indexOf(wallet)] = wallet;
    notifyListeners();
  }

  void topUp(int idWallet, double amount) {
    wallets.firstWhere((wallet) => wallet.id == idWallet).balance += amount;
    notifyListeners();
  }
}
