import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:jetbucks/providers/User.dart';
import 'package:jetbucks/dialogs/loadingdialog.dart';
import 'package:dio/dio.dart';

class TransactionPage extends StatefulWidget {
  final String type;

  const TransactionPage({super.key, required this.type});

  @override
  State<TransactionPage> createState() => _TransactionPageState(type: type);
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String type;

  String amount = '0.00';

  final List<List<String>> keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['00', '0', 'DEL'],
  ];

  AlertDialog dialog(String title, String discrption) {
    return AlertDialog(
      title: Text(title),
      content: Text(discrption),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  Future<void> userExists(String username) async {
    final dio = Dio();
    final response = await dio.get(
      'https://jcash.onrender.com/api/v1/users/search',
      queryParameters: {'username': username},
    );

    if (response.statusCode == 200) {
      return;
    }

    throw Exception('User not found');
  }

  // TODO: TEST THIS FUNCTION
  void sendForm() {
    if (type == 'SEND' && !_formKey.currentState!.validate()) return;

    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final double parsedAmount = double.parse(amount.replaceAll('.', ''));

    if (parsedAmount == 0.00) {
      showDialog(
        context: context,
        builder:
            (_) => dialog('Invalid Amount', 'Please enter a valid amount.'),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => showLoadingDialog(context),
    );

    if (type == 'SEND') {
      userExists(usernameController.text).catchError((_) {
        Navigator.of(context).pop(); // Close the loading dialog
        showDialog(
          context: context,
          builder:
              (_) => dialog('User Not Found', 'Please enter a valid username.'),
        );
        return;
      });

      userProvider
          .sendMoney(parsedAmount, usernameController.text)
          .then((_) {
            Navigator.of(context).pop(); // Close the loading dialog
            // TODO: pop and push to reciept page
          })
          .catchError((_) {
            Navigator.of(context).pop(); // Close the loading dialog
            showDialog(
              context: context,
              builder:
                  (_) => dialog(
                    'Transaction Failed',
                    'Please check your internet connection and try again.',
                  ),
            );
          });
    }

    if (type == 'CASH-IN') {
      userProvider
          .cashIn(parsedAmount)
          .then((_) {
            Navigator.of(context).pop(); // Close the loading dialog
            // TODO: pop and push to reciept page
          })
          .catchError((_) {
            Navigator.of(context).pop(); // Close the loading dialog
            showDialog(
              context: context,
              builder:
                  (_) => dialog(
                    'Transaction Failed',
                    'Please check your internet connection and try again.',
                  ),
            );
          });
    }

    if (type == 'CASH-OUT') {
      userProvider
          .cashOut(parsedAmount)
          .then((_) {
            Navigator.of(context).pop(); // Close the loading dialog
            // TODO: pop and push to reciept page
          })
          .catchError((_) {
            Navigator.of(context).pop(); // Close the loading dialog
            showDialog(
              context: context,
              builder:
                  (_) => dialog(
                    'Transaction Failed',
                    'Please check your internet connection and try again.',
                  ),
            );
          });
    }
  }

  void _onKeyPress(String key) {
    setState(() {
      if ((key == '0' || key == '00') && amount == '0.00') {
        return;
      }

      if (amount == '0.00') {
        amount = '0.0$key';
        return;
      }

      if (amount.substring(0, 3) == '0.0') {
        if (key == '00') {
          amount = '${amount[amount.length - 1]}.00';
          return;
        }

        amount = '0.${amount[amount.length - 1]}$key';
        return;
      }

      if (amount.substring(0, 2) == '0.') {
        amount = '${amount[2]}.${amount.substring(3)}$key';
        return;
      }

      final String temp = amount.replaceAll('.', '');
      final temp2 = '$temp$key'.split('');
      temp2.insert(temp2.length - 2, '.');
      amount = temp2.join('');
    });
  }

  void onDel() {
    setState(() {
      if (amount == '0.00') {
        return;
      }

      if (amount.substring(0, 3) == '0.0') {
        amount = '0.00';
        return;
      }

      if (amount.substring(0, 2) == '0.') {
        amount = '0.0${amount[2]}';
        return;
      }

      if (amount.substring(0, 2) == '0.') {
        amount = '0.00';
        return;
      }

      if (amount.length == 4) {
        final String temp = amount.replaceAll('.', '').substring(0, 2);
        amount = '0.$temp';
        return;
      }

      final temp = amount.replaceAll('.', '').split('');
      final temp2 = temp.sublist(0, temp.length - 1);
      temp2.insert(temp2.length - 2, '.');

      amount = temp2.join('');
    });
  }

  _TransactionPageState({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20.0),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 40), // Placeholder for the icon
              ],
            ),
            const SizedBox(height: 30),
            Text(
              amount,
              style: GoogleFonts.rubik(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (type == 'SEND')
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 60, left: 60),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: "Username",
                      hintStyle: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          'assets/logos/profile.png',
                          width: 22,
                          height: 22,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: type != 'SEND' ? 20 : 0),
            Padding(
              padding: const EdgeInsets.only(right: 60.0, left: 60),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final row = index ~/ 3;
                  final col = index % 3;
                  final value = keys[row][col];

                  if (value == 'DEL') {
                    return IconButton(
                      onPressed: onDel,
                      icon: const Icon(Icons.cancel, size: 28),
                      style: IconButton.styleFrom(
                        shape: const CircleBorder(),
                        foregroundColor: Colors.black87,
                      ),
                    );
                  }

                  return ElevatedButton(
                    onPressed: () => _onKeyPress(value),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Color.fromARGB(255, 54, 56, 83),
                      shadowColor: Colors.transparent,
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.quicksand().fontFamily,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(value),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: sendForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 40,
                ),
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.quicksand().fontFamily,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                type == 'SEND'
                    ? 'Send'
                    : type == 'CASH-IN'
                    ? 'Cash-in'
                    : 'Cash-out',
                style: GoogleFonts.quicksand(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
