import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:jetbucks/tabs/walletTab.dart'; // Ensure this file defines a class named Wallettab
import 'package:jetbucks/tabs/accountTab.dart';
import 'package:jetbucks/tabs/notifTab.dart';
import 'package:jetbucks/tabs/chartTab.dart';
import 'package:jetbucks/dialogs/loadingdialog.dart';
import 'package:jetbucks/providers/User.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> transactions = [];
  bool userLoggedIn = false;

  double balance = 0.00;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    if (!userLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => showLoadingDialog(context),
        );
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider
            .refreshUserData()
            .then(
              (_) => Navigator.of(context).pop(), // Close the loading dialog
            )
            .catchError((error) {
              Navigator.of(context).pop(); // Close the loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: $error"),
                  backgroundColor: Colors.red,
                ),
              );
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
          WalletTab(tabController: _tabController),
          // Status Page
          ChartTab(),
          // Notification Page
          NotifTab(userID: userId),
          // Account Page
          accountTab(context: context, balance: balance),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BottomAppBar(
            color: Color(0xFF2F1155),
            elevation: 0,
            child: SizedBox(
              height: 70,
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Color(0xFF6C3DD1),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6C3DD1).withOpacity(0.25),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.6),
                labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
                tabs: [
                  Tab(
                    icon: Image.asset(
                      "assets/logos/wallet.png",
                      width: 28,
                      height: 28,
                      color: null,
                    ),
                    text: "Wallet",
                  ),
                  Tab(
                    icon: Image.asset(
                      "assets/logos/status.png",
                      width: 28,
                      height: 28,
                      color: null,
                    ),
                    text: "Status",
                  ),
                  Tab(
                    icon: Image.asset(
                      "assets/logos/notification.png",
                      width: 28,
                      height: 28,
                      color: null,
                    ),
                    text: "Alerts",
                  ),
                  Tab(
                    icon: Image.asset(
                      "assets/logos/account.png",
                      width: 28,
                      height: 28,
                      color: null,
                    ),
                    text: "Account",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
