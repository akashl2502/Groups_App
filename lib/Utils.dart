import 'package:flutter/material.dart';

void ShowSnackbar(BuildContext context, String Message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Message)));
}

