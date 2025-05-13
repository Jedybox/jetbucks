import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'package:jetbucks/providers/User.dart';

Padding accountTab({required BuildContext context, required double balance}) {
  final username = localStorage.getItem('username') ?? 'User';

  return Padding(
    padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: Color(0xFFF8F6FC),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/logos/profile.png'),
                  radius: 36,
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 16),
                Text(
                  username,
                  style: GoogleFonts.rubik(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F1155),
                  ),
                ),
                SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Balance",
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6D6D6D),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "₱",
                            style: GoogleFonts.quicksand(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6D6D6D),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            context
                                .watch<UserProvider>()
                                .balance
                                .toStringAsFixed(2),
                            style: GoogleFonts.quicksand(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6D6D6D),
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
        ),
        SizedBox(height: 40),
        Center(
          child: Column(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  localStorage.setItem('username', '');
                  localStorage.setItem('password', '');
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: Icon(
                  Icons.logout_outlined,
                  color: Color(0xFFC76767),
                  size: 28,
                ),
                label: Text(
                  "Logout",
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC76767),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFFC76767), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
