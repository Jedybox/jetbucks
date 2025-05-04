import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AlertDialog showLoadingDialog(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.transparent,
    content: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 20),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.quicksand().fontFamily,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
