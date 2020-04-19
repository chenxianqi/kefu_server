import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kefu_workbench/provider/global.dart';

import '../core_flutter.dart';

class LoginProvide with ChangeNotifier {
  AuthService authService = AuthService.getInstance();
  TextEditingController accountCtr;
  TextEditingController hostCtr;
  TextEditingController passwordCtr;

  bool isSavePassword = false;

  void setIsSavePassword(bool isSave) {
    isSavePassword = isSave;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    String host = hostCtr.value.text.trim();
    String account = accountCtr.value.text.trim();
    String password = passwordCtr.value.text.trim();
    GlobalProvide.getInstance().prefs.setString("host", host);
    GlobalProvide.getInstance().prefs.setString("account", account);
    if (isSavePassword) {
      GlobalProvide.getInstance().prefs.setString("password", password);
    } else {
      GlobalProvide.getInstance().prefs.remove("password");
    }
    if(account.isEmpty || account == ""){
      UX.showToast("请输入服务器地址~");
      return;
    }
    if(account.isEmpty || account == ""){
      UX.showToast("请输入用户名~");
      return;
    }
    if(password.isEmpty || password == ""){
      UX.showToast("请输入密码~");
       return;
    }
    UX.showLoading(context, content: "登录中...");
    Response response = await authService.login(username: account, password: password);
    UX.hideLoading(context);
    if(response.statusCode == 200){
      AdminModel user = AdminModel.fromJson(response.data['data']);
      GlobalProvide.getInstance().setServiceUser(user);
      GlobalProvide.getInstance().prefs.setString("serviceUser", json.encode(response.data['data']));
      GlobalProvide.getInstance().prefs.setString("Authorization", user.token);
      UX.showToast("登录成功~");
      GlobalProvide.getInstance().init();
      Navigator.pushNamedAndRemoveUntil(context, "/home", ModalRoute.withName('/'), arguments: {"isAnimate": false});
    }else{
      UX.showToast(response.data["message"], position: ToastPosition.top);
    }
  }

  @override
  void dispose() {
    accountCtr?.dispose();
    passwordCtr?.dispose();
    super.dispose();
  }
}
