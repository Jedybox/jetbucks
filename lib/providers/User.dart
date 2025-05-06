import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  int _userId = 0;
  double _balance = 0.00;
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _recent7daysTransactions = [];
  List<Map<String, dynamic>> _recent4WeeksTransactions = [];
  List<Map<String, dynamic>> _recent6MonthsTransactions = [];
  List<Map<String, dynamic>> _recent1YearTransactions = [];

  String get username => _username;
  int get userId => _userId;
  double get balance => _balance;
  List<Map<String, dynamic>> get transactions => _transactions;
  List<Map<String, dynamic>> get recent7daysTransactions =>
      _recent7daysTransactions;
  List<Map<String, dynamic>> get recent4WeeksTransactions =>
      _recent4WeeksTransactions;
  List<Map<String, dynamic>> get recent6MonthsTransactions =>
      _recent6MonthsTransactions;
  List<Map<String, dynamic>> get recent1YearTransactions =>
      _recent1YearTransactions;

  void getUserData(String username, int userId) {
    _username = username;
    _userId = userId;
    notifyListeners();
  }

  Future<void> refreshUserData() async {
    String username = localStorage.getItem('username') ?? '';
    String password = localStorage.getItem('password') ?? '';

    Dio dio = Dio();

    final response = await dio.get(
      'https://jcash.onrender.com/api/v1/users/login',
      queryParameters: {'username': username, 'password': password},
    );

    if (response.statusCode == 202) {
      final data = response.data;
      _balance = data['currentMoney'] ?? 0.00;
      _userId = data['id'] ?? 0;
      localStorage.setItem("id", _userId.toString());
    }

    final response1 = await dio.get(
      'https://jcash.onrender.com/api/v1/transactions/records',
      queryParameters: {'userId': userId},
    );

    if (response1.statusCode == 200) {
      _transactions =
          List<Map<String, dynamic>>.from(response1.data).reversed.toList();

      _recent7daysTransactions =
          _transactions.where((transaction) {
            DateTime transactionDate = DateTime.parse(
              transaction['transaction_date'],
            );
            DateTime now = DateTime.now();
            Duration difference = now.difference(transactionDate);
            return difference.inDays <= 7;
          }).toList();

      _recent4WeeksTransactions =
          _transactions.where((transaction) {
            DateTime transactionDate = DateTime.parse(
              transaction['transaction_date'],
            );
            DateTime now = DateTime.now();
            Duration difference = now.difference(transactionDate);
            return difference.inDays <= 28;
          }).toList();

      _recent6MonthsTransactions =
          _transactions.where((transaction) {
            DateTime transactionDate = DateTime.parse(
              transaction['transaction_date'],
            );
            DateTime now = DateTime.now();
            Duration difference = now.difference(transactionDate);
            return difference.inDays <= 180;
          }).toList();

      _recent1YearTransactions =
          _transactions.where((transaction) {
            DateTime transactionDate = DateTime.parse(
              transaction['transaction_date'],
            );
            DateTime now = DateTime.now();
            Duration difference = now.difference(transactionDate);
            return difference.inDays <= 365;
          }).toList();
    }

    notifyListeners();
  }
}
