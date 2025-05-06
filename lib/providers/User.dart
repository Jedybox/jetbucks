import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
    }

    notifyListeners();
  }

  void distributeTransactions() {
    _recent7daysTransactions =
        _transactions
            .where(
              (transaction) => DateTime.parse(
                transaction['date'],
              ).isAfter(DateTime.now().subtract(Duration(days: 7))),
            )
            .toList();

    _recent4WeeksTransactions =
        _transactions
            .where(
              (transaction) => DateTime.parse(
                transaction['date'],
              ).isAfter(DateTime.now().subtract(Duration(days: 28))),
            )
            .toList();

    _recent6MonthsTransactions =
        _transactions
            .where(
              (transaction) => DateTime.parse(
                transaction['date'],
              ).isAfter(DateTime.now().subtract(Duration(days: 180))),
            )
            .toList();

    _recent1YearTransactions =
        _transactions
            .where(
              (transaction) => DateTime.parse(
                transaction['date'],
              ).isAfter(DateTime.now().subtract(Duration(days: 365))),
            )
            .toList();
  }

  Future<void> cashIn(double amount) async {
    Dio dio = Dio();
    final response = await dio.post(
      'https://jcash.onrender.com/api/v1/transactions/cashIn',
      data: {
        'transaction_type': 'CASH-IN',
        'amount': amount,
        "receiver": _userId,
      },
    );

    if (response.statusCode == 200) {
      _balance += amount;
      refreshUserData().catchError((_) {
        throw Exception('Failed to refresh user data after cash in');
      });
      notifyListeners();
      return;
    }

    throw Exception('Failed to cash in');
  }

  Future<void> cashOut(double amount) async {
    Dio dio = Dio();
    final response = await dio.post(
      'https://jcash.onrender.com/api/v1/transactions/cashOut',
      data: {
        'transaction_type': 'CASH-OUT',
        'amount': amount,
        "receiver": _userId,
      },
    );

    if (response.statusCode == 200) {
      _balance -= amount;
      refreshUserData().catchError((_) {
        throw Exception('Failed to refresh user data after cash out');
      });
      notifyListeners();
      return;
    }

    throw Exception('Failed to cash out');
  }

  Future<void> sendMoney(double amount, String receiverId) async {
    Dio dio = Dio();
    final response = await dio.post(
      'https://jcash.onrender.com/api/v1/transactions/send-money',
      data: {
        'transaction_type': 'SEND',
        'amount': amount,
        "receiver": receiverId,
        "sender": _userId,
      },
    );

    if (response.statusCode == 200) {
      _balance -= amount;
      refreshUserData().catchError((_) {
        throw Exception('Failed to refresh user data after sending money');
      });
      notifyListeners();
      return;
    }

    throw Exception('Failed to send money');
  }
}
