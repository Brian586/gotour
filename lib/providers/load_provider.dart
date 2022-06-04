import 'package:flutter/foundation.dart';

class LoadProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
