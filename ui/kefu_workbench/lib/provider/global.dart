
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_mimc/flutter_mimc.dart';
import 'package:kefu_workbench/models/work_order_counts_model.dart';
import 'package:kefu_workbench/models/work_order_type.dart';
import 'package:kefu_workbench/services/api.dart';
import 'package:kefu_workbench/services/workorder_service.dart';

import '../core_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 创建消息辅助对象
///  [sendMessage] 发送对象
///  [imMessage]  本地显示对象
class MessageHandle {
  MessageHandle({this.sendMessage, this.localMessage});
  MIMCMessage sendMessage;
  ImMessageModel localMessage;
  MessageHandle clone() {
    return MessageHandle(
      sendMessage: MIMCMessage.fromJson(sendMessage.toJson()),
      localMessage: ImMessageModel.fromJson(localMessage.toJson()),
    );
  }
}

/// GlobalProvide
class GlobalProvide with ChangeNotifier {

  /// root context
  BuildContext rooContext;

  /// 当前路由路径
  String currentRoutePath = "home";

  /// ChatProvide是否已销毁
  bool chatProvideIsDispose = true;

  /// 当前主题
  ThemeProvide get themeProvide =>  ThemeProvide.getInstance();
  ThemeData get getCurrentTheme => themeProvide.getCurrentTheme();
  
  /// MessageService
  MessageService messageService = MessageService.getInstance();

  /// AdminService
  AdminService adminService = AdminService.getInstance();

  /// PublicService
  PublicService publicService = PublicService.getInstance();

  /// ContactService
  ContactService contactService = ContactService.getInstance();

  /// ShortcutService
  ShortcutService shortcutService = ShortcutService.getInstance();

  /// PlatformService
   PlatformService platformService = PlatformService.getInstance();

  /// GlobalProvide实例
  static GlobalProvide instance;

  /// 聊天列表数据
  List<ContactModel> contacts = [];

  /// 快捷语
  List<ShortcutModel> shortcuts = [];

  /// app运行状态
  AppLifecycleState appLifecycleState;

  /// 客服信息
  AdminModel serviceUser;

  /// 当前服务谁
  ContactModel currentContact;

  /// IM 签名对象
  ImTokenInfoModel imTokenInfo;

  /// 缓存对象
  SharedPreferences prefs;

  /// 机器人对象
  RobotModel robot;

  /// 上传配置对象
  ImConfigs imConfigs;

  /// IM 插件对象
  FlutterMIMC flutterMImc;

  /// 聊天记录
  Map<dynamic, List<ImMessageModel>> messagesRecords = {};

  /// 当前聊天用户的消息记录
  List<ImMessageModel> currentUserMessagesRecords(int accountId){
    return messagesRecords[accountId ?? currentContact.fromAccount] ?? [];
  }

  /// 是否显示loading
  bool isChatFullLoading = false;

  // 是否是获取历史表数据
  bool isGetHistoryMessage = false;


  /// 平台数据
  List<PlatformModel> platforms = [];

  /// 工单统计
  WorkOrderCountsModel workOrderCounts;
  int get newWorkHandleCounts{
    try{
      return workOrderCounts.status0 + workOrderCounts.status1;
    }catch(_){
      return 0;
    }
  }


  /// 工单类型
  List<WorkOrderTypeModel> workOrderTypes= [];

  /// 显示对方输入中...
  bool isPong = false;
  String advanceText = "";

  /// 当前用户ID
  int toAccount;

  /// 设置app运行状态
  /// AppLifecycleState.paused 暂停
  /// AppLifecycleState.inactive 不活跃
  /// AppLifecycleState.resumed 已恢复
  void setAppLifecycleState(AppLifecycleState state){
    this.appLifecycleState = state;
  }

  /// 设置当前路由路径
  void setCurrentRoutePath(String path){
    this.currentRoutePath = path;
  }

  /// set rooContext
  void setRooContext(BuildContext context){
    rooContext = context;
  }

