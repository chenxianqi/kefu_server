import 'package:dio/dio.dart';

import 'api.dart';
import 'base_service.dart';

class ContactService extends BaseServices {
  static ContactService instance;
  static ContactService getInstance() {
    if (instance != null) {
      return instance;
    } else {
      instance = ContactService();
    }
    return instance;
  }


  // 获取聊天列表
  Future<Response> getContacts() async {
    try {
      Response response = await http.get(API_CONTACTS);
      return response;
    } on DioError catch (e) {
      return error(e, API_CONTACTS);
    }
  }

  // 删除单个
  Future<Response> removeSingle(int cid) async {
    try {
      Response response = await http.delete(API_CONTACT + cid.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_CONTACT + cid.toString());
    }
  }

  
}
