import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'package:jetbucks/providers/User.dart';
import 'package:jetbucks/tabs/walletTab.dart';
import 'package:jetbucks/screens/recieptpage.dart';
import 'package:jetbucks/dialogs/loadingdialog.dart';

class NotifTab extends StatefulWidget {
  final int userID;

  const NotifTab({super.key, required this.userID});

  @override
  State<NotifTab> createState() => _NotifTabState(userID: userID);
}

class _NotifTabState extends State<NotifTab> {
  final int userID;

  Future<String> userName(int id) async {
    final dio = Dio();
    final response = await dio.get(
      'https://jcash.onrender.com/api/v1/users/search-name',
      queryParameters: {'id': id},
    );

    if (response.statusCode == 200) {
      return response.data;
    }

    throw Exception('Failed to load user name');
  }

  _NotifTabState({required this.userID});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<UserProvider>(context).transactions;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
      child: Column(
        children: [
          Center(
            child: Text(
              "Notifications",
              style: GoogleFonts.rubik(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2F1155),
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child:
                transactions.isEmpty
                    ? Center(
                      child: Text(
                        "No notifications yet.",
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: transactions.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];

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

                        final isInc = isIncome(
                          formatTitle(title, transaction, userID),
                        );
                        final amount = transaction['amount'] ?? '';
                        final iconBg =
                            isInc
                                ? const Color(0xFFE3FCEC)
                                : const Color(0xFFFFE3E3);
                        final iconColor =
                            isInc
                                ? const Color(0xFF27AE60)
                                : const Color(0xFFEB5757);
                        final iconAsset =
                            isInc
                                ? 'assets/logos/up.png'
                                : 'assets/logos/down.png';

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              if (transaction['transaction_type'] != 'SEND') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => RecieptPage(
                                          transaction: transaction,
                                        ),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => showLoadingDialog(context),
                                );

                                userName(transaction['sender'])
                                    .then((name) {
                                      final sender = name;

                                      userName(transaction['receiver'])
                                          .then((name) {
                                            final receiver = name;

                                            Navigator.pop(context);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => RecieptPage(
                                                      transaction: transaction,
                                                      recipientName: receiver,
                                                      senderName: sender,
                                                    ),
                                              ),
                                            );
                                          })
                                          .catchError((error) {
                                            Navigator.pop(context);

                                            showDialog(
                                              context: context,
                                              builder:
                                                  (context) => AlertDialog(
                                                    title: const Text('Error'),
                                                    content: const Text(
                                                      'Could load page',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  ),
                                            );
                                          });
                                    })
                                    .catchError((error) {
                                      Navigator.pop(context);

                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: const Text('Error'),
                                              content: const Text(
                                                'Could load page',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                      );
                                    });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.13),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: iconBg,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      iconAsset,
                                      width: 28,
                                      height: 28,
                                      color: iconColor,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  formatTitle(title, transaction, userID),
                                  style: GoogleFonts.quicksand(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF363853),
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
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${isInc ? '+' : '-'}₱$amount",
                                      style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            isInc
                                                ? const Color(0xFF27AE60)
                                                : const Color(0xFFEB5757),
                                      ),
                                    ),
                                  ],
                                ),
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
