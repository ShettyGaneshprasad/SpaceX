import 'package:connectivity/connectivity.dart';
import 'connection.dart';

class Connectivity {
  checkConnection() {
    var connectivityResult = Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)
      return true;
    else {
      return false;
    }
  }
}
