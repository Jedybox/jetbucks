import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:jetbucks/providers/User.dart';
import 'package:jetbucks/tabs/walletTab.dart';
import 'package:jetbucks/screens/recieptpage.dart';

class NotifTab extends StatefulWidget {
  final int userID;

  const NotifTab({super.key, required this.userID});

  @override
  State<NotifTab> createState() => _NotifTabState(userID: userID);
}

class _NotifTabState extends State<NotifTab> {
  final int userID;

  _NotifTabState({required this.userID});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
      child: Column(
        children: [
          Center(
            child: Text(
              "Notifications",
              style: TextStyle(
                fontSize: 27,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 47, 17, 85),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: Provider.of<UserProvider>(context).transactions.length,
              itemBuilder: (context, index) {
                final transaction =
                    Provider.of<UserProvider>(context).transactions[index];

                String title = transaction['transaction_type'];
                DateTime dateTime = DateTime.parse(
                  transaction['transaction_date'],
                );
                String formattedDate =
                    "${dateTime.month}/${dateTime.day}/${dateTime.year}";

                if (title == 'SEND') {
                  title = formatTitle(
                    title,
                    transaction,
                    Provider.of<UserProvider>(context).userId,
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  RecieptPage(transaction: transaction),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      shadowColor: const Color.fromARGB(255, 47, 17, 85),
                    ),
                    child: ListTile(
                      title: Text(
                        formatTitle(title, transaction, userID),
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 54, 56, 83),
                        ),
                      ),
                      subtitle: Text(
                        formattedDate,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing:
                          isIncome(formatTitle(title, transaction, userID))
                              ? Image.asset(
                                'assets/logos/up.png',
                                width: 30,
                                height: 30,
                              )
                              : Image.asset(
                                'assets/logos/down.png',
                                width: 30,
                                height: 30,
                              ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
