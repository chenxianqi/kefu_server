import 'package:dio/dio.dart';

import 'api.dart';
import 'base_service.dart';

class RobotService extends BaseServices {
  static RobotService instance;
  static RobotService getInstance() {
    if (instance != null) {
      return instance;
    } else {
      instance = RobotService();
    }
    return instance;
  }

  // 查询
  Future<Response> getItem({int id}) async {
    try {
      Response response = await http.get(API_ROBOT + id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOT);
    }
  }

  // 删除
  Future<Response> delete({int id}) async {
    try {
      Response response = await http.delete(API_ROBOT + id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOT);
    }
  }

  // 更新
  Future<Response> update({Map data}) async {
    try {
      Response response = await http.put(API_ROBOT, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOT);
    }
  }

  // 添加
  Future<Response> add({Map data}) async {
    try {
      Response response = await http.post(API_ROBOT, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOT);
    }
  }

  // 获取数据
  Future<Response> getList() async {
    try {
      Response response = await http.get(API_ROBOTS);
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOTS);
    }
  }

   // 获取一个在线机器人
  Future<Response> getOnlineRobot() async {
    try {
      Response response = await http.get(API_GET_ROBOT);
      return response;
    } on DioError catch (e) {
      return error(e, API_GET_ROBOT);
    }
  }

  

  
}
