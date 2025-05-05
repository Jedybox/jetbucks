import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jetbucks/buttons/squarebutton.dart';

Padding walletTab({required TabController tabController}) {
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
                icon: Image.asset(
                  "assets/logos/profile.png",
                  width: 25,
                  height: 25,
                ),
                onPressed: () {
                  tabController.animateTo(3); // Navigate to Account Tab
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
                        Text(
                          "\$ 1.234",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.rubik().fontFamily,
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
        SizedBox(height: 20),
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
                  onPressed: () {},
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
                  onPressed: () {},
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
                  onPressed: () {},
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
        SizedBox(height: 20),
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
      ],
    ),
  );
}
