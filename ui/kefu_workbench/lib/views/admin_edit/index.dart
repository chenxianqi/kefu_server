import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
class AdminEditPage extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  AdminEditPage({this.arguments});
  @override
  _AdminEditPagePageState createState() => _AdminEditPagePageState();
}
class _AdminEditPagePageState extends State<AdminEditPage> {
  AdminModel admin;
  String avatar = "";
  bool isEdit = false;
  TextEditingController nicknameCtr;
  TextEditingController usernameCtr;
  TextEditingController phoneCtr;
  TextEditingController autoReplyCtr;
  TextEditingController passwordCtr;
  TextEditingController passwordYesCtr;

  /// 选择图片上传
  void _pickerImage() async{
    String imgUser = await uploadImage<String>(context, maxWidth: 300.0);
    if(imgUser == null) return;
    avatar = imgUser;
    setState(() {});
  }


  /// save
  void _saveAdmin() async{
    String nickname = nicknameCtr.value.text.trim();
    String username =  usernameCtr.value.text.trim();
    AdminModel user = AdminModel(
      nickname: nickname,
      phone: phoneCtr.value.text.trim(),
      autoReply: autoReplyCtr.value.text.trim(),
      id: admin?.id ?? null,
      avatar: avatar,
      password: null,
      username: username
    );
    Map useMap = user.toJson();
    /// 判断昵称不能为空
    if(nickname.isEmpty || nickname == ""){
      UX.showToast("昵称不能为空");
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    UX.showLoading(context, content: "保存中...");
    Response response;
    if(isEdit){
      useMap.removeWhere((key, value) => value == null);
      response = await AdminService.getInstance().saveAdminInfo(useMap);
    }else{
       String password = passwordCtr.value.text.trim();
       String passwordYes =  passwordCtr.value.text.trim();
       if(password.isEmpty || password == ""){
          UX.showToast("请输入密码");
          return;
        }
        if(passwordYes.isEmpty || passwordYes == ""){
          UX.showToast("请再次输入密码");
          return;
        }
        if(passwordYes != password){
          UX.showToast("两次密码不一致");
          return;
        }
      useMap["password"] = password;
      useMap.removeWhere((key, value) => value == null);
      printf("useMapuseMapuseMap===$useMap");
      response = await AdminService.getInstance().add(useMap);
    }
    UX.hideLoading(context);
    if(response.statusCode == 200){
      UX.showToast("保存成功");
      Navigator.pop(context, true);
      GlobalProvide.getInstance().getMe();
    }else{
      UX.showToast(response.data["message"]);
    }
  }
  
  @override
  void initState() {
    super.initState();
    if(mounted && widget.arguments != null){
      isEdit = true;
      admin = (widget.arguments['admin'] as AdminModel);
      usernameCtr = TextEditingController(text: admin.username);
      nicknameCtr = TextEditingController(text: admin.nickname);
      phoneCtr = TextEditingController(text: admin.phone);
      autoReplyCtr = TextEditingController(text: admin.autoReply);
      avatar = admin.avatar;
    }else{
      nicknameCtr = TextEditingController();
      usernameCtr = TextEditingController();
      phoneCtr = TextEditingController();
      autoReplyCtr = TextEditingController();
      passwordCtr = TextEditingController();
      passwordYesCtr = TextEditingController();
    }
  }

  @override
  void dispose() {
    nicknameCtr?.dispose();
    autoReplyCtr?.dispose();
    usernameCtr?.dispose();
    passwordCtr?.dispose();
    phoneCtr?.dispose();
    passwordYesCtr?.dispose();
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
                autofocus: autofocus,
                border: Border.all(style: BorderStyle.none, color: Colors.transparent),
                padding: EdgeInsets.symmetric(horizontal: ToPx.size(10)),
                placeholder: "$placeholder",
                showClear: true,
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
            isEdit ? "编辑客服" : "添加客服",
            style: themeData.textTheme.display1,
          )),
        body: ListView(
          children: <Widget>[
              SizedBox(
                height: ToPx.size(40),
              ),


              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: ToPx.size(30)),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Avatar(
                          size: ToPx.size(150),
                          imgUrl: avatar.isEmpty ? "http://qiniu.cmp520.com/avatar_default.png" : avatar,
                          onPressed: _pickerImage
                        )
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: ToPx.size(120), left: ToPx.size(80)),
                        child: Icon(Icons.camera_alt, color:themeData.primaryColor.withAlpha(150), size: ToPx.size(35),),
                      )
                    )
                  ],
                ),
              ),
              
              _fromInput(
                label: "客服账号：",
                placeholder: "请输入客服账号",
                autofocus: !isEdit,
                enabled: !isEdit,
                controller: usernameCtr
              ),
              _fromInput(
                label: "客服昵称：",
                placeholder: "请输入昵称",
                autofocus: isEdit,
                controller: nicknameCtr
              ),
              Offstage(
                offstage: isEdit,
                child: _fromInput(
                label: "登录密码：",
                placeholder: "请输入密码",
                autofocus: true,
                controller: passwordCtr
              )),
              Offstage(
                offstage: isEdit,
                child: _fromInput(
                label: "确认密码：",
                placeholder: "请再次输入确认密码",
                autofocus: true,
                controller: passwordYesCtr
              )),
              Offstage(
                offstage: !isEdit,
                child: _fromInput(
                label: "联系方式：",
                placeholder: "请输入联系方式",
                controller: phoneCtr
              )),
              Offstage(
                offstage: !isEdit,
                child: Container(
                height: ToPx.size(250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: themeData.dividerColor,width: ToPx.size(2)))
                ),
                padding: EdgeInsets.symmetric(horizontal: ToPx.size(40), vertical: ToPx.size(10)),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Text("自动回复语：", style: themeData.textTheme.title,),
                    Expanded(
                      child: Input(
                      border: Border.all(style: BorderStyle.none, color: Colors.transparent),
                      placeholder: "请输入自动回复语",
                      controller: autoReplyCtr,
                      textAlign: TextAlign.start,
                      minLines: 5,
                      maxLength: 100,
                      placeholderAlignment: Alignment.topLeft,
                      textInputAction: TextInputAction.newline,
                      maxLines: 5,
                    ),
                    )
                  ],
                ),
              ),),

              Button(
                margin: EdgeInsets.symmetric(horizontal: ToPx.size(40), vertical: ToPx.size(80)),
                onPressed: _saveAdmin,
                 withAlpha: 200,
                child: Text("保存"),
              )

          ],
        )
      );
    });
  }
}
