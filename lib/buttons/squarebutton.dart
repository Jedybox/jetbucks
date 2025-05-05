import 'package:flutter/material.dart';

ElevatedButton squareButton({
  required VoidCallback onPressed,
  required Image icon,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shadowColor: Colors.black,
      elevation: 10,
    ),
    child: icon,
  );
}