  // 单列 获取对象
  static GlobalProvide getInstance() {
    if (instance == null) {
      instance = GlobalProvide();
    }
    return instance;
  }

  /// 初始化
  /// return bool
  Future<void> init() async {
    await _prefsInstance();
    await getMe();
    if(isLogin){
      await _getOnlineRobot();
      await getConfigs();
      await _registerImAccount();
      await _flutterMImcInstance();
      await _addMimcEvent();
      await getContacts(isFullLoading: true);
       _upImLastActivity();
       getShortcuts();
       getPlatforms();
       getWorkOrderCounts();
       getWorkorderTypes();
    }
  }

  /// is login
  bool get isLogin{
    String authorization = prefs.getString("Authorization");
    String serviceUserString = prefs.getString("serviceUser");
    if(serviceUserString != null){
      serviceUser = AdminModel.fromJson(json.decode(serviceUserString));
    }
    if(authorization != null && serviceUser != null){
      return true;
    }else{
      printf("未登录~");
      return false;
    }
  }

  /// APP应用级别退出登录
  /// 重置一些默认初始化
  void applicationLogout() async{
    await AuthService.getInstance().logout();
    prefs.remove("serviceUser");
    prefs.remove("Authorization");
    setServiceUser(null);
    flutterMImc?.logout();
  }

  /// 获取个人信息
  Future<void> getMe() async {
    try{
      Response response = await adminService.getMe();
      if (response.data["code"] == 200) {
        serviceUser = AdminModel.fromJson(response.data['data']);
        setServiceUser(serviceUser);
        if(serviceUser.online != 0){
          flutterMImc?.login();
        }
      } else {
        applicationLogout();
      }
    }catch(_){
       applicationLogout();
    }
  }


  /// 可转接的客服
  List<AdminModel> serviceOnlineUsers = [];

   /// 获取客服
  void getOnlineAdmins() async{
    Response response = await  adminService.getAdmins(pageOn: 1, pageSize: 1000, online: 3);
    if (response.data["code"] == 200) {
      serviceOnlineUsers = (response.data['data']['list'] as List).map((i) => AdminModel.fromJson(i)).toList();
      notifyListeners();
    } else {
      UX.showToast(response.data['message']);
    }
  }

  /// 获取快捷语
  Future<void> getShortcuts() async {
     Response response = await shortcutService.getShortcuts();
      if (response.data["code"] == 200) {
        shortcuts = (response.data['data'] as List).map((i) => ShortcutModel.fromJson(i)).toList();
        notifyListeners();
      } else {
        UX.showToast(response.data['message']);
      }
  }

  /// 设置serviceUser
  void setServiceUser(AdminModel user){
    serviceUser = user;
    notifyListeners();
    if(user == null) return;
    prefs.setString("serviceUser", jsonEncode(user.toJson()));
  }

  /// 实例化 FlutterMImc
  Future<void> _flutterMImcInstance() async {
    if(imTokenInfo == null) return;
    try{
      String tokenString = '{"code": 200, "message": "success", "data": ${jsonEncode(imTokenInfo?.toJson())}}';
      flutterMImc = await FlutterMIMC.stringTokenInit(tokenString, debug: true);
      if(serviceUser != null && serviceUser.online != 0){
        flutterMImc.login();
      }
    } catch(_) {
      Navigator.pushNamedAndRemoveUntil(rooContext, "/login", ModalRoute.withName('/'), arguments: {"isAnimate": false});
    }
  }

  /// 注册IM账号
  Future<void> _registerImAccount() async {
    try {
      if(serviceUser == null) return;
      Response response = await publicService.registerImAccount(accountId: serviceUser.id);
      if (response.data["code"] == 200) {
        imTokenInfo =ImTokenInfoModel.fromJson(response.data["data"]["token"]["data"]);
      } else {
        // 1秒重
        await Future.delayed(Duration(milliseconds: 1000));
        _registerImAccount();
      }
    } catch (e) {
      debugPrint(e);
    }
  }

