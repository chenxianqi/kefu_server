import 'package:dio/dio.dart';

import 'api.dart';
import 'base_service.dart';

class PublicService extends BaseServices {
  static PublicService instance;
  static PublicService getInstance() {
    if (instance != null) {
      return instance;
    } else {
      instance = PublicService();
    }
    return instance;
  }

  // 注册IM
  Future<Response> registerImAccount({int accountId}) async {
    try {
      Response response = await http
          .post(API_REGISTER, data: {"type": 1, "account_id": accountId});
      return response;
    } on DioError catch (e) {
      return error(e, API_REGISTER);
    }
  }

  // 获取配置信息
  Future<Response> getConfigs() async {
    try {
      Response response = await http.get(API_CONFIGS);
      return response;
    } on DioError catch (e) {
      return error(e, API_CONFIGS);
    }
  }

  

  // 一分钟上报一次我的活动
  Future<Response> upImLastActivity() async {
    try {
      Response response = await http.get(API_RUN_LAST_ACTiIVITY);
      return response;
    } on DioError catch (e) {
      return error(e, API_RUN_LAST_ACTiIVITY);
    }
  }

  // 获取服务记录
  Future<Response> getServicesStatistical({int pageOn = 1, int pageSize = 20, int cid, String date, bool isDeWeighting = false,bool isReception = false}) async {
    try {
      Response response = await http
        .post(API_SERVICES_STATISTICAL, data: {
          "page_on": pageOn,
          "page_size": pageSize,
          "cid": cid,
          "is_reception": isReception,
          "date": date,
          "is_de_weighting": isDeWeighting
        });
      return response;
    } on DioError catch (e) {
      return error(e, API_SERVICES_STATISTICAL);
    }
  }

  // 获取各渠道服务统计量
  Future<Response> getCountStatistical({String dateStart, String dateEnd}) async {
    try {
      Response response = await http
        .post(API_STATISTICAL, data: {
          "date_start": dateStart,
          "date_end": dateEnd
        });
      return response;
    } on DioError catch (e) {
      return error(e, API_STATISTICAL);
    }
  }

  // 获取独立用户访问量
  Future<Response> getIpStatistical({String dateStart, String dateEnd}) async {
    try {
      Response response = await http
        .post(API_TODAY_STATISTICAL, data: {
          "date_start": dateStart,
          "date_end": dateEnd
        });
      return response;
    } on DioError catch (e) {
      return error(e, API_TODAY_STATISTICAL);
    }
  }


}
