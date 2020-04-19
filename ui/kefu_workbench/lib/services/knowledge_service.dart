import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';

import 'api.dart';
import 'base_service.dart';

class KnowledgeService extends BaseServices {
  static KnowledgeService instance;
  static KnowledgeService getInstance() {
    if (instance != null) {
      return instance;
    } else {
      instance = KnowledgeService();
    }
    return instance;
  }

  // 查询
  Future<Response> getItem({int id}) async {
    try {
      Response response = await http.get(API_KNOWLEDGE + id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_KNOWLEDGE);
    }
  }

  // 删除
  Future<Response> delete({int id}) async {
    try {
      Response response = await http.delete(API_KNOWLEDGE + id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_KNOWLEDGE);
    }
  }

  // 更新
  Future<Response> update({Map data}) async {
    try {
      Response response = await http.put(API_KNOWLEDGE, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_KNOWLEDGE);
    }
  }

  // 添加
  Future<Response> add({Map data}) async {
    try {
      Response response = await http.post(API_KNOWLEDGE, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_KNOWLEDGE);
    }
  }

  // 获取数据
  Future<Response> getList({int pageOn = 1, int pageSize = 20, int platform = 1, String keyword = ""}) async {
    try {
      Response response = await http.post(API_GET_KNOWLEDGE, data: {"page_on": pageOn, "page_size": pageSize, "platform": platform, "keyword": keyword});
      return response;
    } on DioError catch (e) {
      return error(e, API_GET_KNOWLEDGE);
    }
  }



}