  /// 获取一个在线机器人
  Future<void> _getOnlineRobot() async {
    try {
      Response response = await RobotService.getInstance().getOnlineRobot();
      if (response.data["code"] == 200) {
        robot = RobotModel.fromJson(response.data["data"]);
      } else {
        // 1秒重
        await Future.delayed(Duration(milliseconds: 1000));
        _registerImAccount();
      }
    } catch (e) {
      debugPrint(e);
    }
  }

  /// 实例化 SharedPreferences
  Future<void> _prefsInstance() async {
    if(prefs != null) return;
    prefs = await SharedPreferences.getInstance();
  }

  /// 设置当前服务谁
  setCurrentContact(ContactModel contact){
    if(!chatProvideIsDispose) return;
    currentContact = contact;
    toAccount = currentContact.fromAccount;
    Navigator.pushNamed(rooContext, "/chat", arguments: {
      "userId": currentContact.uid
    }).then((_){
     getContacts();
    });
    isLoadRecordEnd = false;
    notifyListeners();
    getMessageRecord(isFirstLoad: true);
    getContacts();
    updateCurrentServiceUser(currentContact.fromAccount);
  }

  /// 更新当前服务谁
  void updateCurrentServiceUser(int account){
    adminService.updateCurrentServiceUser(accountId: account);
  }

  /// 更新客服上线状态
  Future<void> updateUserOnlineStatus({int online}) async{
    Response response = await adminService.updateUserOnlineStatus(status: online);
    if (response.data["code"] == 200) {
      getMe();
      if(online == 0){
        UX.showToast("当前状态为离线");
        flutterMImc.logout();
        updateCurrentServiceUser(0);
      }else if(online == 1){
        UX.showToast("当前状态为在线");
        flutterMImc.login();
      }else{
        UX.showToast("当前状态为离开");
        if(!await flutterMImc.isOnline()) flutterMImc.login();
      }
    } else {
      UX.showToast("${response.data["message"]}");
    }
  }

  /// 设置上下线
  void setOnline({int online}){
    if(serviceUser.online == online) return;
    UX.alert(rooContext,
     content: "您确定" + (online == 0 ? "下线" : online == 1 ? "上线": "设置繁忙") +"吗！",
     onConfirm: (){
       updateUserOnlineStatus(online: online);
    });
  }

  /// 是否加载聊天记录完毕
  bool isLoadRecordEnd = false;

  /// 是否在加载更多聊天记录
  bool isLoadingMorRecord = false;

  /// 设置是否在加载中状态
  void setIsLoadingMorRecord(bool isLoading){
    isLoadingMorRecord = isLoading;
    notifyListeners();
  }

