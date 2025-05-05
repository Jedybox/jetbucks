import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';

import 'package:jetbucks/tabs/walletTab.dart';
import 'package:jetbucks/tabs/accountTab.dart';
import 'package:jetbucks/dialogs/loadingdialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool userLoggedIn = false;

  double balance = 0.00;
  int userId = 0;

  Future<void> _getUserData() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing manually
      builder: (BuildContext context) => showLoadingDialog(context),
    );

    final username = localStorage.getItem('username');
    final password = localStorage.getItem('password');

    Dio dio = Dio();

    try {
      final response1 = await dio.get(
        'https://jcash.onrender.com/api/v1/users/login',
        queryParameters: {'username': username, 'password': password},
      );

      print(response1.data);

      // Close loading dialog after success
      Navigator.of(context).pop();

      if (response1.statusCode == 202) {
        final data = response1.data;
        setState(() {
          balance = data['currentMoney'] ?? 0.00;
          userId = data['id'] ?? 0;
        });
        if (kDebugMode) {
          print(data.runtimeType);
        }
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to fetch data",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      // Show connection error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Connection error",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!userLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getUserData().then((_) {
          setState(() {
            userLoggedIn = true;
          });
        });
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Wallet Page
          walletTab(tabController: _tabController, balance: balance),
          // Status Page
          Center(
            child: Text(
              "Status",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          // Notification Page
          Center(
            child: Text(
              "Notification",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          // Account Page
          accountTab(context: context, balance: balance),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 69, 25, 125),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 47, 17, 85),
              borderRadius: BorderRadius.circular(50),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.transparent,
              indicatorColor: Colors.white,
              tabs: [
                Image.asset("assets/logos/wallet.png", width: 25, height: 25),
                Image.asset("assets/logos/status.png", width: 25, height: 25),
                Image.asset(
                  "assets/logos/notification.png",
                  width: 25,
                  height: 25,
                ),
                Image.asset("assets/logos/account.png", width: 25, height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
