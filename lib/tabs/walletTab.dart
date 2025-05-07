import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jetbucks/dialogs/loadingdialog.dart';
import 'package:provider/provider.dart';

import 'package:jetbucks/providers/User.dart';
import 'package:jetbucks/buttons/squarebutton.dart';
import 'package:jetbucks/screens/transactionpage.dart';

String formatTitle(String title, Map<String, dynamic> transaction, int userID) {
  if (title != 'SEND') return title;

  int sender = transaction['sender'];
  int receiver = transaction['receiver'];

  if (sender == userID) {
    return "Sent Money";
  } else if (receiver == userID) {
    return "Received Money";
  } else {
    return title;
  }
}

bool isIncome(String title) {
  return title == 'CASH-IN' || title == 'Recieved Money';
}

class WalletTab extends StatefulWidget {
  final TabController tabController;

  const WalletTab({super.key, required this.tabController});

  @override
  State<WalletTab> createState() =>
      _WalletTabState(tabController: tabController);
}

class _WalletTabState extends State<WalletTab> {
  final TabController tabController;

  _WalletTabState({required this.tabController});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Wallet",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 47, 17, 85),
                    ),
                  ),
                  Text(
                    "Active",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: GoogleFonts.quicksand().fontFamily,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 69, 25, 125),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: Icon(Icons.restart_alt, color: Colors.white, size: 25),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => showLoadingDialog(context),
                    );

                    context
                        .read<UserProvider>()
                        .refreshUserData()
                        .then((_) {
                          Navigator.of(
                            context,
                          ).pop(); // Close the loading dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Wallet refreshed successfully!"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        })
                        .catchError((error) {
                          Navigator.of(
                            context,
                          ).pop(); // Close the loading dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed to refresh wallet."),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 69, 25, 125),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Stack(
              children: <Widget>[
                // Top-left circle
                Image.asset(
                  "assets/balancebg.png",
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.topLeft,
                ),

                // Card content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Balance info
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Balance",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: GoogleFonts.quicksand().fontFamily,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text.rich(
                            TextSpan(
                              text: "₱",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.quicksand().fontFamily,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      "${context.watch<UserProvider>().balance.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.rubik().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Card info
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Card",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: GoogleFonts.quicksand().fontFamily,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Jetbucks",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.rubik().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  squareButton(
                    icon: Image.asset(
                      "assets/logos/transfer.png",
                      width: 25,
                      height: 25,
                    ),
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionPage(type: 'SEND'),
                          ),
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Send",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: GoogleFonts.quicksand().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(225, 132, 56, 255),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  squareButton(
                    icon: Image.asset(
                      'assets/logos/cash_in.png',
                      width: 25,
                      height: 25,
                    ),
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TransactionPage(type: 'CASH-IN'),
                          ),
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Cash In",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: GoogleFonts.quicksand().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(225, 132, 56, 255),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  squareButton(
                    icon: Image.asset(
                      "assets/logos/cash_out.png",
                      width: 25,
                      height: 25,
                    ),
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TransactionPage(type: 'CASH-OUT'),
                          ),
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Cash Out",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: GoogleFonts.quicksand().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(225, 132, 56, 255),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 47, 17, 85),
                ),
              ),
              TextButton(
                child: Text(
                  "See All",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: GoogleFonts.quicksand().fontFamily,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(225, 132, 56, 255),
                  ),
                ),
                onPressed: () {
                  // Handle "See All" button press
                  tabController.animateTo(2); // Navigate to Status Tab
                },
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                context.watch<UserProvider>().transactions.length > 3
                    ? 3
                    : context.watch<UserProvider>().transactions.length,
            itemBuilder: (context, index) {
              final transaction =
                  context.watch<UserProvider>().transactions[index];

              String title = transaction['transaction_type'];
              DateTime dateTime = DateTime.parse(
                transaction['transaction_date'],
              );
              String formattedDate =
                  "${dateTime.month}/${dateTime.day}/${dateTime.year}";
              double amount = transaction['amount'];

              if (title == 'SEND') {
                title = formatTitle(
                  title,
                  transaction,
                  context.read<UserProvider>().userId,
                );
              }

              return ListTile(
                title: Text(
                  formatTitle(
                    transaction['transaction_type'],
                    transaction,
                    context.read<UserProvider>().userId,
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: GoogleFonts.quicksand().fontFamily,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: GoogleFonts.quicksand().fontFamily,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: Text(
                  isIncome(title)
                      ? "+₱${amount.toStringAsFixed(2)}"
                      : "-₱${amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: GoogleFonts.quicksand().fontFamily,
                    fontWeight: FontWeight.w600,
                    color:
                        isIncome(title)
                            ? Color.fromARGB(255, 117, 202, 65)
                            : Color.fromARGB(255, 255, 51, 51),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
