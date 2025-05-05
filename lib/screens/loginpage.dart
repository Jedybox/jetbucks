import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

import 'package:jetbucks/dialogs/nowifidialog.dart';
import 'package:jetbucks/dialogs/loadingdialog.dart';
import 'package:localstorage/localstorage.dart';

/// This is the login page widget.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// This is the state class for the LoginPage widget.
class _LoginPageState extends State<LoginPage> {
  bool _initialized = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _passwordIsNotVisible = true;

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (context) => const NoWifiDialog());
    }
  }

  Future<void> _validateFormAndLogin() async {
    print('Validating form...');
    final isValid = _formKey.currentState!.validate();

    showDialog(
      context: context,
      builder: (context) => showLoadingDialog(context),
    );

    if (!isValid) {
      Navigator.of(context).pop(); // Close loading dialog
      return;
    }

    final username = usernameController.text;
    final password = passwordController.text;

    final dio = Dio();

    dio
        .get(
          'https://jcash.onrender.com/api/v1/users/login',
          queryParameters: {'username': username, 'password': password},
        )
        .then((response) {
          if (response.statusCode == 202) {
            // Save the username and password to local storage
            localStorage.setItem('username', username);
            localStorage.setItem('password', password);

            Navigator.pushReplacementNamed(context, '/home');
          } else {
            // Handle error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login failed. Please try again.')),
            );
          }
        })
        .catchError((error) {
          // Handle error
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('An error occurred: $error')));
        });

    Navigator.of(context).pop(); // Close loading dialog
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await checkConnectivity();

        showDialog(
          context: context,
          builder: (context) => showLoadingDialog(context),
        );

        final username = localStorage.getItem('username');
        final password = localStorage.getItem('password');

        if ((username == null && password == null) ||
            (username == '' && password == '')) {
          Navigator.of(context).pop(); // Close loading dialog
          return;
        }

        Navigator.of(context).pop(); // Close dialog

        Future.delayed(Duration(milliseconds: 100), () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Welcome back\nto JetBucks Wallet',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color.fromARGB(255, 47, 17, 85),
              ),
              textAlign: TextAlign.center,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontFamily: GoogleFonts.quicksand().fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color.fromARGB(255, 189, 189, 189),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _passwordIsNotVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          'assets/logos/key.png',
                          width: 22,
                          height: 22,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordIsNotVisible = !_passwordIsNotVisible;
                          });
                        },
                        icon: Icon(
                          _passwordIsNotVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
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
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _validateFormAndLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 91, 37, 159),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to the register page
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: Text(
                        'Register',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: const Color.fromARGB(255, 128, 194, 255),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
