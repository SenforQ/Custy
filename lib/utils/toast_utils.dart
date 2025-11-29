import 'package:flutter/material.dart';

void showCenterToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xFF933996),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 200,
        left: 20,
        right: 20,
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

