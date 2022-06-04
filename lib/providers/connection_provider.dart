import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

class ConnectionProvider with ChangeNotifier {
  Future<bool> get isConnected => _isConnected();

  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}
