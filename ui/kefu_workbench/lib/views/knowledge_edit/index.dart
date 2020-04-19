import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/provider/knowledge.dart';
class KnowledgeEditPage extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  KnowledgeEditPage({this.arguments});
  @override
  _KnowledgeEditPageState createState() => _KnowledgeEditPageState(
    knowledge: arguments != null ? arguments['knowledge'] : null
  );
}

class _KnowledgeEditPageState extends State<KnowledgeEditPage> {
  final KnowledgeModel knowledge;
  bool isEdit = false;
  TextEditingController titleCtr;
  TextEditingController subTitleCtr;
  TextEditingController contentCtr;
  _KnowledgeEditPageState({this.knowledge});
  List<PlatformModel> platforms = GlobalProvide.getInstance().platforms;
  String selectPlatform = "全平台";

  @override
  void initState() {
    super.initState();
    if(mounted){
      if(knowledge != null){
        isEdit = true;
        titleCtr = TextEditingController(text: knowledge.title);
        subTitleCtr = TextEditingController(text: knowledge.subTitle.replaceAll("|", "\n"));
        contentCtr = TextEditingController(text: knowledge.content);
        selectPlatform = GlobalProvide.getInstance().getPlatformTitle(knowledge.platform);
      }else{
        titleCtr = TextEditingController();
        subTitleCtr = TextEditingController();
        contentCtr = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    titleCtr?.dispose();
    subTitleCtr?.dispose();
    contentCtr?.dispose();
    super.dispose();
  }

  /// 保存
  void _save(BuildContext context) async{
    String title = titleCtr.value.text.trim();
    String subTitle = subTitleCtr.value.text.trim();
    String content = contentCtr.value.text.trim();
    if(title.isEmpty || title == ""){
      UX.showToast("主标题不能为空");
      return;
    }
    if(subTitle.isEmpty || subTitle == ""){
      UX.showToast("副标题不能为空");
      return;
    }
    if(content.isEmpty || content == ""){
      UX.showToast("内容不能为空");
      return;
    }
    if(selectPlatform.isEmpty || selectPlatform == ""){
      UX.showToast("平台不能为空");
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    UX.showLoading(context, content: "保存中...");
    GlobalProvide globalProvide = GlobalProvide.getInstance();
    Map data = {
      "uid": globalProvide.serviceUser.id,
      "platform": globalProvide.getPlatformId(selectPlatform),
      "title": title,
      "id": knowledge?.id ?? null,
      "sub_title": subTitle.replaceAll("\n", "|"),
      "content": content,
    };
    Response response;
    if(isEdit){
       response = await KnowledgeService.getInstance().update(data: data);
    }else{
       response = await KnowledgeService.getInstance().add(data: data);
    }
    UX.hideLoading(context);
    if(response.statusCode == 200){
      UX.showToast("保存成功");
      if(isEdit){
       await KnowledgeProvide.getInstance().getKnowledge(knowledge.id);
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
              "${isEdit ? "编辑知识库" : "添加知识库"}",
              style: themeData.textTheme.display1,
            ),
          ),
        body: ListView(
          children: <Widget>[
              SizedBox(height: ToPx.size(20),),
              _lineItem(
                label: "主标题：",
                placeholder: "请输入主标题",
                style: themeData.textTheme.title,
                controller: titleCtr,
                autofocus: true
              ),
              _lineItem(
                minLines: 1,
                maxLines: 8,
                label: "副标题：",
                placeholder: "请输入副标题(每行一条)",
                style: themeData.textTheme.title,
                controller: subTitleCtr,
                crossAxisAlignment: CrossAxisAlignment.start,
                subChild: Padding(
                  padding: EdgeInsets.symmetric(vertical: ToPx.size(8)),
                  child: Text("注意：副标题如有多条请换行处理", style: themeData.textTheme.caption.copyWith(
                    color: Colors.amber
                  ),),
                )
              ),
              _lineItem(
                minLines: 1,
                maxLines: 40,
                label: "    内容：",
                placeholder: "请输入内容",
                style: themeData.textTheme.title,
                controller: contentCtr,
                crossAxisAlignment: CrossAxisAlignment.start
              ),
              DropdownButtonHideUnderline(
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
