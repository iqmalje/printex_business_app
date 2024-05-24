import 'package:flutter/material.dart';
import 'package:printex_business_app/model/apm.dart';
import 'package:printex_business_app/model/bank.dart';

class ListAPMProvider extends ChangeNotifier {
  List<APM> apm = [];

  ListAPMProvider();

  void changeAPM({required List<APM> newAPM}) async {
    apm = newAPM;

    notifyListeners();
  }
}

class BankDetailsProvider extends ChangeNotifier {
  Bank bank = Bank(
      bankName: 'Iqmal Aizat', bankNumber: '0024 2644 1244', bank: 'Maybank');

  BankDetailsProvider();

  void changeBank({required Bank newBank}) async {
    bank = newBank;

    notifyListeners();
  }
}
