import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/provider/robot.dart';
class RobotEditPage extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  RobotEditPage({this.arguments});
  @override
  _RobotEditPageState createState() => _RobotEditPageState(
    robot: arguments != null ? arguments['robot'] : null
  );
}

class _RobotEditPageState extends State<RobotEditPage> {
  final RobotModel robot;
  bool isEdit = false;
  TextEditingController nicknameCtr;
  TextEditingController welcomeCtr;
  TextEditingController understandCtr;
  TextEditingController timeoutTextCtr;
  TextEditingController noServicesCtr;
  TextEditingController loogTimeWaitTextCtr;
  TextEditingController keywordCtr;
  TextEditingController artificialCtr;
  _RobotEditPageState({this.robot});
  List<PlatformModel> platforms = GlobalProvide.getInstance().platforms;
  String selectPlatform = "全平台";
  String avatar = "";
  bool isSwitch = true;

  @override
  void initState() {
    super.initState();
    if(mounted){
      if(robot != null){
        isEdit = true;
        nicknameCtr = TextEditingController(text: robot.nickname);
        welcomeCtr = TextEditingController(text: robot.welcome);
        understandCtr = TextEditingController(text: robot.understand);
        timeoutTextCtr = TextEditingController(text: robot.timeoutText);
        noServicesCtr = TextEditingController(text: robot.noServices);
        loogTimeWaitTextCtr = TextEditingController(text: robot.loogTimeWaitText);
        keywordCtr = TextEditingController(text: robot.keyword.replaceAll("|", "\n"));
        artificialCtr = TextEditingController(text: robot.artificial.replaceAll("|", "\n"));
        selectPlatform = GlobalProvide.getInstance().getPlatformTitle(robot.platform);
        isSwitch = robot.isRun == 1;
        avatar = robot.avatar;
      }else{
        nicknameCtr = TextEditingController();
        welcomeCtr = TextEditingController();
        understandCtr = TextEditingController();
        noServicesCtr = TextEditingController();
        timeoutTextCtr = TextEditingController();
        loogTimeWaitTextCtr = TextEditingController();
        keywordCtr = TextEditingController();
        artificialCtr = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    nicknameCtr?.dispose();
    welcomeCtr?.dispose();
    understandCtr?.dispose();
    noServicesCtr?.dispose();
    timeoutTextCtr?.dispose();
    loogTimeWaitTextCtr?.dispose();
    keywordCtr?.dispose();
    artificialCtr?.dispose();
    super.dispose();
  }


  /// 选择图片上传
  void _pickerImage() async{
    String imgUser = await uploadImage<String>(context, maxWidth: 300.0);
    if(imgUser == null) return;
    avatar = imgUser;
    setState(() {});
  }

  /// 保存
  void _save(BuildContext context) async{
    String nickname = nicknameCtr.value.text.trim();
    String welcome = welcomeCtr.value.text.trim();
    String understand = understandCtr.value.text.trim();
    String noServices = noServicesCtr.value.text.trim();
    String timeoutText = timeoutTextCtr.value.text.trim();
    String loogTimeWaitText = loogTimeWaitTextCtr.value.text.trim();
    String keyword = keywordCtr.value.text.trim();
    String artificial = artificialCtr.value.text.trim();

    FocusScope.of(context).requestFocus(FocusNode());
    UX.showLoading(context, content: "保存中...");
    GlobalProvide globalProvide = GlobalProvide.getInstance();
    Map data = {
      "id": robot != null ? robot.id : null,
      "nickname": nickname,
      "avatar": avatar,
      "welcome": welcome,
      "understand": understand,
      "artificial": artificial.replaceAll("\n", "|"),
      "keyword": keyword.replaceAll("\n", "|"),
      "timeout_text": timeoutText,
      "no_services": noServices,
      "loog_time_wait_text": loogTimeWaitText,
      "platform": globalProvide.getPlatformId(selectPlatform),
      "switch": isSwitch ? 1 : 0
    };
    Response response;
    if(isEdit){
       response = await RobotService.getInstance().update(data: data);
    }else{
       response = await RobotService.getInstance().add(data: data);
    }
    UX.hideLoading(context);
    if(response.statusCode == 200){
      UX.showToast("保存成功");
      if(isEdit){
       await RobotProvide.getInstance().getRobot(robot.id);
      }
      Navigator.pop(context, true);
    }else{
      UX.showToast(response.data["message"]);
    }
  }

  @override
  Widget build(_) {
    return PageContext(builder: (context){
      ThemeData themeData = Theme.of(context);

      Widget _tip(String content,{Color color}){
        return Padding(
            padding: EdgeInsets.symmetric(vertical: ToPx.size(8)),
            child: Text("                  $content", style: themeData.textTheme.caption.copyWith(
              color: color == null ? themeData.disabledColor : color
            ),),
          );
      }

      Widget _lineItem({
        String label,
        String placeholder,
        TextStyle style,
        int minLines = 1,
        int maxLines = 1,
        bool autofocus = false,
        CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
        TextEditingController controller,
        Widget subChild = const SizedBox()
      }){
        return Container(
            padding: EdgeInsets.symmetric(horizontal: ToPx.size(20),vertical: ToPx.size(10)),
            child: DefaultTextStyle(
              style: style,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Row(
                  crossAxisAlignment: crossAxisAlignment,
                  children: <Widget>[
                    Text("$label"),
                    Expanded(
                      child: Input(
                        minLines: minLines,
                        maxLines: maxLines,
                        autofocus: autofocus,
                        bgColor: Colors.black.withAlpha(8),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        padding: EdgeInsets.symmetric(horizontal: ToPx.size(10)),
                        border: Border.all(style: BorderStyle.none, color: Colors.transparent),
                        height: ToPx.size(90),
                        contentPadding: EdgeInsets.symmetric(vertical: ToPx.size(15)),
                        textInputAction: maxLines > 1 ? TextInputAction.newline : null,
                        placeholder: placeholder,
                        controller: controller,
                      )
                    ),
                  ],
                ),
                subChild,
                Divider(height: ToPx.size(30),),
              ],)
            )
          );
      }
      return Scaffold(
        backgroundColor: themeData.primaryColorLight,
        appBar: customAppBar(
            title: Text(
              "${isEdit ? "编辑机器人" : "添加机器人"}",
              style: themeData.textTheme.display1,
            ),
          ),
        body: ListView(
          children: <Widget>[
              SizedBox(height: ToPx.size(20),),
              Container(
                width: double.infinity,
                color: Colors.white,
                height: ToPx.size(250),
                padding: EdgeInsets.symmetric(vertical: ToPx.size(30)),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Avatar(
                          size: ToPx.size(150),
                          imgUrl: avatar.isNotEmpty ? avatar : "http://qiniu.cmp520.com/avatar_default.png",
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
              _lineItem(
                label: "    昵称：",
                placeholder: "请输入机器人昵称",
                style: themeData.textTheme.title,
                controller: nicknameCtr,
                autofocus: true
              ),
              _lineItem(
                minLines: 1,
                maxLines: 10,
                label: "欢迎语：",
                placeholder: "请输入机器人欢迎语",
                style: themeData.textTheme.title,
                controller: welcomeCtr,
                crossAxisAlignment: CrossAxisAlignment.start,
                subChild: _tip("机器人自动回复的欢迎语句")
              ),
              _lineItem(
                minLines: 1,
                maxLines: 10,
                label: "无匹配：",
                placeholder: "请输入无匹配知识库语",
                style: themeData.textTheme.title,
                controller: understandCtr,
                crossAxisAlignment: CrossAxisAlignment.start,
                subChild: _tip("机器人无法匹配知识库，回复该语句")
              ),
              _lineItem(
                minLines: 1,
                maxLines: 10,
                label: "超时语：",
                placeholder: "请输入超时结束提示",
                style: themeData.textTheme.title,
                controller: timeoutTextCtr,
                crossAxisAlignment: CrossAxisAlignment.start,
                subChild: _tip("用户超时结束后，回复语")
              ),
              _lineItem(
                minLines: 1,
                maxLines: 10,
                label: "无人工：",
                placeholder: "请输入无人工在线提示(每行一个)",
                style: themeData.textTheme.title,
                controller: noServicesCtr,
                crossAxisAlignment: CrossAxisAlignment.start,
                subChild: _tip("无客服在线提示")
              ),
              _lineItem(
                minLines: 1,
                maxLines: 10,
                label: "时间长：",
                placeholder: "请输入长时间等待提示",
                style: themeData.textTheme.title,
                controller: loogTimeWaitTextCtr,
                crossAxisAlignment: CrossAxisAlignment.start,
                subChild: _tip("客服超过一定的时间没有回复用户提示语")
              ),
              _lineItem(
                minLines: 1,
                maxLines: 10,
                label: "检索词：",
                placeholder: "请输入检索知识库热词(每行一个)",
                style: themeData.textTheme.title,
                controller: keywordCtr,
                crossAxisAlignment: CrossAxisAlignment.start,
                subChild: _tip("检索知识库词库，多个请换行处理", color: Colors.amber)
              ),
              _lineItem(
                minLines: 1,
                maxLines: 10,
                label: "转人工：",
                placeholder: "请输入转人工关键词(每行一个)",
                style: themeData.textTheme.title,
                controller: artificialCtr,
                crossAxisAlignment: CrossAxisAlignment.start,
                subChild: _tip("接入人工关键词，多个请换行处理", color: Colors.amber)
              ),
              Offstage(
                offstage: isEdit && robot.system == 1,
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ToPx.size(30)),
                    child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: '所属平台',
                    hintText: '请选择所属平台',
                    labelStyle: themeData.textTheme.title.copyWith(
                      color: themeData.primaryColor,
                      fontSize: ToPx.size(38)
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  child: DropdownButton<String>(
                    value: selectPlatform,
                    onChanged: (String newValue) {
                      setState(() {
                        selectPlatform = newValue;
                      });
                    },
                    items: platforms.map<DropdownMenuItem<String>>((PlatformModel platform) {
                      return DropdownMenuItem<String>(
                        value: platform.title,
                        child: Text(platform.title, style: themeData.textTheme.title,),
                      );
                    }).toList(),
                  ),
                ),
                  )
                )
              ),
              Offstage(
                offstage: isEdit && robot.system == 1,
                child: Container(
                 padding: EdgeInsets.symmetric(horizontal: ToPx.size(20),vertical: ToPx.size(10)),
                child: Row(
                  children: <Widget>[
                    Text("运行状态：", style: themeData.textTheme.title,),
                    Platform.isAndroid ?
                        Switch(value: isSwitch, onChanged: (bool _isSwitch){
                          isSwitch = _isSwitch;
                        }, activeColor: themeData.primaryColor) :
                        Transform.scale(scale: .7, child: CupertinoSwitch(value: isSwitch, onChanged: (bool _isSwitch){
                          isSwitch = _isSwitch;
                        }, activeColor: themeData.primaryColor))
                  ],
                ),
              ),
              ),
              Button(
                margin: EdgeInsets.symmetric(horizontal: ToPx.size(40), vertical: ToPx.size(200)),
                child: Text("保存"),
                withAlpha: 200,
                onPressed: () => _save(context),
              )
          ],
        )

      );
    });
  }
}
