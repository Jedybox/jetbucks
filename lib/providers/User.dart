import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:jetbucks/tabs/walletTab.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  int _userId = 0;
  double _balance = 0.00;
  double _totalIncome = 0.00;
  double _totalExpense = 0.00;
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _transactionsPerDay = [];

  String get username => _username;
  int get userId => _userId;
  double get balance => _balance;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  List<Map<String, dynamic>> get transactions => _transactions;
  List<Map<String, dynamic>> get transactionsPerDay => _transactionsPerDay;

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
      queryParameters: {'userId': _userId}, // was `userId`, now `_userId`
    );

    if (response1.statusCode != 200) {
      throw Exception('Failed to fetch transactions');
    }

    _transactions =
        List<Map<String, dynamic>>.from(response1.data).reversed.toList();

    for (Map<String, dynamic> transaction in _transactions) {
      bool income = isIncome(
        formatTitle(transaction['transaction_type'], transaction, _userId),
      );
      DateTime date = DateTime.parse(transaction['transaction_date']);
      String formattedDate = '${date.month}/${date.day}/${date.year}';

      Map<String, dynamic> dayData = {
        'date': formattedDate,
        'amount': income ? transaction['amount'] : -transaction['amount'],
        'transaction_type': transaction['transaction_type'],
      };

      if (_transactionsPerDay.isEmpty) {
        _transactionsPerDay.add(dayData);
      } else {
        bool found = false;
        for (int i = 0; i < _transactionsPerDay.length; i++) {
          if (_transactionsPerDay[i]['date'] == formattedDate) {
            _transactionsPerDay[i]['amount'] +=
                income ? transaction['amount'] : -transaction['amount'];
            found = true;
            break;
          }
        }
        if (!found) {
          _transactionsPerDay.add(dayData);
        }
      }

      if (income) {
        _totalIncome += transaction['amount'];
      } else {
        _totalExpense += -transaction['amount'];
      }
    }

    _transactionsPerDay.sort((a, b) {
      return a['date'].compareTo(b['date']);
    });

    notifyListeners();
  }

  Future<void> cashIn(double amount) async {
    Dio dio = Dio();
    final response = await dio.post(
      'https://jcash.onrender.com/api/v1/transactions/cash-in',
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
      'https://jcash.onrender.com/api/v1/transactions/cash-out',
      data: {
        'transaction_type': 'CASH-OUT',
        'amount': amount,
        "sender": _userId,
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

  Future<void> sendMoney(double amount, int receiverId) async {
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
