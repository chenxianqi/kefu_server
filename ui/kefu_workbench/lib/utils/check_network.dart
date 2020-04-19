import 'package:connectivity/connectivity.dart';

final Connectivity connectivity = Connectivity();
Future<bool> checkNetWork() async{
  var result = await connectivity.checkConnectivity();
  if(result == ConnectivityResult.none){
    return false;
  }else{
    return true;
  }
}