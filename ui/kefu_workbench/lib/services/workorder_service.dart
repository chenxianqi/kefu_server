import 'package:dio/dio.dart';

import 'api.dart';
import 'base_service.dart';

class WorkOrderService extends BaseServices {
  static WorkOrderService instance;
  static WorkOrderService getInstance() {
    if (instance != null) {
      return instance;
    } else {
      instance = WorkOrderService();
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

  // 获取工单列表
  Future<Response> getWorkOrders(requestBody) async {
    try {
      Response response = await http.post(API_WORK_ORDERS, data: requestBody);
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOTS);
    }
  }

  // 获取单个工单数据
  Future<Response> getWorkOrder(int id) async {
    try {
      Response response = await http.get(API_WORK_ORDER + id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOTS);
    }
  }

   // 获取单个工单数据
  Future<Response> getWorkOrderComments(int id) async {
    try {
      Response response = await http.get(API_WORK_ORDER_COMMENTS + id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOTS);
    }
  }

   // 回复工单
  Future<Response> reply(requestBody) async {
    try {
      Response response = await http.post(API_REPLY_WORK_ORDER, data: requestBody);
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOTS);
    }
  }

   // 关闭工单
  Future<Response> close(requestBody) async {
    try {
      Response response = await http.post(API_CLOSE_WORK_ORDER, data: requestBody);
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOTS);
    }
  }

   // 删除工单
  Future<Response> delWorkOrder(int wid) async {
    try {
      Response response = await http.delete(API_DELETE_WORK_ORDER + wid.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOTS);
    }
  }

  // 获取类型数据
  Future<Response> getWorkorderTypes() async {
    try {
      Response response = await http.get(API_WORK_ORDER_TYPES);
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOTS);
    }
  }

  // 获取工单系统counts
  Future<Response> getWorkOrderCounts() async {
    try {
      Response response = await http.get(API_WORK_ORDER_COUNTS);
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOTS);
    }
  }

  // 添加工单分类
  Future<Response> addType(requestBody) async {
    try {
      Response response = await http.post(API_WORK_ORDER_TYPE, data: requestBody);
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOTS);
    }
  }

  // 更新工单分类
  Future<Response> updateType(requestBody) async {
    try {
      Response response = await http.put(API_WORK_ORDER_TYPE, data: requestBody);
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOTS);
    }
  }

  // 删除工单分类
  Future<Response> delype(int id) async {
    try {
      Response response = await http.delete(API_WORK_ORDER_TYPE + id.toString());
      return response;
    } on DioError catch (e) {
      return error(e, API_ROBOTS);
    }
  }


}
