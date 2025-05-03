import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jetbucks/dialogs/nowifidialog.dart';

/// This is the login page widget.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// This is the state class for the LoginPage widget.
class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (context) => const NoWifiDialog());
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
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
                  TextField(
                    controller: usernameController,
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
                  TextField(
                    controller: passwordController,
                    obscureText: isPasswordVisible,
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
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          isPasswordVisible
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
                  onPressed: () {
                    // Handle login action
                  },
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
                        // Handle forgot password action
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
