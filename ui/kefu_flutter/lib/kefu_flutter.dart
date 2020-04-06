import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mimc/flutter_mimc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'models/im_configs.dart';
import 'models/im_message.dart';
import 'models/im_token_info.dart';
import 'models/im_user.dart';
import 'models/knowledge_model.dart';
import 'models/robot.dart';
import 'models/service_user.dart';
import 'models/work_order_type.dart';
import 'utils/im_utils.dart';
import 'widgets/cached_network_image.dart';
import 'widgets/emoji_panel.dart';
import 'widgets/knowledge_message.dart';
import 'widgets/photo_message.dart';
import 'widgets/system_message.dart';
import 'widgets/text_message.dart';
import 'widgets/workorder_message.dart';
import 'workorder/index.dart';

/// 创建消息辅助对象
///  [sendMessage] 发送对象
///  [imMessage]  本地显示对象
class MessageHandle {
  MessageHandle({this.sendMessage, this.localMessage});
  MIMCMessage sendMessage;
  ImMessage localMessage;
  MessageHandle clone() {
    return MessageHandle(
      sendMessage: MIMCMessage.fromJson(sendMessage.toJson()),
      localMessage: ImMessage.fromJson(localMessage.toJson()),
    );
  }
}

/// KeFuStore
class KeFuStore with ChangeNotifier {
  /// KeFuStore实例
  static KeFuStore _instance;

  /// http
  Dio http;

  /// 客服信息
  ServiceUser serviceUser;

  /// IM 用户对象
  ImUser imUser;

  /// IM 签名对象
  ImTokenInfo imTokenInfo;

  /// 缓存对象
  SharedPreferences prefs;

  /// 机器人对象
  Robot robot;

  /// 配置信息
  ImConfigs imConfigs;

  /// IM 插件对象
  FlutterMIMC flutterMImc;

  /// 是否是人工
  bool isService = false;

  /// 聊天记录
  List<ImMessage> messagesRecord = [];

  /// 最后一条消息
  ImMessage get lastMessage {
    if (messagesRecord.length > 0)
      return messagesRecord[messagesRecord.length - 1];
    return null;
  }

  /// 显示对方输入中...
  bool isPong = false;

  /// 没有更多记录了
  bool isScrollEnd = false;

  /// 为消息总数
  int messageReadCount = 0;

  /// 是否在kefuView窗口 1 or 0  1在客服窗口  0 不在客服窗口
  int window = 0;

  /// 被踢出最长时间
  int tomeOutTime = 60 * 1000 * 8;

  /// 检索回来的知识库信息列表
  List<KnowledgeModel> handshakeKeywordList = [];

  // 滚动条控制器
  ScrollController scrollController = ScrollController();

  /// 小米消息云配置
  static String mImcAppID;
  static String mImcAppKey;
  static String mImcAppSecret;
  static String mImcTokenData;
  static bool mImcDebug;

  /// 是否自动登录
  static bool isAutoLogin;

  /// 延迟登录(毫秒)
  static int delayLoginTime;

  /// 业务平台ID
  static int platformUserId;

  /// API 接口
  static String apiHost;

  /// IM 注册初始化IM账号
  static const String API_REGISTER = "/public/register";

  /// IM 上报最后活动时间 /uid
  static const String API_ACTIVITY = "/public/activity";

  /// IM 获取机器人      /platform
  static const String API_GET_ROBOT = "/public/robot/1";

  /// IM 获取未读消息    /uid
  static const String API_GET_READ = "/public/read";

  /// 获取历史消息记录
  static const String API_GET_MESSAGE = "/public/messages";

  /// IM 清除未读消息    /uid
  static const String API_CLEAN_READ = "/public/clean_read";

  /// IM 清除未读消息    /uid
  static const String API_WINDOW_CHANGE = "/public/window";

  /// IM 获取配置信息
  static const String API_UPLOAD_SECRET = "/public/configs";

  /// IM 内置文件上传
  static const String API_UPLOAD_FILE = "/public/upload";

  /// IM 七牛文件上传
  static const String API_QINIU_UPLOAD_FILE = "https://upload.qiniup.com";

  /// 消息接收方账号 机器人 或 客服
  int get toAccount =>
      isService && serviceUser != null ? serviceUser.id : robot.id;

  // 工单类型集合
  List<WorkOrderTypeModel> workOrderTypes = [];

  // 单列 获取对象
  /// 配置信息
  /// mImcTokenData 不为空，即优先使用 mImcTokenData
  /// [apiHost] 客服后台API地址
  /// [mImcAppID]     mimc AppID
  /// [mImcAppKey]    mimc AppKey
  /// [mImcAppSecret] mimc AppSecret
  /// [mImcTokenData] mimc TokenData
  /// [userId]  业务平台ID(扩展使用)
  /// [autoLogin] 是否自动登录
  /// [delayTime] 延迟登录，默认300毫秒，以免未实例化完成就调用登录
  static KeFuStore init(
      {String host,
      String appID,
      String appKey,
      String appSecret,
      String mimcToken,
      int userId = 0,
      bool autoLogin = true,
      int delayTime = 300,
      bool debug = false}) {
    assert(host != null);
    apiHost = host;
    mImcAppID = appID;
    mImcAppKey = appKey;
    mImcAppSecret = appSecret;
    mImcTokenData = mimcToken;
    mImcDebug = debug;
    platformUserId = userId;
    isAutoLogin = autoLogin;
    delayLoginTime = delayTime < 1000 ? 1000 : delayTime;
    if (_instance == null) {
      _instance = KeFuStore();
    }
    return _instance;
  }

