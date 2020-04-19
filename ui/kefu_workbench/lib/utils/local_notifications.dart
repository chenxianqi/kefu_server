import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kefu_workbench/core_flutter.dart';
class LocalNotifications{
  static LocalNotifications instance;
  static LocalNotifications getInstance() {
    if (instance != null) {
      return instance;
    } else {
      instance = LocalNotifications();
    }
    return instance;
  }
  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  LocalNotifications(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<dynamic> onDidReceiveLocalNotification(int id, String title, String body, String payload) async{
    await flutterLocalNotificationsPlugin.cancelAll();
    return true;
  }
  Future<dynamic>  onSelectNotification(String payload) async{
    await flutterLocalNotificationsPlugin.cancelAll();
    return true;
  }
  
  void showNotifications({String title, String body,String payload, String channelId = "0", String channelName = "channelName", String channelDescription = "channelDescription"}) async{
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    channelId, channelName, channelDescription,
    importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(int.parse(channelId), title, body, platformChannelSpecifics,payload: payload);
  }



}