import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
class ShortcutEditPage extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  ShortcutEditPage({this.arguments});
  @override
  _ShortcutEditPageState createState() => _ShortcutEditPageState();
}
class _ShortcutEditPageState extends State<ShortcutEditPage> {
  ShortcutModel shortcut;
  bool isEdit = false;
  TextEditingController titleCtr;
  TextEditingController contentCtr;


  /// save
  void _save() async{
    String title = titleCtr.value.text.trim();
    String content =  contentCtr.value.text.trim();
    /// 判断title不能为空
    if(title.isEmpty || title == ""){
      UX.showToast("标题不能为空");
      return;
    }
    /// 判断content不能为空
    if(content.isEmpty || content == ""){
      UX.showToast("内容不能为空");
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    UX.showLoading(context, content: "保存中...");
    Response response;
    if(isEdit){
      response = await ShortcutService.getInstance().update({
        "id": shortcut.id,
         "title": title,
        "content": content
      });
    }else{
      response = await ShortcutService.getInstance().add({
         "title": title,
        "content": content
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
      content: Text("是否删除该条快捷语吗！"),
      onConfirm: () async{
       Response response = await ShortcutService.getInstance().delete(shortcut.id);
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
      shortcut = (widget.arguments['shortcut'] as ShortcutModel);
      titleCtr = TextEditingController(text: shortcut.title);
      contentCtr = TextEditingController(text: shortcut.content);
    }else{
      titleCtr = TextEditingController();
      contentCtr = TextEditingController();
    }
  }

  @override
  void dispose() {
    contentCtr?.dispose();
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
            isEdit ? "编辑快捷语" : "添加快捷语",
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
                    Text("标题：", style: themeData.textTheme.title,),
                    Expanded(
                      child: Input(
                      autofocus: true,
                      border: Border.all(style: BorderStyle.none, color: Colors.transparent),
                      padding: EdgeInsets.symmetric(horizontal: ToPx.size(10)),
                      placeholder: "请输入标题",
                      showClear: true,
                      controller: titleCtr,
                    ),
                    )
                  ],
                ),
              ),

               Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: themeData.dividerColor,width: ToPx.size(2)))
                ),
                padding: EdgeInsets.symmetric(horizontal: ToPx.size(40), vertical: ToPx.size(10)),
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Text("内容：", style: themeData.textTheme.title,),
                    Expanded(
                      child: Input(
                      minLines: 10,
                      maxLines: 10,
                      textInputAction: TextInputAction.newline,
                      border: Border.all(style: BorderStyle.none, color: Colors.transparent),
                      padding: EdgeInsets.symmetric(horizontal: ToPx.size(10)),
                      placeholder: "请输入内容",
                      controller: contentCtr,
                    ),
                    )
                  ],
                ),
              ),


              Button(
                margin: EdgeInsets.symmetric(horizontal: ToPx.size(40), vertical: ToPx.size(isEdit ? 25 : 50)),
                onPressed: _save,
                 withAlpha: 200,
                child: Text("保存"),
              ),
              Offstage(
                offstage: !isEdit,
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
