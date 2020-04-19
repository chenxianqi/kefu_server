import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/admin.dart';
import 'package:kefu_workbench/provider/global.dart';

class AdminDetailPage extends   StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  AdminDetailPage({this.arguments});
  @override
  _AdminDetailPageState createState() => _AdminDetailPageState();
}
class _AdminDetailPageState extends State<AdminDetailPage> {

   AdminModel admin;

  @override
  void initState() {
    super.initState();
    admin = widget.arguments['admin'];
  }


  /// edit
  void _goEdit(BuildContext context) async{
    Navigator.pushNamed(context, "/admin_edit",arguments: {
      "admin": admin
    }).then((isSuccess) async{
      if(isSuccess == true){
        await AdminProvide.getInstance().getUser(admin.id);
        admin =  AdminProvide.getInstance().getItem(admin.id);
        setState(() {});
      }
    });
  }

  Color lineColor(int online){
    return online == 1  ? Colors.green[400] : online == 0 ? Colors.grey : online == 2 ? Colors.amber : Colors.grey;
  }

  /// delete
  void _delete(BuildContext context){
    UX.alert(
      context,
      content: Text("是否删除该客服吗！"),
      onConfirm: () async{
       Response response = await AdminService.getInstance().delete(id: admin.id);
       if (response.data["code"] == 200) {
         UX.showToast("删除成功");
         AdminProvide.getInstance().deleteItem(admin.id);
         Navigator.pop(context);
      } else {
        UX.showToast("${response.data["message"]}");
      }
      }
    );
  }
  
  @override
  Widget build(context) {
    admin =  AdminProvide.getInstance().getItem(admin.id);
    return PageContext(builder: (context){
      ThemeData themeData = Theme.of(context);
      Widget _lineItem({
        Widget label = const Text(""),
        Widget icon = const Text(""),
        Widget content = const Text(""),
        TextStyle style,
        Widget subChild = const SizedBox(), 
        CrossAxisAlignment contextCrossAxisAlignment = CrossAxisAlignment.start
      }){
        return Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: themeData.dividerColor))
            ),
            padding: EdgeInsets.symmetric(horizontal: ToPx.size(20), vertical: ToPx.size(40)),
            child: DefaultTextStyle(
              style: style,
              child: Row(
                children: <Widget>[
                  icon,
                  Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Row(
                        crossAxisAlignment: contextCrossAxisAlignment,
                      children: <Widget>[
                        label,
                        Expanded(
                          child: content,
                        )
                      ],
                    ),
                    subChild
                  ],),
                  )
                ],
              )
            )
          );
      }
      return Scaffold(
        backgroundColor: themeData.primaryColorLight,
        appBar: customAppBar(
            title: Text(
              "${admin.nickname}",
              style: themeData.textTheme.display1,
            ),
            actions: [
              Offstage(
                offstage: GlobalProvide.getInstance().serviceUser.root != 1,
                child: Button(
                height: ToPx.size(90),
                useIosStyle: true,
                color: Colors.transparent,
                width: ToPx.size(150),
                child: Text("编辑"),
                onPressed: () => _goEdit(context)
              ))
            ],
          ),
        body: ListView(
          children: <Widget>[
              _lineItem(
                icon: Avatar(
                  size: ToPx.size(100),
                  imgUrl: admin.avatar == null || admin.avatar.isEmpty ?
                  "http://qiniu.cmp520.com/avatar_default.png" : admin.avatar
                ),
                content:Row(
                  children: <Widget>[
                     Text("  ${admin.nickname}  "),
                     Text(
                      admin.online == 0 ? " 离线" :
                      admin.online == 1 ? " 在线" :
                      admin.online == 2 ? " 离开" : "未知",
                      style: themeData.textTheme.caption.copyWith(
                      color: lineColor(admin.online)
                    ),),
                  ],
                ),
                style: themeData.textTheme.title,
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                subChild: Row(
                  children: <Widget>[
                    Text("  角色：", style: themeData.textTheme.caption),
                    Text("${admin.root ==1 ? "超级管理" : "客服专员"}", style: themeData.textTheme.caption),
                  ],
                )
              ),
              _lineItem(
                label: Text("客服ID："),
                content: Text(admin.id.toString()),
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("客服账号："),
                content: Text(admin.username),
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("联系电话："),
                content: Text(admin.phone  ?? "未设置电话"),
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("自动回复语："),
                content: Text(admin.autoReply),
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("最后活动时间："),
                content: Text(Utils.epocFormat(admin.lastActivity)),
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("注册时间："),
                content: Text(Utils.formatDate(admin.createAt)),
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                style: themeData.textTheme.body1,
              ),
              Offstage(
                offstage: GlobalProvide.getInstance().serviceUser.root != 1 || admin.root == 1,
                child: Button(
                margin: EdgeInsets.symmetric(horizontal: ToPx.size(40), vertical: ToPx.size(50)),
                child: Text("删除"),
                withAlpha: 200,
                color: Colors.redAccent,
                onPressed: () => _delete(context),
              ),
              )
          ],
        )

      );
    }); 
  }
}
