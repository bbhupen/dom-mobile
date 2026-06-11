import 'package:flutter/material.dart';

void showToast(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message.replaceFirst('Exception: ', '')),
      backgroundColor: isError
          ? const Color(0xffb42318)
          : const Color(0xff3f7b62),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
