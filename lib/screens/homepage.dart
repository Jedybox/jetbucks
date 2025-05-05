import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jetbucks/tabs/walletTab.dart';
import 'package:jetbucks/tabs/accountTab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          walletTab(tabController: _tabController),
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
          accountTab(context: context),
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
