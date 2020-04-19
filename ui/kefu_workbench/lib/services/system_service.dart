import 'package:dio/dio.dart';

import 'api.dart';
import 'base_service.dart';

class SystemService extends BaseServices {
  static SystemService instance;
  static SystemService getInstance() {
    if (instance != null) {
      return instance;
    } else {
      instance = SystemService();
    }
    return instance;
  }

  // 获取系统信息
  Future<Response> getSystemInfo() async {
    try {
      Response response = await http.get(API_SYSTEM);
      return response;
    } on DioError catch (e) {
      return error(e, API_SYSTEM);
    }
  }

   // 更新工单配置打开或者关闭
  Future<Response> toggleOpenWorkorder(int openWorkorder) async {
    try {
      Response response = await http.put(API_SYSTEM_WORKORDER, data: {"open_workorder": openWorkorder});
      return response;
    } on DioError catch (e) {
      return error(e, API_SYSTEM);
    }
  }

  // 获取上传配置信息
  Future<Response> getUploadsConfig() async {
    try {
      Response response = await http.get(API_UPLOADS_CONFIG);
      return response;
    } on DioError catch (e) {
      return error(e, API_UPLOADS_CONFIG);
    }
  }

   // 保存系统信息
  Future<Response> saveSystemInfo(Map data) async {
    try {
      Response response = await http.put(API_SYSTEM, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_SYSTEM);
    }
  }

  // 获取公司信息
  Future<Response> getCompanyInfo() async {
    try {
      Response response = await http.get(API_COMPANY_INFO);
      return response;
    } on DioError catch (e) {
      return error(e, API_COMPANY_INFO);
    }
  }

  // 保存系统信息
  Future<Response> saveCompanyInfo(Map data) async {
    try {
      Response response = await http.put(API_COMPANY, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_COMPANY);
    }
  }

  // 获取七牛配置信息
  Future<Response> getQiniuInfo() async {
    try {
      Response response = await http.get(API_QINIU);
      return response;
    } on DioError catch (e) {
      return error(e, API_QINIU);
    }
  }

  // 保存七牛配置信息
  Future<Response> saveQiniuInfo(Map data) async {
    try {
      Response response = await http.put(API_QINIU, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_QINIU);
    }
  }





}