  /// 获取服务器消息列表
  Future<void> getMessageRecord({int timestamp, int pageSize = 20, int accountId, bool isFirstLoad = false, int serviceId}) async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      int timer = timestamp ?? 0;
      int _accountId = accountId ?? currentContact.fromAccount;
      if(isFirstLoad){
         isLoadRecordEnd = false;
         isGetHistoryMessage = false;
         notifyListeners();
      }
      if(isFirstLoad && currentUserMessagesRecords(accountId).length <= 0){
        isChatFullLoading = true;
        notifyListeners();
      }
      if(currentUserMessagesRecords(accountId).length > 0 && !isFirstLoad){
        timer = currentUserMessagesRecords(accountId)[0].timestamp;
      }
      Response response = await messageService.getMessageRecord(timestamp: timer, pageSize: pageSize, account: _accountId, service: serviceId ?? serviceUser.id, isHistory: isGetHistoryMessage);
      isChatFullLoading = false;
      if (response.data["code"] == 200) {
        List<ImMessageModel>  messages = (response.data['data']['list'] as List).map((i) => _handlerMessage(ImMessageModel.fromJson(i))).toList();
        for (var i = 0; i < messages.length; i++) {
          messages[i].payload = utf8.decode(base64Decode(messages[i].payload));
        }
        if(isFirstLoad){
          messagesRecords[_accountId] = messages;
        }else{
          messagesRecords[_accountId].insertAll(0, messages);
        }
        if((response.data['data']['list'] as List).length < pageSize && isGetHistoryMessage){
          isLoadRecordEnd = true;
        }
        if((response.data['data']['list'] as List).length < pageSize){
          isGetHistoryMessage = true;
        }
      } else {
        UX.showToast("${response.data["message"]}");
      }
      notifyListeners();
    } catch (e) {
      debugPrint(e);
    }
  }

  /// 上报IM最后活动时间
  Future<void> _upImLastActivity() async {
    Timer.periodic(Duration(milliseconds: 20000), (_timer) {
      printf("上报IM最后活动时间");
      if (serviceUser != null) publicService.upImLastActivity();
    });
  }

  /// 获取上传文件配置
  Future<void> getConfigs() async {
    Response response = await publicService.getConfigs();
    if (response.data["code"] == 200) {
      imConfigs = ImConfigs.fromJson(response.data["data"]);
    } else {
      await Future.delayed(Duration(milliseconds: 1000));
      getConfigs();
    }
  }

  /// 创建消息
  /// [toAccount] 接收方账号
  /// [msgType]   消息类型
  /// [content]   消息内容
  MessageHandle createMessage(
      {int toAccount, String msgType, dynamic content}) {
    MIMCMessage message = MIMCMessage();
    String millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch.toString();
    int timestamp = int.parse(millisecondsSinceEpoch.substring(0, millisecondsSinceEpoch.length - 3));
    message.timestamp = timestamp;
    message.bizType = msgType;
    message.toAccount = toAccount.toString();
    message.fromAccount = serviceUser.id.toString();
    Map<String, dynamic> payloadMap = {
      "from_account": serviceUser.id,
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
        localMessage: ImMessageModel.fromJson(payloadMap)..isShowCancel = true);
  }

  /// 发送消息处理
  void sendMessage(MessageHandle msgHandle) async {
    //  发送失败提示
    if (!await flutterMImc.isOnline()) {
      MessageHandle tipsMsg = createMessage(toAccount: toAccount, msgType: "system", content: "您的网络异常，发送失败了~");
      pushLocalMessage(tipsMsg.localMessage, toAccount);
      return;
    }
    Timer.periodic(Duration(milliseconds: 150), (timer){
      flutterMImc.sendMessage(msgHandle.sendMessage);
      timer.cancel();
    });

    /// 消息入库（远程）
    MessageHandle cloneMsgHandle = msgHandle.clone();
    String type = cloneMsgHandle.localMessage.bizType;
    if (type == "contacts" ||
        type == "pong" ||
        type == "welcome" ||
        type == "handshake") return;
    cloneMsgHandle.sendMessage.toAccount = robot.id.toString();
    cloneMsgHandle.sendMessage.payload = ImMessageModel(
      bizType: "into",
      payload: cloneMsgHandle.localMessage.toBase64(),
    ).toBase64();
    flutterMImc.sendMessage(cloneMsgHandle.sendMessage);
    if (type != "photo") pushLocalMessage(cloneMsgHandle.localMessage, cloneMsgHandle.localMessage.toAccount);
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 10000));
    cloneMsgHandle.localMessage.isShowCancel = false;
    notifyListeners();
  }

  // 更新某个消息
  void updateMessage(ImMessageModel msg) {
    int index = currentUserMessagesRecords(toAccount).indexWhere((i) => i.key == msg.key);
    currentUserMessagesRecords(toAccount)[index] = msg;
    notifyListeners();
  }

  /// 获取平台数据
  Future<void> getPlatforms() async{
    Response response = await platformService.getPlatforms();
    if(response.statusCode == 200){
      platforms = (response.data['data'] as List).map((i)=>PlatformModel.fromJson(i)).toList();
    }else{
      UX.showToast(response.data["message"]);
    }
    notifyListeners();
  }

  /// 获取工单统计
  Future<void> getWorkOrderCounts() async{
    Response response = await WorkOrderService.getInstance().getWorkOrderCounts();
    if(response.statusCode == 200){
      workOrderCounts = WorkOrderCountsModel.fromJson(response.data['data']);
    }else{
      UX.showToast(response.data["message"]);
    }
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 5000));
    getWorkOrderCounts();
  }

  // 获取工单类型数据
  Future<void> getWorkorderTypes() async {
    if(workOrderCounts == null){
      await getWorkOrderCounts();
    }
    Response response = await WorkOrderService.getInstance().getWorkorderTypes();
    if (response.data["code"] == 200) {
      int _total = 0;
      var _workOrderTypes = (response.data["data"] as List).map((i) => WorkOrderTypeModel.fromJson(i)).toList();
      for(var i=0; i<_workOrderTypes.length; i++){
        _total += _workOrderTypes[i].count;
      }
      workOrderTypes = [];
      workOrderTypes.add(WorkOrderTypeModel(id: 0, title: "全部工单", count: _total));
      workOrderTypes.addAll(_workOrderTypes);
      workOrderTypes.add(WorkOrderTypeModel(id: -1, title: "已结单", count: workOrderCounts.status3));
      workOrderTypes.add(WorkOrderTypeModel(id: -2, title: "回收站", count: workOrderCounts.deleteCount));
      notifyListeners();
    } else {
      UX.showToast("${response.data["message"]}");
    }
  }



  /// 根据平台ID获取平台标题
  String getPlatformTitle(int id){
    PlatformModel platform = platforms.singleWhere((p) => p.id == id);
    if(platform != null){
      return platform.title;
    }
    return "未知平台";
  }
  /// 根据平台标题获取平台ID
  int getPlatformId(String title){
    PlatformModel platform = platforms.singleWhere((p) => p.title == title);
    if(platform != null){
      return platform.id;
    }
    return 1;
  }

  /// 获取工作台聊天列表
  bool isContactShowLoading = false;
  Future<void> getContacts({bool isFullLoading = false}) async{
    if(isFullLoading && contacts.length <= 0){
      isContactShowLoading = true;
      notifyListeners();
    }
    Response response = await contactService.getContacts();
    isContactShowLoading = false;
    if(response.statusCode == 200){
      contacts = (response.data['data'] as List).map((i){
        ContactModel contact = ContactModel.fromJson(i);
        if(currentContact != null && contact.fromAccount == currentContact.fromAccount){
          currentContact = contact;
        }
        return ContactModel.fromJson(i);
      }).toList();
    }else{
      UX.showToast(response.data["message"]);
    }
    notifyListeners();
  }

  /// 移除的单个聊天列表
  void removeSingleContact(int cid){
    contactService.removeSingle(cid);
    contacts.removeWhere((c) => c.cid == cid);
  }

  /// 撤回消息
  void sendCancelMessage(ImMessageModel msg) {
    GlobalProvide globalState = GlobalProvide.getInstance();
    MessageHandle msgHandle = createMessage(toAccount: toAccount, msgType: "cancel", content: msg.key);
    globalState.messageService.removeMeessge(
      toAccount: toAccount,
      fromAccount: serviceUser.id,
      key: msg.key,
    );
    sendMessage(msgHandle);
  }

  /// 结束会话
  void sendEndMessage() {
    if(currentContact == null || toAccount == null) return;
    MessageHandle msgHandle = createMessage(toAccount: toAccount, msgType: "end", content: "");
    sendMessage(msgHandle);
    currentContact.isSessionEnd = 1;
    notifyListeners();
  }

  /// 删除本地消息
  void deleteMessage(int account, int key){
    try{
      int index = messagesRecords[account].indexWhere((i) => i.key == key);
      messagesRecords[account].removeAt(index);
      notifyListeners();
    }catch(e){
      printf(e);
    }
  }

  // 处理头像昵称
  ImMessageModel _handlerMessage(ImMessageModel msg) {
    const String defaultAvatar = 'http://qiniu.cmp520.com/avatar_degault_3.png';
    msg.avatar = defaultAvatar;
    if (msg.fromAccount != serviceUser.id && msg.fromAccount != robot.id && msg.fromAccount > 5000) {
      /// 这里如果是接入业务平台可替换成用户头像和昵称
      /// if (uid == myUid)  msg.avatar = MyAvatar
      /// if (uid == myUid)  msg.nickname = MyNickname
      msg.nickname = msg.nickname ?? "访客${msg.fromAccount}";
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
          AdminModel _localServiceUser =
              AdminModel.fromJson(json.decode(_localServiceUserStr));
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
            RobotModel _localRobot = RobotModel.fromJson(json.decode(_localRobotStr));
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
  Future<void> _addMimcEvent() async {
    _subStatus?.cancel();
    _subHandleMessage?.cancel();
    try {
      /// 状态发生改变
      _subStatus = flutterMImc
          ?.addEventListenerStatusChanged()
          ?.listen((bool login) async {
        debugPrint("状态发生改变===$login");
      });

      /// 消息监听
      _subHandleMessage = flutterMImc
          ?.addEventListenerHandleMessage()
          ?.listen((MIMCMessage msg) async {
        ImMessageModel message = ImMessageModel.fromJson(
            json.decode(utf8.decode(base64Decode(msg.payload))));
        if(message.fromAccount == serviceUser.id && message.bizType == "pong") return;
        if(message.bizType == "into") return;
        if(message.fromAccount == serviceUser.id){
          pushLocalMessage(message, message.toAccount);
          if(message.bizType == "cancel"){
            message.key = int.parse(message.payload);
            deleteMessage(message.toAccount, message.key);
          }
          return;
        }
        switch (message.bizType) {
          case "transfer":
              getContacts();
            break;
          case "contacts":
            contacts = (json.decode(message.payload) as List).map((i){
              ContactModel contact = ContactModel.fromJson(i);
              if(currentContact != null && contact.fromAccount == currentContact.fromAccount){
                currentContact = contact;
              }
              return ContactModel.fromJson(i);
            }).toList();
            break;
          case "text":
          case "photo":
            if(!(currentContact != null && message.fromAccount != currentContact.fromAccount)){
              advanceText = "";
              notifyListeners();
            }
            break;
          case "end":
          case "timeout":
            getContacts();
            if(currentContact != null && message.fromAccount != currentContact.fromAccount) return;
             advanceText = "";
            break;
          case "pong":
            if(currentContact != null && message.fromAccount != currentContact.fromAccount) return;
            advanceText = message.payload;
            notifyListeners();
            if (!isPong){
              isPong = true;
              notifyListeners();
              await Future.delayed(Duration(milliseconds: 1500));
              isPong = false;
              notifyListeners();
            }
            break;
          case "cancel":
            message.key = int.parse(message.payload);
            deleteMessage(message.fromAccount, message.key);
            break;
        }
        pushLocalMessage(message, message.fromAccount);
        notifyListeners();
        /// 通知
        if(currentRoutePath == "chat" && toAccount == message.fromAccount) return;
        if(appLifecycleState == AppLifecycleState.paused || currentRoutePath != "home"){
          if(!["text", "photo", "handshake"].contains(message.bizType)) return;
          ImMessageModel newMsg = _handlerMessage(message);
          String payload = message.payload;
          String title = "${newMsg.nickname}发来消息";
          if(message.bizType == "photo"){
            payload = "图片文件";
          }
          if(message.bizType == "handshake"){
            title = "系统消息";
            payload = "${newMsg.nickname}接入人工...";
          }
          LocalNotifications.getInstance().showNotifications(title: "$title", body: "$payload", channelId: "${newMsg.fromAccount}");
        }
      });
    } catch (e) {
      debugPrint(e);
    }
  }

  /// 处理接收消息
  void pushLocalMessage(ImMessageModel message, int account, {bool isInsert = false}){
    if(message.bizType == 'pong' || message.bizType == "handshake" ||  message.bizType == "contacts"){
      return;
    }
    ImMessageModel newMsg = _handlerMessage(message);
    List<ImMessageModel> messages = messagesRecords[account] ?? [];
    if(isInsert){
      messages.insert(0, newMsg);
    }else{
      messages.add(newMsg);
    }
    messagesRecords[account] = messages;
    notifyListeners();
  }


  /// 发送文本消息
  void sendTextMessage(String text){
    MessageHandle msgHandle = createMessage(toAccount: toAccount, msgType: "text", content: text);
    sendMessage(msgHandle);
  }

  /// 上传文件
  Future<String> uploadFile(File file,{
    Function(int, int) onSendProgress,
    VoidCallback fail
  }) async{
    String filePath = file.path;
      String fileName = "${DateTime.now().microsecondsSinceEpoch}_" +
          (filePath.lastIndexOf('/') > -1
              ? filePath.substring(filePath.lastIndexOf('/') + 1)
              : filePath);

      FormData formData = new FormData.fromMap({
        "fileType": "image",
        "fileName": "file",
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

      Response response = await PublicService.instance.http.post(uploadUrl, data: formData, onSendProgress: onSendProgress);
      if (response.statusCode == 200) {
        switch (imConfigs.uploadMode) {
          case 1:
            return imConfigs.uploadHost + "/" + response.data["data"];
            break;
          case 2:
            return imConfigs.uploadHost + "/" + response.data["key"];
            break;
          default:
          return null;
        }
      } else {
        if(fail != null) fail();
       return null;
      }

  }

  /// 发送图片
  void sendPhotoMessage(File file) async {
    MessageHandle msgHandle;
    try {
      if (file == null) return;
      msgHandle = createMessage(toAccount: toAccount, msgType: "photo", content: file.path);
      pushLocalMessage(msgHandle.localMessage, toAccount);
      notifyListeners();

      String imgUrl = await uploadFile(file, onSendProgress:(int sent, int total) {
        msgHandle.localMessage.uploadProgress = (sent / total * 100).ceil();
        notifyListeners();
      });

      /// 上传失败
      if(imgUrl == null){
        deleteMessage(msgHandle.localMessage.toAccount, msgHandle.localMessage.key);
        MessageHandle systemMsgHandle = createMessage(
            toAccount: toAccount, msgType: "system", content: "图片上传失败~");
            pushLocalMessage(systemMsgHandle.localMessage, toAccount);
        return;
      }

      /// 上传成功
      msgHandle.localMessage.isShowCancel = true;
      msgHandle.localMessage.payload = imgUrl;
      notifyListeners();
      ImMessageModel sendMsg = ImMessageModel.fromJson(json
          .decode(utf8.decode(base64Decode(msgHandle.sendMessage.payload))));
      sendMsg.payload = imgUrl;
      msgHandle.sendMessage.payload =
          base64Encode(utf8.encode(json.encode(sendMsg.toJson())));
      sendMessage(msgHandle.clone()..localMessage.payload = imgUrl);
      await Future.delayed(Duration(milliseconds: 10000));
      msgHandle.localMessage.isShowCancel = false;
      notifyListeners();


    } catch (e) {
      deleteMessage(msgHandle.localMessage.toAccount, msgHandle.localMessage.key);
      MessageHandle systemMsgHandle = createMessage(
          toAccount: toAccount, msgType: "system", content: "图片上传失败~");
     pushLocalMessage(systemMsgHandle.localMessage, toAccount);
    }
  }

  // 消息内容变,ping, pong
  bool isSendPong = false;
  void sendPongMessage(String value) async {
    if (isSendPong) return;
    if(currentContact == null) return;
    isSendPong = true;
    MessageHandle _msgHandle = createMessage(toAccount: toAccount, msgType: "pong", content: value);
    sendMessage(_msgHandle);
    await Future.delayed(Duration(milliseconds: 200));
    isSendPong = false;
    notifyListeners();
  }


  @override
  void dispose() {
    printf("GlobalProvide被销毁了");
    _subStatus?.cancel();
    _subHandleMessage?.cancel();
    super.dispose();
  }
}