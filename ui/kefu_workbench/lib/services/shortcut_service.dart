import 'package:dio/dio.dart';

import 'api.dart';
import 'base_service.dart';

class ShortcutService extends BaseServices {
  static ShortcutService instance;
  static ShortcutService getInstance() {
    if (instance != null) {
      return instance;
    } else {
      instance = ShortcutService();
    }
    return instance;
  }

  // 获取快捷语列表
  Future<Response> getShortcuts() async {
    try {
      Response response = await http.get(API_GET_SHORTCUT);
      return response;
    } on DioError catch (e) {
      return error(e, API_GET_SHORTCUT);
    }
  }


  // 添加
  Future<Response> add(Map data) async {
    try {
      Response response = await http.post(API_SHORTCUT, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_SHORTCUT);
    }
  }
  

  // 修改
  Future<Response> update(Map data) async {
    try {
      Response response = await http.put(API_SHORTCUT, data: data);
      return response;
    } on DioError catch (e) {
      return error(e, API_SHORTCUT);
    }
  }

  // 删除
  Future<Response> delete(int id) async {
    try {
      Response response = await http.delete(API_SHORTCUT+id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_SHORTCUT);
    }
  }
  


  
}