  /// 构造器
  KeFuStore() {
    _dioInstance();
    debugPrint("KeFuController实例化了");
    _init();
  }

  // 获取实例
  static get getInstance => _instance;

  /// 初始化
  Future<void> _init() async {
    await _prefsInstance();
    await _registerImAccount();
    await _getRobot();
    await _flutterMImcInstance();
    await _getImConfigs();
    await _upImLastActivity();
    _addMimcEvent();
    getReadCount();
    _checkIsOutSession();
    _onCheckIsloogTimeNotCallBack();
    _onServciceLastMessageTimeNotCallBack();
    getMessageRecord();
    _currentIsService();
    getWorkOrderTypes();
    if (isAutoLogin) loginIm();
  }

  /// 判断当前是否是客服状态
  void _currentIsService() async {
    var serviceUserStringJson =
        prefs.getString("currentServiceUser_${imUser?.id}");
    if (serviceUserStringJson != null) {
      serviceUser = ServiceUser.fromJson(json.decode(serviceUserStringJson));
      isService = true;
      await Future.delayed(Duration(milliseconds: delayLoginTime));
      if (!await flutterMImc?.isOnline()) {
        debugPrint("登录中...");
        flutterMImc?.login();
      }
      notifyListeners();
    }
  }

  // GET workorder types
  Future<void> getWorkOrderTypes() async {
    Response res = await http.get('/public/workorder/types');
    if (res.data['code'] == 200) {
      workOrderTypes = (res.data['data'] as List)
          .map((i) => WorkOrderTypeModel.fromJson(i))
          .toList();
    }
  }

  // 获取客服View页面
  Widget view() => _KeFu();

