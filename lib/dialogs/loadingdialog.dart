import 'package:flutter/material.dart';

AlertDialog showLoadingDialog(BuildContext context) {
  return AlertDialog(
    backgroundColor: Colors.white,
    content: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 20),
          Text('Loading...', style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    ),
  );
}
