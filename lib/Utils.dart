import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void ShowSnackbar(BuildContext context, String Message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Message)));
}

class LoadingProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