  /// 实例化 dio
  Future<void> _dioInstance() async {
    if (http != null) return;
    BaseOptions options = new BaseOptions(
      baseUrl: apiHost,
      connectTimeout: 60000,
      receiveTimeout: 60000,
      headers: {},
    );
    http = Dio(options);
    http.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      if (imUser != null && imUser.token.isNotEmpty) {
        options.headers['Token'] = imUser.token;
      }
      return options;
    }, onResponse: (Response response) async {
      return response; // continue
    }, onError: (DioError e) {
      return e;
    }));
  }

  /// 实例化 FlutterMImc
  Future<void> _flutterMImcInstance() async {
    if (mImcTokenData != null) {
      flutterMImc = FlutterMIMC.stringTokenInit(mImcTokenData);
    } else {
      flutterMImc = FlutterMIMC.init(
          debug: mImcDebug,
          appId: mImcAppID,
          appKey: mImcAppKey,
          appSecret: mImcAppSecret,
          appAccount: imUser.id.toString());
    }
  }

  /// 注册IM账号
  Future<void> _registerImAccount() async {
    try {
      int imAccount = prefs.getInt("ImAccount") ?? 0;
      Response response = await http.post(API_REGISTER, data: {
        "type": 0,
        "uid": platformUserId ?? 0,
        "platform": Platform.isIOS ? 2 : 6,
        "account_id": imAccount ?? 0
      });
      if (response.data["code"] == 200) {
        imTokenInfo =
            ImTokenInfo.fromJson(response.data["data"]["token"]["data"]);
        imUser = ImUser.fromJson(response.data["data"]["user"]);
        prefs.setInt("ImAccount", imUser.id);
      } else {
        // 1秒重
        debugPrint(response.data["error"]);
        await Future.delayed(Duration(milliseconds: 1000));
        _registerImAccount();
      }
    } catch (e) {
      debugPrint(e);
    }
  }

  /// 获取机器人信息
  Future<void> _getRobot() async {
    try {
      Response response = await http.get(API_GET_ROBOT);
      print(response.data);
      if (response.data["code"] == 200) {
        robot = Robot.fromJson(response.data["data"]);
        prefs.setString(
            "robot_" + robot.id.toString(), json.encode(response.data["data"]));
      } else {
        // 1秒重试
        debugPrint(response.data["error"]);
        await Future.delayed(Duration(milliseconds: 1000));
        _getRobot();
      }
    } catch (e) {
      debugPrint(e);
    }
  }

  /// 上报窗口位置信息
  /// [status] 1 or 0  1在客服窗口  0 不在客服窗口
  Future<void> setWindow(int status) async {
    window = status;
    notifyListeners();
    try {
      await http.put(API_WINDOW_CHANGE, data: {"window": status});
    } catch (e) {
      debugPrint(e);
    }
  }

  /// 实例化 SharedPreferences
  Future<void> _prefsInstance() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// 设置检索知识库信息列表
  void setHandshakeKeywordList(List<KnowledgeModel> data) {
    handshakeKeywordList = data;
    notifyListeners();
  }

  /// 获取服务器消息列表
  Future<void> getMessageRecord({int timestamp, int pageSize = 20}) async {
    try {
      Response response = await http
          .post(API_GET_MESSAGE,
              data: {
                "timestamp": timestamp ?? DateTime.now().millisecondsSinceEpoch,
                "page_size": pageSize,
                "account": imUser.id
              },
              options: Options(headers: {"token": imUser.token}))
          .catchError((onError) {
        debugPrint(onError);
      });
      if (response.data["code"] == 200) {
        List<ImMessage> _msgs = (response.data['data']['list'] as List)
            .map((i) => _handlerMessage(ImMessage.fromJson(i)))
            .toList();
        for (var i = 0; i < _msgs.length; i++) {
          _msgs[i].payload = utf8.decode(base64Decode(_msgs[i].payload));
        }
        if (_msgs.length < pageSize) {
          isScrollEnd = true;
        }
        if (messagesRecord.length == 0) {
          messagesRecord = _msgs;
        } else {
          messagesRecord.insertAll(0, _msgs);
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e);
    }
  }

  /// 获取IM 未读消息
  Future<int> getReadCount() async {
    int _count = 0;
    Response response = await http.get(API_GET_READ);
    if (response.data["code"] == 200) {
      _count = response.data["data"];
      messageReadCount = _count;
      notifyListeners();
    }
    return _count;
  }

  /// 清除IM未读消息
  Future<void> cleanRead() async {
    messageReadCount = 0;
    await http.get(API_CLEAN_READ);
    notifyListeners();
  }

  /// 上报IM最后活动时间
  Future<void> _upImLastActivity() async {
    Timer.periodic(Duration(milliseconds: 20000), (_) {
      if (imUser != null) http.get(API_ACTIVITY);
    });
  }

  /// 获取配置信息
  Future<void> _getImConfigs() async {
    Response response = await http.get(API_UPLOAD_SECRET);
    if (response.data["code"] == 200) {
      imConfigs = ImConfigs.fromJson(response.data["data"]);
    } else {
      await Future.delayed(Duration(milliseconds: 1000));
      _getImConfigs();
    }
  }

  /// 创建消息
  /// [toAccount] 接收方账号
  /// [msgType]   消息类型
  /// [content]   消息内容
  MessageHandle createMessage(
      {int toAccount, String msgType, dynamic content}) {
    MIMCMessage message = MIMCMessage();
    String millisecondsSinceEpoch =
        DateTime.now().millisecondsSinceEpoch.toString();
    int timestamp = int.parse(
        millisecondsSinceEpoch.substring(0, millisecondsSinceEpoch.length - 3));
    message.timestamp = timestamp;
    message.bizType = msgType;
    message.toAccount = toAccount.toString();
    Map<String, dynamic> payloadMap = {
      "from_account": imUser.id,
      "to_account": toAccount,
      "biz_type": msgType,
      "version": "0",
      "key": DateTime.now().millisecondsSinceEpoch,
      "platform": Platform.isAndroid ? 6 : 2,
      "timestamp": timestamp,
      "read": 0,
      "transfer_account": 0,
      "payload": "$content"
    };
    message.payload = base64Encode(utf8.encode(json.encode(payloadMap)));
    return MessageHandle(
        sendMessage: message,
        localMessage: ImMessage.fromJson(payloadMap)..isShowCancel = true);
  }

  /// 发送消息
  void sendMessage(MessageHandle msgHandle) async {
    //  发送失败提示
    if (!await flutterMImc.isOnline()) {
      MessageHandle tipsMsg = createMessage(
          toAccount: toAccount, msgType: "system", content: "您的网络异常，发送失败了~");
      messagesRecord.add(tipsMsg.localMessage);
      return;
    }

    flutterMImc.sendMessage(msgHandle.sendMessage);

    // 重新设定客服是否超时没回复
    prefs.setInt("adminLastCallBackMessageTime_$toAccount",
        DateTime.now().millisecondsSinceEpoch);
    isServciceLastMessageTimeNotCallBackCompute = true;
    isCheckIsloogTimeNotCallBackCompute = false;

    /// 消息入库（远程）
    MessageHandle cloneMsgHandle = msgHandle.clone();
    String type = cloneMsgHandle.localMessage.bizType;
    if (type == "contacts" ||
        type == "pong" ||
        type == "welcome" ||
        type == "handshake") return;
    cloneMsgHandle.sendMessage.toAccount = robot.id.toString();
    cloneMsgHandle.sendMessage.payload = ImMessage(
      bizType: "into",
      payload: cloneMsgHandle.localMessage.toBase64(),
    ).toBase64();
    flutterMImc.sendMessage(cloneMsgHandle.sendMessage);
    ImMessage newMsg = _handlerMessage(cloneMsgHandle.localMessage);
    if (type != "photo") messagesRecord.add(newMsg);
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 10000));
    newMsg.isShowCancel = false;
    notifyListeners();
  }

  // 更新某个消息
  void updateMessage(ImMessage msg) {
    int index = messagesRecord.indexWhere((i) => i.key == msg.key);
    messagesRecord[index] = msg;
    notifyListeners();
  }

  /// 删除消息
  void deleteMessage(ImMessage msg) {
    if (msg == null) return;
    int index = messagesRecord.indexWhere(
        (i) => i.key == msg.key && i.fromAccount == msg.fromAccount);
    messagesRecord.removeAt(index);
    notifyListeners();
  }

  // 处理头像昵称
  ImMessage _handlerMessage(ImMessage msg) {
    const String defaultAvatar = 'http://qiniu.cmp520.com/avatar_degault_3.png';
    msg.avatar = defaultAvatar;
    // 消息是我发的
    if (msg.fromAccount == imUser.id) {
      /// 这里如果是接入业务平台可替换成用户头像和昵称
      /// if (uid == myUid)  msg.avatar = MyAvatar
      /// if (uid == myUid)  msg.nickname = MyNickname
      msg.nickname = "我";
    } else {
      if (serviceUser != null && serviceUser.id == msg.fromAccount) {
        msg.nickname = serviceUser.nickname ?? "客服";
        msg.avatar = serviceUser.avatar != null && serviceUser.avatar.isNotEmpty
            ? serviceUser.avatar
            : defaultAvatar;
      } else {
        String _localServiceUserStr =
            prefs.getString("service_user_" + msg.fromAccount.toString());
        if (_localServiceUserStr != null) {
          ServiceUser _localServiceUser =
              ServiceUser.fromJson(json.decode(_localServiceUserStr));
          msg.nickname = _localServiceUser.nickname ?? "客服";
          msg.avatar = _localServiceUser.avatar != null &&
                  _localServiceUser.avatar.isNotEmpty
              ? _localServiceUser.avatar
              : defaultAvatar;
        } else if (robot != null && robot.id == msg.fromAccount) {
          msg.nickname = robot.nickname ?? "客服";
          msg.avatar = robot.avatar != null && robot.avatar.isNotEmpty
              ? robot.avatar
              : defaultAvatar;
        } else {
          String _localRobotStr =
              prefs.getString("robot_" + msg.fromAccount.toString());
          if (_localRobotStr != null) {
            Robot _localRobot = Robot.fromJson(json.decode(_localRobotStr));
            msg.nickname = _localRobot.nickname ?? "机器人";
            msg.avatar =
                _localRobot.avatar != null && _localRobot.avatar.isNotEmpty
                    ? _localRobot.avatar
                    : defaultAvatar;
          } else {
            msg.nickname = "未知";
            msg.avatar = defaultAvatar;
          }
        }
      }
    }
    return msg;
  }

  /// mimc事件监听
  StreamSubscription _subStatus;
  StreamSubscription _subHandleMessage;
  void _addMimcEvent() {
    try {
      /// 状态发生改变
      _subStatus = flutterMImc
          .addEventListenerStatusChanged()
          .listen((bool isLogin) async {
        debugPrint("状态发生改变===$isLogin");
        // 发送握手消息
        if (isLogin && !isService) {
          MessageHandle messageHandle = createMessage(
              toAccount: toAccount, msgType: "handshake", content: "我要对机器人问好");
          sendMessage(messageHandle);
        }
      });

      /// 消息监听
      _subHandleMessage = flutterMImc
          .addEventListenerHandleMessage()
          .listen((MIMCMessage msg) async {
        ImMessage message = ImMessage.fromJson(
            json.decode(utf8.decode(base64Decode(msg.payload))));
        debugPrint("收到消息======${message.toJson()}");
        // 保存最后服务时间
        if (isService) {
          prefs.setInt("serviceLastTime${imUser.id}",
              DateTime.now().millisecondsSinceEpoch);
        }
        // 计算客服用户最后回复时间
        if (isService &&
            (message.bizType == "text" ||
                message.bizType == "transfer" ||
                message.bizType == "photo" ||
                message.bizType == 'cancel')) {
          isCheckIsloogTimeNotCallBackCompute = true;
          prefs.setInt("userLastCallBackMessageTime_${imUser.id}",
              DateTime.now().millisecondsSinceEpoch);
          isServciceLastMessageTimeNotCallBackCompute = false;
        }

        switch (message.bizType) {
          case "transfer":
            serviceUser = ServiceUser.fromJson(json.decode(message.payload));
            prefs.setString("service_user_${serviceUser.id}", message.payload);
            prefs.setString(
                "currentServiceUser_${imUser?.id}", message.payload);
            isService = true;
            break;
          case "end":
          case "timeout":
            serviceUser = null;
            isService = false;
            prefs.remove("currentServiceUser_${imUser?.id}");
            notifyListeners();
            break;
          case "pong":
            if (isPong) return;
            isPong = true;
            notifyListeners();
            await Future.delayed(Duration(milliseconds: 1500));
            isPong = false;
            notifyListeners();
            break;
          case "cancel":
            message.key = int.parse(message.payload);
            deleteMessage(message);
            break;
          case "search_knowledge":
            handshakeKeywordList = [];
            if (message.payload != "") {
              handshakeKeywordList = ((json.decode(message.payload) as List)
                  .map((i) => KnowledgeModel.fromJson(i))
                  .toList());
            }
            notifyListeners();
            break;
        }

        if (window == 0 && message.bizType != 'pong') {
          messageReadCount = messageReadCount + 1;
        }

        // 不处理的消息
        if (message.bizType == 'search_knowledge' || message.bizType == "pong")
          return;

        ImMessage newMsg = _handlerMessage(message);
        messagesRecord.add(newMsg);
        notifyListeners();
      });
    } catch (e) {
      debugPrint(e);
    }
  }

  /// 登录Im
  Future<void> loginIm() async {
    await Future.delayed(Duration(milliseconds: delayLoginTime));
    if (!await flutterMImc?.isOnline()) {
      debugPrint("登录中...");
      flutterMImc?.login();
      return;
    }
    await Future.delayed(Duration(milliseconds: 2000));
    loginIm();
  }

  /// 上传发送图片
  void sendPhoto(File file) async {
    if (file == null) return;
    MessageHandle msgHandle;
    msgHandle = createMessage(
        toAccount: toAccount, msgType: "photo", content: file.path);
    messagesRecord.add(_handlerMessage(msgHandle.localMessage));
    notifyListeners();

    void uploadSuccess(url) async {
      msgHandle.localMessage.isShowCancel = true;
      msgHandle.localMessage.payload = url;
      notifyListeners();
      ImMessage sendMsg = ImMessage.fromJson(json
          .decode(utf8.decode(base64Decode(msgHandle.sendMessage.payload))));
      sendMsg.payload = url;
      msgHandle.sendMessage.payload =
          base64Encode(utf8.encode(json.encode(sendMsg.toJson())));
      sendMessage(msgHandle.clone()..localMessage.payload = url);
      await Future.delayed(Duration(milliseconds: 10000));
      msgHandle.localMessage.isShowCancel = false;
      notifyListeners();
    }

    // uploadFile
    uploadFile(file, success: uploadSuccess,
        onSendProgress: (int sent, int total) {
      msgHandle.localMessage.uploadProgress = (sent / total * 100).ceil();
      notifyListeners();
    }, fail: () {
      deleteMessage(msgHandle.localMessage);
      MessageHandle systemMsgHandle = createMessage(
          toAccount: toAccount, msgType: "system", content: "图片上传失败！");
      messagesRecord.add(_handlerMessage(systemMsgHandle.localMessage));
    });
  }

  // uploadFile
  Future<void> uploadFile(File file,
      {Function(String) success,
      String fileType = "image",
      String fileName = "file",
      VoidCallback fail,
      Function(int, int) onSendProgress}) async {
    if (file == null) return "";
    try {
      if (file == null) return "";
      String filePath = file.path;
      String fileName = "${DateTime.now().microsecondsSinceEpoch}_" +
          (filePath.lastIndexOf('/') > -1
              ? filePath.substring(filePath.lastIndexOf('/') + 1)
              : filePath);

      FormData formData = new FormData.fromMap({
        "fileType": fileType,
        "fileName": fileName,
        "file_name": fileName,
        "key": fileName,
        "token": imConfigs.uploadSecret ?? "",
        "file": MultipartFile.fromFileSync(file.path, filename: fileName)
      });

      String uploadUrl;

      /// 系统自带
      if (imConfigs.uploadMode == 1) {
        uploadUrl = API_UPLOAD_FILE;
      }

      /// 七牛上传
      else if (imConfigs.uploadMode == 2) {
        uploadUrl = API_QINIU_UPLOAD_FILE;

        /// 其他
      } else {}

      Response response = await http.post(uploadUrl,
          data: formData, onSendProgress: onSendProgress);
      if (response.statusCode == 200) {
        switch (imConfigs.uploadMode) {
          case 1:
            success(imConfigs.uploadHost + "/" + response.data["data"]);
            break;
          case 2:
            success(imConfigs.uploadHost + "/" + response.data["key"]);
            break;
        }
      } else {
        if (fail != null) fail();
      }
    } catch (_) {
      if (fail != null) fail();
    }
  }

  // 消息内容变,ping, pong
  bool isSendPong = false;
  void inputOnChanged(String value) async {
    if (!isService || isSendPong) return;
    isSendPong = true;
    MessageHandle _msgHandle =
        createMessage(toAccount: toAccount, msgType: "pong", content: value);
    sendMessage(_msgHandle);
    await Future.delayed(Duration(milliseconds: 200));
    isSendPong = false;
    notifyListeners();
  }

  // 判断是否被踢出对话
  void _checkIsOutSession() async {
    int serviceLastTime = prefs.getInt("serviceLastTime${imUser.id}");
    if (serviceLastTime != null) {
      if (DateTime.now().millisecondsSinceEpoch >
          serviceLastTime + tomeOutTime) {
        isService = false;
        serviceUser = null;
        prefs.remove("currentServiceUser_${imUser?.id}");
        notifyListeners();
      }
    }
    await Future.delayed(Duration(milliseconds: 60000));
    _checkIsOutSession();
  }

  // 计算用户是否长时间未回复弹出给出提示
  bool isCheckIsloogTimeNotCallBackCompute = false;
  void _onCheckIsloogTimeNotCallBack() async {
    if (isCheckIsloogTimeNotCallBackCompute) {
      int nowTimer = DateTime.now().millisecondsSinceEpoch;
      int lastCallBackMessageTime =
          prefs.getInt("userLastCallBackMessageTime_${imUser.id}") ?? nowTimer;
      if (isService &&
          (nowTimer - lastCallBackMessageTime) >= (1000 * 60) * 5) {
        MessageHandle msgHandle = createMessage(
            toAccount: toAccount,
            msgType: "system",
            content: "您已超过5分钟未回复消息，系统3分钟后将结束对话");
        ImMessage _msg = _handlerMessage(msgHandle.localMessage);
        messagesRecord.add(_msg);
        isCheckIsloogTimeNotCallBackCompute = false;
        notifyListeners();
        debugPrint("您已超过5分钟未回复消息，系统3分钟后将结束对话");
        toScrollEnd();
      }
    }
    await Future.delayed(Duration(milliseconds: 5000));
    _onCheckIsloogTimeNotCallBack();
  }

  // 计算客服最后回复时间(超过2分钟没回复给出提示)
  bool isServciceLastMessageTimeNotCallBackCompute = false;
  void _onServciceLastMessageTimeNotCallBack() async {
    if (isServciceLastMessageTimeNotCallBackCompute) {
      String loogTimeWaitText = robot.loogTimeWaitText;
      int nowTimer = DateTime.now().millisecondsSinceEpoch;
      int lastCallBackMessageTime =
          prefs.getInt("adminLastCallBackMessageTime_$toAccount") ?? nowTimer;
      if (isService &&
          loogTimeWaitText.isNotEmpty &&
          (nowTimer - lastCallBackMessageTime) >= (1000 * 60) * 2) {
        MessageHandle msgHandle = createMessage(
            toAccount: toAccount, msgType: "text", content: loogTimeWaitText);
        msgHandle.localMessage.fromAccount = robot.id;
        msgHandle.localMessage.isShowCancel = false;
        ImMessage _msg = _handlerMessage(msgHandle.localMessage);
        messagesRecord.add(_msg);
        isServciceLastMessageTimeNotCallBackCompute = false;
        notifyListeners();
        toScrollEnd();
      }
    }

    await Future.delayed(Duration(milliseconds: 5000));
    _onServciceLastMessageTimeNotCallBack();
  }

  /// 滚动条至底部
  void toScrollEnd() async {
    if (window == 0) return;
    await Future.delayed(Duration(milliseconds: 100));
    scrollController?.jumpTo(0);
  }

  @override
  void dispose() {
    _subStatus?.cancel();
    _subHandleMessage?.cancel();
    scrollController?.dispose();
    super.dispose();
  }
}

