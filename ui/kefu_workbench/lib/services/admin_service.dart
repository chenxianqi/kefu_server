import 'package:dio/dio.dart';

import 'api.dart';
import 'base_service.dart';

class AdminService extends BaseServices {
  static AdminService instance;
  static AdminService getInstance() {
    if (instance != null) {
      return instance;
    } else {
      instance = AdminService();
    }
    return instance;
  }

  // 获取单个客服信息
  Future<Response> getItem({int id}) async {
    try {
      Response response = await http.get(API_ADMIN + id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_REGISTER);
    }
  }

   // 删除
  Future<Response> delete({int id}) async {
    try {
      Response response = await http.delete(API_ADMIN + id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_USER);
    }
  }

  // 获取个人信息
  Future<Response> getMe() async {
    try {
      Response response = await http.get(API_GET_ME);
      return response;
    } on DioError catch (e) {
      return error(e, API_REGISTER);
    }
  }

  // 添加
  Future<Response> add(data) async {
    try {
      Response response = await http.post(API_ADMIN, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_ADMIN);
    }
  }

  // 更新当前服务谁
  Future<Response> updateCurrentServiceUser({int accountId}) async {
    try {
      Response response = await http.get(API_UPDATE_CURRENR_USER + accountId.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_UPDATE_CURRENR_USER);
    }
  }

  // 更新登录状态
  Future<Response> updateUserOnlineStatus({int status}) async {
    try {
      Response response = await http.put(API_UPDATE_ONLINE_STATUS + status.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_REGISTER);
    }
  }

   // 获取客服列表
  Future<Response> getAdmins({int pageOn = 1, int pageSize = 20,int online = 3,String keyword = ""}) async {
    try {
      Response response = await http.post(API_GET_ADMINS, data: {
        "page_on": pageOn,
        "page_size": pageSize,
        "online": online,
        "keyword": keyword
      });
      return response;
    } on DioError catch (e) {
      return error(e, API_GET_ADMINS);
    }
  }

   // 更新客服信息
  Future<Response> saveAdminInfo(Map data) async {
    try {
      Response response = await http.put(API_ADMIN, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_ADMIN);
    }
  }

  // 修改客服密码
  Future<Response> updatePassword(Map data) async {
    try {
      Response response = await http.put(API_UPDATE_ADMIN_PASSWORD, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_UPDATE_ADMIN_PASSWORD);
    }
  }


}
