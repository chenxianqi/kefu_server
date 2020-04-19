import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/provider/knowledge.dart';

class KnowledgeDetailPage extends   StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  KnowledgeDetailPage({this.arguments});
  @override
  _KnowledgeDetailPageState createState() => _KnowledgeDetailPageState();
}
class _KnowledgeDetailPageState extends State<KnowledgeDetailPage> {

   KnowledgeModel knowledge;

  @override
  void initState() {
    super.initState();
    knowledge = widget.arguments['knowledge'];
  }


  /// edit
  void _goEdit(BuildContext context) async{
    Navigator.pushNamed(context, "/knowledge_edit",arguments: {
      "knowledge": knowledge
    }).then((isSuccess) async{
      if(isSuccess == true){
        knowledge =  KnowledgeProvide.getInstance().getItem(knowledge.id);
        setState(() {});
      }
    });
  }

  /// delete
  void _delete(BuildContext context){
    UX.alert(
      context,
      content: Text("是否删除该知识库！"),
      onConfirm: () async{
       Response response = await KnowledgeService.getInstance().delete(id: knowledge.id);
       if (response.data["code"] == 200) {
         UX.showToast("删除成功");
         KnowledgeProvide.getInstance().deleteItem(knowledge.id);
         Navigator.pop(context);
      } else {
        UX.showToast("${response.data["message"]}");
      }
      }
    );
  }
  
  @override
  Widget build(context) {
    knowledge =  KnowledgeProvide.getInstance().getItem(knowledge.id);
    return PageContext(builder: (context){
      ThemeData themeData = Theme.of(context);
      Widget _lineItem({
        String label,
        String content,
        TextStyle style,
        Widget subChild = const SizedBox()
      }){
        return Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: themeData.dividerColor))
            ),
            padding: EdgeInsets.symmetric(horizontal: ToPx.size(20), vertical: ToPx.size(40)),
            child: DefaultTextStyle(
              style: style,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("$label"),
                    Expanded(
                      child: Text("$content", textAlign: TextAlign.left,),
                    )
                  ],
                ),
                subChild
              ],)
            )
          );
      }
      return Scaffold(
        backgroundColor: themeData.primaryColorLight,
        appBar: customAppBar(
            title: Text(
              "${knowledge.title}",
              style: themeData.textTheme.display1,
            ),
            actions: [
              Button(
                height: ToPx.size(90),
                useIosStyle: true,
                color: Colors.transparent,
                width: ToPx.size(150),
                child: Text("编辑"),
                onPressed: () => _goEdit(context)
              ),
            ],
          ),
        body: ListView(
          children: <Widget>[
              _lineItem(
                label: "主标题：",
                content: "${knowledge.title}",
                style: themeData.textTheme.title,
                subChild: DefaultTextStyle(
                  style: themeData.textTheme.caption,
                  child: Padding(
                    padding: EdgeInsets.only(top: ToPx.size(30)),
                    child: Row(
                  children: <Widget>[
                    Text(
                      "展示平台：${GlobalProvide.getInstance().getPlatformTitle(knowledge.platform)}     ",
                    ),
                    Text("创建时间：${Utils.formatDate(knowledge.createAt)}")
                  ],
                ),
                  ),
                )
              ),
              _lineItem(
                label: "副标题：",
                content: "${knowledge.subTitle.replaceAll("|", "、")}",
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: "内容：",
                content: "${knowledge.content}",
                style: themeData.textTheme.body1,
              ),
              Button(
                margin: EdgeInsets.symmetric(horizontal: ToPx.size(40), vertical: ToPx.size(50)),
                child: Text("删除"),
                withAlpha: 200,
                color: Colors.redAccent,
                onPressed: () => _delete(context),
              )
          ],
        )

      );
    }); 
  }
}