/// MiNiIm screen
class _KeFu extends StatefulWidget {
  @override
  _KeFuState createState() => _KeFuState();
}

/// im screen state
class _KeFuState extends State<_KeFu> {
  /// 客服store
  KeFuStore _keFuStore = KeFuStore.getInstance;

  /// 是否显示表情面板
  bool _isShowEmoJiPanel = false;

  /// 输入键盘相关
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();

  /// 加载更多...
  bool _isMorLoading = false;

  // 检索知识库消息
  Timer _searchHandshakeTimer;
  void _onSearchHandshake(String value) async {
    if (_keFuStore.isService || !await _keFuStore.flutterMImc.isOnline())
      return;
    String content = value.trim();
    if (content == "" || content.isEmpty) {
      _keFuStore.setHandshakeKeywordList([]);
    }
    if (_searchHandshakeTimer != null) _searchHandshakeTimer.cancel();
    _searchHandshakeTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      MessageHandle msgHandle = _keFuStore.createMessage(
          toAccount: _keFuStore.toAccount,
          msgType: "search_knowledge",
          content: content);
      _keFuStore.sendMessage(msgHandle);
      _keFuStore.setHandshakeKeywordList([]);
      _searchHandshakeTimer?.cancel();
      _searchHandshakeTimer = null;
    });
  }

  /// 初始化生命周期
  @override
  void initState() {
    super.initState();
    if (mounted) {
      _focusNode.addListener(() {
        if (_focusNode.hasFocus) {
          _onHideEmoJiPanel();
          _keFuStore.toScrollEnd();
        }
      });

      /// 监听滚动条
      _keFuStore.scrollController
          .addListener(() => _onScrollViewControllerAddListener());

      // 监听消息
      _addEventMessage();

      // 进入客服窗口
      _keFuStore.setWindow(1);

      // 清除未读消息
      _keFuStore.cleanRead();
    }
  }

  /// 监听接收消息
  void _addEventMessage() {
    _keFuStore.flutterMImc
        ?.addEventListenerHandleMessage()
        ?.listen((MIMCMessage msg) {
      // 滚动条置底
      _keFuStore.toScrollEnd();
    });
  }

  // 监听滚动条
  void _onScrollViewControllerAddListener() async {
    try {
      ScrollPosition position = _keFuStore.scrollController?.position;
      // 判断是否到底部
      if (position.pixels + 15.0 > position.maxScrollExtent &&
          !_keFuStore.isScrollEnd &&
          !_isMorLoading) {
        _isMorLoading = true;
        setState(() {});
        await Future.delayed(Duration(milliseconds: 1000));
        _keFuStore.getMessageRecord(
            timestamp: _keFuStore.messagesRecord[0].timestamp);
        _isMorLoading = false;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e);
    }
  }

  // _goToWprkOrder
  void _goToWprkOrder(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WorkOrder()));
  }

  /// 点击发送按钮(发送消息)
  void _onSubmit() async {
    String content = _editingController.value.text.trim();
    if (content.isEmpty) return;
    MessageHandle messageHandle = _keFuStore.createMessage(
        toAccount: _keFuStore.toAccount, msgType: "text", content: content);
    _keFuStore.sendMessage(messageHandle);
    _editingController.clear();
    _keFuStore.toScrollEnd();
    await Future.delayed(Duration(milliseconds: 500));
    _keFuStore.setHandshakeKeywordList([]);
  }

  /// onShowEmoJiPanel
  void _onShowEmoJiPanel() async {
    FocusScope.of(context).requestFocus(FocusNode());
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      _isShowEmoJiPanel = true;
    });
  }

  /// onHideEmoJiPanel
  void _onHideEmoJiPanel() {
    setState(() {
      _isShowEmoJiPanel = false;
    });
  }

  /// EmoJiPanel
  Widget _emoJiPanel() {
    return EmoJiPanel(
      isShow: _isShowEmoJiPanel,
      onSelected: (String emoji) {
        _editingController.text = _editingController.value.text + emoji;
      },
    );
  }

  ///  接入人工 or 结束会话
  bool _isOnHeadRightButton = false;
  _onHeadRightButton() async {
    if (_isOnHeadRightButton) return;
    _isOnHeadRightButton = true;
    if (_keFuStore.isService) {
      ImUtils.alert(context, content: "您是否确认关闭本次会话？", onConfirm: () {
        MessageHandle msgHandle = _keFuStore.createMessage(
            toAccount: _keFuStore.toAccount, msgType: "end", content: "");
        _keFuStore.sendMessage(msgHandle);
        _keFuStore.isService = false;
        _keFuStore.prefs.remove("currentServiceUser_${_keFuStore?.imUser?.id}");
        setState(() {});
      });
      await Future.delayed(Duration(milliseconds: 1000));
      _isOnHeadRightButton = false;
      return;
    }
    _editingController.text = "人工";
    _onSubmit();
    setState(() {});
    await Future.delayed(Duration(milliseconds: 1000));
    _isOnHeadRightButton = false;
  }

  /// 选择图片文件
  void _getImage(ImageSource source) async {
    File _file = await ImagePicker.pickImage(source: source, maxWidth: 2000);
    if (_file == null) return;
    _keFuStore.sendPhoto(_file);
  }

  // 操作消息
  void _onMessageOperation(ImMessage message) {
    bool isLocalImage = message.payload != null &&
        !message.payload.contains(RegExp(r'^(http://|https://)'));
    bool isPhoto = message.bizType == "photo";
    Widget _delete() {
      return CupertinoDialogAction(
        child: const Text('删除'),
        onPressed: () {
          _keFuStore.deleteMessage(message);
          Navigator.pop(context);
        },
      );
    }

    Widget _cancel() {
      return CupertinoDialogAction(
        child: const Text('撤回'),
        onPressed: () {
          _onCancelMessage(message);
          Navigator.pop(context);
        },
      );
    }

    Widget _close() {
      return CupertinoDialogAction(
        child: const Text('取消'),
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }

    Widget _copy() {
      return CupertinoDialogAction(
        child: Text(isPhoto ? "复制图片链接" : '复制'),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: message.payload));
          Navigator.pop(context);
          ImUtils.alert(context, content: "消息已复制到粘贴板");
        },
      );
    }

    List<Widget> actions = [];
    if (message.isShowCancel) actions.add(_cancel());
    actions.add(_delete());
    if (message.bizType == "text") actions.add(_copy());
    if (isPhoto && !isLocalImage) {
      actions.add(_copy());
    }
    actions.add(_close());

    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
              title: Text(
                '消息操作',
                style: TextStyle(
                    color: Colors.black.withAlpha(150), fontSize: 14.0),
              ),
              content: isPhoto
                  ? SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: CachedImage(
                          width: 100.0,
                          height: 100.0,
                          bgColor: Colors.transparent,
                          fit: BoxFit.contain,
                          src: "${message.payload}..."),
                    )
                  : Text(
                      message.payload,
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(height: 1.5, color: Colors.black87),
                    ),
              actions: actions);
        });
  }

  // 撤回一条消息
  void _onCancelMessage(ImMessage msg) {
    if (!msg.isShowCancel) {
      debugPrint("已超过撤回时间！");
      return;
    }
    MessageHandle msgHandle = _keFuStore.createMessage(
        toAccount: _keFuStore.toAccount, msgType: "cancel", content: msg.key);
    _keFuStore.sendMessage(msgHandle);
    _keFuStore.deleteMessage(msg);
  }

  /// footer bar
  Widget _bottomBar() {
    ThemeData themeData = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.withAlpha(60), width: .5),
            bottom: BorderSide(
                color: Colors.grey.withAlpha(_isShowEmoJiPanel ? 60 : 0),
                width: .5),
          )),
      constraints: BoxConstraints(
        minHeight: 80.0,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            child: Row(
              children: <Widget>[
                GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.insert_emoticon,
                        color: Colors.black26,
                        size: 28,
                      ),
                    ),
                    onTap: _isShowEmoJiPanel
                        ? _onHideEmoJiPanel
                        : _onShowEmoJiPanel),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(3.0),
                    child: Icon(
                      Icons.image,
                      color: Colors.black26,
                      size: 28,
                    ),
                  ),
                  onTap: () => _getImage(ImageSource.gallery),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(3.0),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.black26,
                      size: 28,
                    ),
                  ),
                  onTap: () => _getImage(ImageSource.camera),
                ),
                Offstage(
                  offstage: _keFuStore.imConfigs.openWorkorder == 0,
                  child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(3.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.library_books,
                              color: Colors.black26,
                              size: 25,
                            ),
                            Text("工单",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ))
                          ],
                        ),
                      ),
                      onTap: () => _goToWprkOrder(context)),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Container(
                      constraints: BoxConstraints(minHeight: 50.0),
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: TextField(
                        cursorColor: themeData.primaryColor,
                        decoration: InputDecoration(
                            hintText: "请用一句话描述您的问题~",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey.withAlpha(150),
                            ),
                            counterStyle:
                                TextStyle(color: Colors.grey.withAlpha(200)),
                            contentPadding: EdgeInsets.symmetric(vertical: 3.0),
                            counterText: ""),
                        style: TextStyle(color: Colors.black.withAlpha(170)),
                        focusNode: _focusNode,
                        controller: _editingController,
                        minLines: 1,
                        maxLines: 5,
                        maxLength: 200,
                        onSubmitted: (_) {
                          _onSubmit();
                          FocusScope.of(context).requestFocus(_focusNode);
                        },
                        textInputAction: Platform.isIOS
                            ? TextInputAction.send
                            : TextInputAction.newline,
                        onChanged: (String value) {
                          _onSearchHandshake(value);
                          _keFuStore.inputOnChanged(value);
                        },
                      ))),
              Offstage(
                offstage: Platform.isIOS && !_isShowEmoJiPanel,
                child: Center(
                  child: SizedBox(
                    width: 60.0,
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        _onSubmit();
                        FocusScope.of(context).requestFocus(_focusNode);
                      },
                      child: Text(
                        "发送",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 离开客服窗口
    _keFuStore.setWindow(0);
    _focusNode?.dispose();
    _editingController?.dispose();
    super.dispose();
  }

  /// AppBar
  Widget _appBar(BuildContext context) {
    final keFuState = Provider.of<KeFuStore>(context);
    return AppBar(
      centerTitle: true,
      title: Text(keFuState.isPong ? "对方正在输入..." : '在线客服'),
      actions: <Widget>[
        Offstage(
          offstage: !keFuState.isService,
          child: FlatButton(
            child: Text(
              "结束会话",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _onHeadRightButton,
          ),
        ),
        Offstage(
            offstage: keFuState.isService,
            child: IconButton(
              icon: Image.network("http://qiniu.cmp520.com/kefu_icon_2000.png",
                  width: 25.0, height: 25.0),
              onPressed: _onHeadRightButton,
            ))
      ],
    );
  }

  /// knowledge Widget
  Widget _knowledgeWidget(BuildContext context) {
    final keFuState = Provider.of<KeFuStore>(context);
    return Offstage(
      offstage: keFuState.handshakeKeywordList.length == 0,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text("以下是您关心的问题？"),
            ),
            Divider(
              height: 1.0,
            ),
            Column(
              children: List.generate(keFuState.handshakeKeywordList.length,
                  (int index) {
                KnowledgeModel item = keFuState.handshakeKeywordList[index];
                return SizedBox(
                  height: 33.0,
                  child: CupertinoButton(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    onPressed: () {
                      _editingController.text = item.title;
                      _onSubmit();
                    },
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 3.0),
                          child: Text(
                            " • ",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${item.title}",
                            style: TextStyle(fontSize: 14.0),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(_) {
    return ChangeNotifierProvider<KeFuStore>.value(
        value: _keFuStore,
        child: Builder(
          builder: (BuildContext context) {
            final keFuState = Provider.of<KeFuStore>(context);

            return Scaffold(
              appBar: _appBar(context),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onPanDown: (_) {
                        _onHideEmoJiPanel();
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: CustomScrollView(
                        controller: _keFuStore.scrollController,
                        reverse: true,
                        slivers: <Widget>[
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20.0),
                            sliver: SliverList(
                                delegate: SliverChildBuilderDelegate((ctx, i) {
                              int index =
                                  keFuState.messagesRecord.length - i - 1;
                              ImMessage _msg = keFuState.messagesRecord[index];

                              /// 判断是否需要显示时间
                              if (i == keFuState.messagesRecord.length - 1 ||
                                  (_msg.timestamp - 120) >
                                      keFuState.messagesRecord[index - 1]
                                          .timestamp) {
                                _msg.isShowDate = true;
                              }

                              switch (_msg.bizType) {
                                case "text":
                                case "welcome":
                                  return TextMessage(
                                    message: _msg,
                                    isSelf:
                                        _msg.fromAccount == keFuState.imUser.id,
                                    onCancel: () => _onCancelMessage(_msg),
                                    onOperation: () =>
                                        _onMessageOperation(_msg),
                                  );
                                case "workorder":
                                  return WorkorderMessage(
                                    message: _msg,
                                  );
                                case "photo":
                                  return PhotoMessage(
                                    message: _msg,
                                    isSelf:
                                        _msg.fromAccount == keFuState.imUser.id,
                                    onCancel: () => _onCancelMessage(_msg),
                                    onOperation: () =>
                                        _onMessageOperation(_msg),
                                  );
                                case "end":
                                case "transfer":
                                case "cancel":
                                case "timeout":
                                case "system":
                                  return SystemMessage(
                                    message: _msg,
                                    isSelf:
                                        _msg.fromAccount == keFuState.imUser.id,
                                  );
                                case "knowledge":
                                  return KnowledgeMessage(
                                    message: _msg,
                                    onSend: (msg) {
                                      _editingController.text =
                                          msg.title == "以上都不是？我要找人工"
                                              ? "人工"
                                              : msg.title;
                                      _onSubmit();
                                    },
                                  );
                                default:
                                  return SizedBox();
                              }
                            }, childCount: keFuState.messagesRecord.length)),
                          ),
                          SliverToBoxAdapter(
                            child: Offstage(
                              offstage: !_isMorLoading,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Platform.isAndroid
                                        ? SizedBox(
                                            width: 10.0,
                                            height: 10.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                            ))
                                        : CupertinoActivityIndicator(),
                                    Text(
                                      "  加载更多",
                                      style: TextStyle(color: Colors.black38),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: SafeArea(
                      top: false,
                      child: Column(
                        children: <Widget>[
                          _knowledgeWidget(context),
                          _bottomBar(),
                          _emoJiPanel(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}
