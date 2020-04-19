import 'package:dio/dio.dart';

import 'api.dart';
import 'base_service.dart';

class AuthService extends BaseServices {
  static AuthService instance;
  static AuthService getInstance() {
    if (instance != null) {
      return instance;
    } else {
      instance = AuthService();
    }
    return instance;
  }

  // 登录
  Future<Response> login({String username, String password}) async {
    try {
      Response response = await http
          .post(API_LOGIN, data: {"username": username, "password": password, "auth_type": 2});
      return response;
    } on DioError catch (e) {
      return error(e, API_LOGIN);
    }
  }

  // 退出登录
  Future<Response> logout({String username, String password}) async {
    try {
      Response response = await http
          .get(API_LOGOUT);
      return response;
    } on DioError catch (e) {
      return error(e, API_LOGOUT);
    }
  }
}
