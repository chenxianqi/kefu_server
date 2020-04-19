import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/provider/user.dart';

class UserDetailPage extends   StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  UserDetailPage({this.arguments});
  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}
class _UserDetailPageState extends State<UserDetailPage> {

   UserModel user;

  @override
  void initState() {
    super.initState();
    user = widget.arguments['user'];
  }


  /// edit
  void _goEdit(BuildContext context) async{
    Navigator.pushNamed(context, "/user_edit",arguments: {
      "user": user
    }).then((isSuccess) async{
      if(isSuccess == true){
        await UserProvide.getInstance().getUser(user.id);
        user =  UserProvide.getInstance().getItem(user.id);
        setState(() {});
      }
    });
  }

  /// delete
  void _delete(BuildContext context){
    UX.alert(
      context,
      content: Text("是否删除该用户吗！"),
      onConfirm: () async{
       Response response = await UserService.getInstance().delete(id: user.id);
       if (response.data["code"] == 200) {
         UX.showToast("删除成功");
         UserProvide.getInstance().deleteItem(user.id);
         Navigator.pop(context);
      } else {
        UX.showToast("${response.data["message"]}");
      }
      }
    );
  }
  
  @override
  Widget build(context) {
    user =  UserProvide.getInstance().getItem(user.id);
    return PageContext(builder: (context){
      ThemeData themeData = Theme.of(context);
      Widget _lineItem({
        Widget label = const Text(""),
        Widget icon = const Text(""),
        String content,
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
                          child: Text("$content", textAlign: TextAlign.left,),
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
              "${user.nickname}",
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
                icon: Avatar(
                  size: ToPx.size(100),
                  imgUrl: user.avatar == null || user.avatar.isEmpty ?
                  "http://qiniu.cmp520.com/avatar_default.png" : user.avatar
                ),
                content: "  ${user.nickname}",
                style: themeData.textTheme.title,
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                subChild: Row(
                  children: <Widget>[
                    Text("  所在平台：", style: themeData.textTheme.caption),
                    Text("${GlobalProvide.getInstance().getPlatformTitle(user.platform)}", style: themeData.textTheme.caption),
                  ],
                )
              ),
              _lineItem(
                label: Text("在线状态："),
                content: user.online ==1 ? "在线" : "离线",
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("业务平台ID："),
                content: user.uid.toString(),
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("所在地区："),
                content: user.address.isNotEmpty ?  user.address : "未知地区",
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                style: themeData.textTheme.body1,
              ),
               _lineItem(
                label: Text("联系方式："),
                content: user.phone.isNotEmpty ?  user.phone : "未知联系方式",
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("备注信息："),
                content: user.remarks.isNotEmpty ?  user.remarks : "未知设置备注",
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("注册时间："),
                content: Utils.formatDate(user.createAt),
                contextCrossAxisAlignment: CrossAxisAlignment.center,
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
