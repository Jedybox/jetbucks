import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  int _userId = 0;
  double _balance = 0.00;
  List<Map<String, dynamic>> _transactions = [];

  String get username => _username;
  int get userId => _userId;
  double get balance => _balance;
  List<dynamic> get transactions => _transactions;

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
}
