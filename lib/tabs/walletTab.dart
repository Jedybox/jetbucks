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
  return title == 'CASH-IN' || title == 'Received Money';
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
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final balance = userProvider.balance;
    final transactions = userProvider.transactions;
    final userId = userProvider.userId;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Wallet",
                      style: GoogleFonts.rubik(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F1155),
                      ),
                    ),
                    Text(
                      "Active",
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Material(
                  elevation: 4,
                  shape: CircleBorder(),
                  color: Color(0xFF45197D),
                  child: IconButton(
                    icon: Icon(
                      Icons.restart_alt,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => showLoadingDialog(context),
                      );
                      context
                          .read<UserProvider>()
                          .refreshUserData()
                          .then((_) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Wallet refreshed successfully!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          })
                          .catchError((error) {
                            Navigator.of(context).pop();
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
            SizedBox(height: 36),
            // Wallet Card
            Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(
                  colors: [Color(0xFF8438FF), Color(0xFF45197D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.18),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -30,
                    left: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    right: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28.0,
                      vertical: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Balance info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Balance",
                              style: GoogleFonts.quicksand(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "₱${balance.toStringAsFixed(2)}",
                              style: GoogleFonts.roboto(
                                // Roboto supports ₱ well
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        // Card info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Card",
                              style: GoogleFonts.quicksand(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Jetbucks",
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
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
            SizedBox(height: 32),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: "assets/logos/transfer.png",
                  label: "Send",
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionPage(type: 'SEND'),
                        ),
                      ),
                ),
                _ActionButton(
                  icon: "assets/logos/cash_in.png",
                  label: "Cash In",
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TransactionPage(type: 'CASH-IN'),
                        ),
                      ),
                ),
                _ActionButton(
                  icon: "assets/logos/cash_out.png",
                  label: "Cash Out",
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TransactionPage(type: 'CASH-OUT'),
                        ),
                      ),
                ),
              ],
            ),
            SizedBox(height: 36),
            // Recent Transactions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Transactions",
                  style: GoogleFonts.rubik(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2F1155),
                  ),
                ),
                TextButton(
                  child: Text(
                    "See All",
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8438FF),
                    ),
                  ),
                  onPressed: () => tabController.animateTo(2),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Recent Transactions List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: transactions.length > 3 ? 3 : transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                String title = transaction['transaction_type'];
                DateTime dateTime = DateTime.parse(
                  transaction['transaction_date'],
                );
                String formattedDate =
                    "${dateTime.month}/${dateTime.day}/${dateTime.year}";
                double amount = transaction['amount'];

                if (title == 'SEND') {
                  title = formatTitle(title, transaction, userId);
                }

                bool income = isIncome(title);

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          income
                              ? Color(0xFF75CA41).withOpacity(0.15)
                              : Color(0xFFFF3333).withOpacity(0.15),
                      child: Icon(
                        income ? Icons.arrow_downward : Icons.arrow_upward,
                        color: income ? Color(0xFF75CA41) : Color(0xFFFF3333),
                      ),
                    ),
                    title: Text(
                      title,
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2F1155),
                      ),
                    ),
                    subtitle: Text(
                      formattedDate,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Text(
                      (income ? "+₱" : "-₱") + amount.toStringAsFixed(2),
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: income ? Color(0xFF75CA41) : Color(0xFFFF3333),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Custom action button with gradient and elevation
class _ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: 70,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Color(0xFF8438FF), Color(0xFF45197D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon, width: 28, height: 28),
              SizedBox(height: 10),
              Text(
                label,
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
