import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
class PlatformEditPage extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  PlatformEditPage({this.arguments});
  @override
  _PlatformEditPageState createState() => _PlatformEditPageState();
}
class _PlatformEditPageState extends State<PlatformEditPage> {
  PlatformModel platform;
  bool isEdit = false;
  bool isSystem = false;
  TextEditingController titleCtr;
  TextEditingController aliasCtr;


  /// save
  void _save() async{
    String title = titleCtr.value.text.trim();
    String alias =  aliasCtr.value.text.trim();
    UX.showLoading(context, content: "保存中...");
    Response response;
    if(isEdit){
      platform.title = title;
      platform.alias = alias;
      response = await PlatformService.getInstance().update(platform.toJson());
    }else{
      response = await PlatformService.getInstance().add({
        "title": title,
        "alias": alias
      });
    }
    UX.hideLoading(context);
    if(response.statusCode == 200){
      UX.showToast("保存成功");
      Navigator.pop(context, true);
    }else{
      UX.showToast(response.data["message"]);
    }
  }
  

  /// _delete
  void _delete(BuildContext context){
    UX.alert(
      context,
      content: Text("是否删除该平台吗！"),
      onConfirm: () async{
       Response response = await PlatformService.getInstance().delete(platform.id);
       if (response.data["code"] == 200) {
         UX.showToast("删除成功");
         Navigator.pop(context, true);
      } else {
        UX.showToast("${response.data["message"]}");
      }
      }
    );
  }

  @override
  void initState() {
    super.initState();
    if(mounted && widget.arguments != null){
      isEdit = true;
      platform = (widget.arguments['platform'] as PlatformModel);
      isSystem = platform.system == 1;
      titleCtr = TextEditingController(text: platform.title);
      aliasCtr = TextEditingController(text: platform.alias);
    }else{
      titleCtr = TextEditingController();
      aliasCtr = TextEditingController();
    }
  }

  @override
  void dispose() {
    aliasCtr?.dispose();
    titleCtr?.dispose();
    super.dispose();
  }

  @override
  Widget build(_) {
    return PageContext(builder: (context){
      ThemeData themeData = Theme.of(context);

      return Scaffold(
        appBar: customAppBar(
          title: Text(
            isEdit ? "编辑平台" : "添加平台",
            style: themeData.textTheme.display1,
          )),
        body: ListView(
          children: <Widget>[
              SizedBox(
                height: ToPx.size(20),
              ),

              Container(
                height: ToPx.size(90),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: themeData.dividerColor,width: ToPx.size(2)))
                ),
                padding: EdgeInsets.symmetric(horizontal: ToPx.size(40)),
                child: Row(
                children: <Widget>[
                    Text("平台名称：", style: themeData.textTheme.title,),
                    Expanded(
                      child: Input(
                      autofocus: !isSystem,
                      enabled:  !isSystem,
                      border: Border.all(style: BorderStyle.none, color: Colors.transparent),
                      padding: EdgeInsets.symmetric(horizontal: ToPx.size(10)),
                      placeholder: "请输入平台名称",
                      showClear: true,
                      controller: titleCtr,
                    ),
                    )
                  ],
                ),
              ),

              Container(
                height: ToPx.size(90),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: themeData.dividerColor,width: ToPx.size(2)))
                ),
                padding: EdgeInsets.symmetric(horizontal: ToPx.size(40)),
                child: Row(
                children: <Widget>[
                    Text("平台别名：", style: themeData.textTheme.title,),
                    Expanded(
                      child: Input(
                      enabled: !isSystem,
                      border: Border.all(style: BorderStyle.none, color: Colors.transparent),
                      padding: EdgeInsets.symmetric(horizontal: ToPx.size(10)),
                      placeholder: "请输入平台别名",
                      showClear: true,
                      controller: aliasCtr,
                    ),
                    )
                  ],
                ),
              ),

              Offstage(
                offstage: !isSystem,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: ToPx.size(15)),
                  child: Text("系统内置，无法编辑或删除", style: themeData.textTheme.body2, textAlign: TextAlign.center,),
                )
              ),


              Offstage(
                offstage: isSystem,
                child: Button(
                margin: EdgeInsets.symmetric(horizontal: ToPx.size(40), vertical: ToPx.size(isEdit ? 25 : 50)),
                onPressed: _save,
                 withAlpha: 200,
                child: Text("保存"),
              ),
              ),
              Offstage(
                offstage: !isEdit || isSystem,
                child: Button(
                color: Colors.red,
                margin: EdgeInsets.symmetric(horizontal: ToPx.size(40)),
                onPressed: () => _delete(context),
                 withAlpha: 200,
                child: Text("删除"),
              ),
              )

          ],
        )
      );
    });
  }
}
