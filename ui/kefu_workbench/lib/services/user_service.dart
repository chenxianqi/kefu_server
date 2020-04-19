import 'package:dio/dio.dart';

import 'api.dart';
import 'base_service.dart';

class UserService extends BaseServices {
  static UserService instance;
  static UserService getInstance() {
    if (instance != null) {
      return instance;
    } else {
      instance = UserService();
    }
    return instance;
  }

   // 查询
  Future<Response> getItem({int id}) async {
    try {
      Response response = await http.get(API_USER + id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_USER);
    }
  }

  // 删除
  Future<Response> delete({int id}) async {
    try {
      Response response = await http.delete(API_USER + id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_USER);
    }
  }

  // 添加
  Future<Response> add({Map data}) async {
    try {
      Response response = await http.post(API_USER, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_USER);
    }
  }

  // 获取数据
  Future<Response> getList({int pageOn = 1, int pageSize = 20, String keyword, int platform = 1, String dateStart, String dateEnd}) async {
    try {
      Response response = await http.post(API_USERS, data: {
        "page_on": pageOn,
        "page_size": pageSize,
        "keyword": keyword,
        "platform": platform,
        "date_start": dateStart,
        "date_end": dateEnd
      });
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOTS);
    }
  }


  // 保存用户信息
  Future<Response> update(Map data) async {
    try {
      Response response = await http.put(API_USER, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_USER);
    }
  }

  
}
