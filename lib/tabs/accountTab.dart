import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';

Padding accountTab({required BuildContext context, required double balance}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          clipBehavior: Clip.none,
          width: double.infinity,
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logos/profile.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text(
                      localStorage.getItem('username') ?? 'User',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 47, 17, 85),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Balance",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: GoogleFonts.quicksand().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: "₱",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: GoogleFonts.quicksand().fontFamily,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                      children: [
                        TextSpan(
                          text: balance.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: GoogleFonts.quicksand().fontFamily,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () {
            // Handle button press
            localStorage.setItem('username', '');
            localStorage.setItem('password', '');

            Navigator.pushReplacementNamed(context, '/login');
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: Color.fromARGB(255, 199, 103, 103),
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Colors.white,

            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          ),
          child: Text(
            "Log out",
            style: TextStyle(
              fontSize: 16,
              fontFamily: GoogleFonts.quicksand().fontFamily,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 199, 103, 103),
            ),
          ),
        ),
      ],
    ),
  );
}
