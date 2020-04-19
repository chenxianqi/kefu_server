import 'package:dio/dio.dart';

import 'api.dart';
import 'base_service.dart';

class PlatformService extends BaseServices {
  static PlatformService instance;
  static PlatformService getInstance() {
    if (instance != null) {
      return instance;
    } else {
      instance = PlatformService();
    }
    return instance;
  }


  // 获取平台列表
  Future<Response> getPlatforms() async {
    try {
      Response response = await http.get(API_GET_PLATFORM);
      return response;
    } on DioError catch (e) {
      return error(e, API_GET_PLATFORM);
    }
  }

  // 更新信息
  Future<Response> update(Map data) async {
    try {
      Response response = await http.put(API_PLATFORM, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_PLATFORM);
    }
  }
  
  // 添加信息
  Future<Response> add(Map data) async {
    try {
      Response response = await http.post(API_PLATFORM, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_PLATFORM);
    }
  }

  // 添加信息
  Future<Response> delete(int id) async {
    try {
      Response response = await http.delete(API_PLATFORM + id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_PLATFORM);
    }
  }

  // 获取单个信息
  Future<Response> getItem(int id) async {
    try {
      Response response = await http.get(API_PLATFORM + id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_PLATFORM);
    }
  }

  
}
