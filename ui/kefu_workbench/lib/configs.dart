import 'package:kefu_workbench/provider/global.dart';

class Configs {
  /// 开发模式
  static const bool DEBUG = true;

  /// APP名称
  static const APP_NAME = "客服系统";

  /// api host
  static  String get HOST => GlobalProvide.getInstance().prefs.getString("host") + '/api';


}
