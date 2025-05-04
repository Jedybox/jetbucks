import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  DateTime? _selectedDate;
  String? _dobError;

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dobError = null;
      });
    }
  }

  void _submitForm() {
    final isValid = _formKey.currentState!.validate();
    setState(() {
      _dobError =
          _selectedDate == null ? 'Please select your date of birth' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "Immediately feel the ease of transacting just by registering",
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color.fromARGB(255, 47, 17, 85),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Register here',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: const Color.fromARGB(255, 189, 189, 189),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _usernameController,
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

                  // DOB Picker
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickDate(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 0),
                          backgroundColor: const Color(0xFFF5F5F5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          shadowColor: Colors.transparent,
                          alignment: Alignment.centerLeft,
                        ),
                        child: Text(
                          _selectedDate != null
                              ? DateFormat('yMMMMd').format(_selectedDate!)
                              : 'Select Date of Birth',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      if (_dobError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 5),
                          child: Text(
                            _dobError!,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: isPasswordVisible,
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
                        icon:
                            isPasswordVisible
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                        color: Colors.grey[700],
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        splashColor: Colors.transparent, // Disable splash
                        highlightColor: Colors.transparent,
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _submitForm,
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
                    'Register',
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
                      'You have an account?',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to the register page
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        'Login',
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
