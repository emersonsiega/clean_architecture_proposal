import 'package:flutter/material.dart';

void _showSnack({
  @required BuildContext context,
  @required String message,
  @required Color backgroundColor,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

void showSuccessSnack({
  @required BuildContext context,
  @required String message,
}) {
  _showSnack(
    context: context,
    message: message,
    backgroundColor: Colors.green[900],
  );
}

void showErrorSnack({
  @required BuildContext context,
  @required String error,
}) {
  _showSnack(
    context: context,
    message: error,
    backgroundColor: Colors.red[900],
  );
}
