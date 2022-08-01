import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkCheck {
  Future<bool> isNetworkAvailable() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
