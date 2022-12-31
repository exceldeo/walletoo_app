// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:get_it/get_it.dart';
import 'package:walletoo_app/data/repositories/category_repository.dart';
import 'package:walletoo_app/data/repositories/spending_repository.dart';
import 'package:walletoo_app/data/repositories/wallet_repository.dart';
import 'package:walletoo_app/provider/category_provider.dart';
import 'package:walletoo_app/provider/spending_provider.dart';
import 'package:walletoo_app/provider/wallet_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repository
  sl.registerLazySingleton(() => WalletRepo());
  sl.registerLazySingleton(() => SpendingRepo());
  sl.registerLazySingleton(() => CategoryRepo());

  // Provider
  sl.registerFactory(() => WalletProvider(walletRepo: sl()));
  sl.registerFactory(() => SpendingProvider(spendingRepo: sl()));
  sl.registerFactory(() => CategoryProvider(categoriesRepo: sl()));
}
