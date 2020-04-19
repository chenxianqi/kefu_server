import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
class EditPasswordPage extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  EditPasswordPage({this.arguments});
  @override
  EditPasswordPageState createState() => EditPasswordPageState();
}
class EditPasswordPageState extends State<EditPasswordPage> {
  AdminModel serviceUser = GlobalProvide.getInstance().serviceUser;

  TextEditingController oldPasswordCtr;
  TextEditingController newPasswordCtr;
  TextEditingController enterPasswordCtr;

  /// save
  void _save() async{
    String oldPassword = oldPasswordCtr.value.text.trim();
    String newPassword = newPasswordCtr.value.text.trim();
    String enterPassword = enterPasswordCtr.value.text.trim();
    /// 判断
    if(oldPassword.isEmpty || oldPassword == ""){
      UX.showToast("旧密码不能为空");
      return;
    }
    if(newPassword.isEmpty || newPassword == ""){
      UX.showToast("新密码不能为空");
      return;
    }
    if(enterPassword.isEmpty || enterPassword == ""){
      UX.showToast("请再次输入新密码");
      return;
    }
    if(enterPassword != newPassword){
      UX.showToast("两次密码不一致");
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    UX.showLoading(context, content: "保存中...");
    Response response = await AdminService.getInstance().updatePassword({
      "old_password": oldPassword,
      "new_password": newPassword,
      "enter_password": enterPassword
    });
    UX.hideLoading(context);
    if(response.statusCode == 200){
      UX.showToast("密码修改成功");
      Navigator.pop(context);
      GlobalProvide.getInstance().getMe();
    }else{
      UX.showToast(response.data["message"]);
    }
  }
  
  @override
  void initState() {
    super.initState();
    if(mounted && serviceUser!= null){
      oldPasswordCtr = TextEditingController();
      newPasswordCtr = TextEditingController();
      enterPasswordCtr = TextEditingController();
    }
  }

  @override
  void dispose() {
    oldPasswordCtr?.dispose();
    newPasswordCtr?.dispose();
    enterPasswordCtr?.dispose();
    super.dispose();
  }

  @override
  Widget build(_) {
    return PageContext(builder: (context){
      ThemeData themeData = Theme.of(context);

      Widget _fromInput({
        String label,
        TextEditingController controller,
        String placeholder,
        bool enabled = true,
        bool obscureText = false,
        bool autofocus = false,
      }){
        return Container(
          height: ToPx.size(90),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: themeData.dividerColor,width: ToPx.size(2)))
          ),
          padding: EdgeInsets.symmetric(horizontal: ToPx.size(40)),
          child: Row(
          children: <Widget>[
              Text("$label", style: themeData.textTheme.title,),
              Expanded(
                child: Input(
                enabled: enabled,
                obscureText: obscureText,
                border: Border.all(style: BorderStyle.none, color: Colors.transparent),
                padding: EdgeInsets.symmetric(horizontal: ToPx.size(10)),
                placeholder: "$placeholder",
                showClear: true,
                autofocus: autofocus,
                controller: controller,
              ),
              )
            ],
          ),
        );
      }
      return Scaffold(
        appBar: customAppBar(
          title: Text(
            "修改密码",
            style: themeData.textTheme.display1,
          )),
        body: ListView(
          children: <Widget>[
              SizedBox(
                height: ToPx.size(40),
              ),

              
              _fromInput(
                label: "旧密码：",
                placeholder: "请输入旧密码",
                controller: oldPasswordCtr,
                autofocus: true
              ),
              _fromInput(
                label: "新密码：",
                placeholder: "请输入新密码",
                obscureText: true,
                controller: newPasswordCtr
              ),
              _fromInput(
                label: "确认密码：",
                obscureText: true,
                placeholder: "请再次输入新密码",
                controller: enterPasswordCtr
              ),

              Button(
                margin: EdgeInsets.symmetric(horizontal: ToPx.size(40), vertical: ToPx.size(80)),
                onPressed: _save,
                 withAlpha: 200,
                child: Text("保存"),
              )

          ],
        )
      );
    });
  }
}
