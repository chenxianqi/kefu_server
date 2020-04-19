import 'package:dio/dio.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs.dart';
import '../core_flutter.dart';

class BaseServices{

  // dio 实例
  Dio get http => getDioInstance();


  // 去除空字段
  Map<String, dynamic> removeNull(Map<String, dynamic> json){
    json.removeWhere((key, value) => value == null);
    return json;
  }

  // 全局服务器错误返回信息
  Response error(DioError e, String url){
    printf("$url =====服务器错误返回信息=====$e====${e.response.data}");
    if(e.response.data != null && e.response.data['code']?.toString() == "401"){
      GlobalProvide.getInstance().applicationLogout();
      if(GlobalProvide.getInstance()?.rooContext != null){
        Navigator.pushNamedAndRemoveUntil(GlobalProvide.getInstance()?.rooContext, "/login", ModalRoute.withName('/'), arguments: {"isAnimate": false});
      }
    }
    return Response(data: e.response.data);
  }

  Dio getDioInstance(){
     final dio = Dio();
     dio.options.baseUrl = Configs.HOST;
     dio.options.connectTimeout = 60000;
     dio.options.receiveTimeout = 60000;
     dio.interceptors.add(InterceptorsWrapper(
      onRequest:(RequestOptions options) async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final String authorization = prefs.getString('Authorization');
        debugPrint('调用了API=${options.uri}');
        debugPrint('request body=${options.data}');
        debugPrint('Authorization=$authorization');
        if(authorization != null){
          options.headers['Authorization'] = authorization;
        }
        // 判断网络是否可用
        if(!await checkNetWork()){
          return dio.resolve(Response(data: {"code": 503, "msg": '您的网络异常，请检查您的网络！', "data": null}));
        }
        return options;
      },
      onResponse:(Response response) async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // 如果有authorization 换掉本地的
        if(response.headers['authorization'] != null){
          prefs.setString('Authorization', response.headers['authorization'][0]);
        }
        return response; // continue
      },
      onError: (DioError e) {
        return e;
      }
  ));
    return dio;
  }
}
