import 'package:dio/dio.dart';

import 'api.dart';
import 'base_service.dart';

class MessageService extends BaseServices {
  static MessageService instance;
  static MessageService getInstance() {
    if (instance != null) {
      return instance;
    } else {
      instance = MessageService();
    }
    return instance;
  }

  // 获取服务器消息列表
  Future<Response> getMessageRecord(
      {int timestamp, int pageSize = 15, int account, int service, bool isHistory = false}) async {
    try {
      Response response = await http.post(isHistory ? API_GET_MESSAGE_HOSTORY :  API_GET_MESSAGE, data: {
        "timestamp": timestamp,
        "page_size": pageSize,
        "service": service,
        "account": account
      });
      return response;
    } on DioError catch (e) {
      return error(e, API_GET_MESSAGE);
    }
  }
  

  // 转接用户
  Future<Response> transformerUser({int toAccount, int userAccount}) async {
    try {
      Response response = await http.post(API_TRANSFER_USER, data: {
        "to_account": toAccount,
        "user_account": userAccount
      });
      return response;
    } on DioError catch (e) {
      return error(e, API_TRANSFER_USER);
    }
  }

   // 删除单条消息
  Future<Response> removeMeessge(
      {int toAccount, int fromAccount, int key}) async {
    try {
      Response response = await http.post(API_REMOVE_MESSAGE, data: {
        "to_account": toAccount,
        "from_account": fromAccount,
        "key": key
      });
      return response;
    } on DioError catch (e) {
      return error(e, API_REMOVE_MESSAGE);
    }
  }
  


  
}
