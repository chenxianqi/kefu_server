import 'package:flutter/services.dart';

import 'app.dart';
import 'core_flutter.dart';
import 'provider/global.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Color.fromRGBO(0, 0, 0, 0.0)));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GlobalProvide.getInstance().init();
  return runApp(createApp());
}
