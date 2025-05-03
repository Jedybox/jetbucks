import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoWifiDialog extends StatelessWidget {
  const NoWifiDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('No Internet Connection'),
      content: const Text(
        'Please check your internet connection and try again.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            SystemNavigator.pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
