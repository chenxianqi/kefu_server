import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/provider/robot.dart';

class RobotDetailPage extends   StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  RobotDetailPage({this.arguments});
  @override
  _RotobDetailPageState createState() => _RotobDetailPageState();
}
class _RotobDetailPageState extends State<RobotDetailPage> {

   RobotModel robot;

  @override
  void initState() {
    super.initState();
    robot = widget.arguments['robot'];
  }


  /// edit
  void _goEdit(BuildContext context) async{
    Navigator.pushNamed(context, "/robot_edit",arguments: {
      "robot": robot
    }).then((isSuccess) async{
      if(isSuccess == true){
        robot =  RobotProvide.getInstance().getItem(robot.id);
        setState(() {});
      }
    });
  }

  /// delete
  void _delete(BuildContext context){
    UX.alert(
      context,
      content: Text("是否删除该机器人吗！"),
      onConfirm: () async{
       Response response = await RobotService.getInstance().delete(id: robot.id);
       if (response.data["code"] == 200) {
         UX.showToast("删除成功");
         RobotProvide.getInstance().deleteItem(robot.id);
         Navigator.pop(context);
      } else {
        UX.showToast("${response.data["message"]}");
      }
      }
    );
  }
  
  @override
  Widget build(context) {
    robot =  RobotProvide.getInstance().getItem(robot.id);
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
              "${robot.nickname}",
              style: themeData.textTheme.display1,
            ),
            actions: [
              Offstage(
                offstage: GlobalProvide.getInstance()?.serviceUser?.root != 1,
                child: Button(
                height: ToPx.size(90),
                useIosStyle: true,
                color: Colors.transparent,
                width: ToPx.size(150),
                child: Text("编辑"),
                onPressed: () => _goEdit(context)
              )),
            ],
          ),
        body: ListView(
          children: <Widget>[
              _lineItem(
                icon: Avatar(
                  size: ToPx.size(100),
                  imgUrl: robot.avatar == null || robot.avatar.isEmpty ?
                  "http://qiniu.cmp520.com/avatar_default.png" : robot.avatar
                ),
                content: "  ${robot.nickname}",
                style: themeData.textTheme.title,
                contextCrossAxisAlignment: CrossAxisAlignment.center,
                subChild: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("  服务平台：", style: themeData.textTheme.caption),
                        Text("${GlobalProvide.getInstance().getPlatformTitle(robot.platform)}", style: themeData.textTheme.caption),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        style: themeData.textTheme.caption,
                        children: [
                          TextSpan(text: "状态："),
                          TextSpan(text: robot.isRun == 1 ? "运行中" : "暂停中", style: themeData.textTheme.caption.copyWith(
                            color: robot.isRun == 1 ? Colors.green : Colors.amber
                          )),
                        ]
                      ))
                      ],
                    )
              ),
              _lineItem(
                label: Text("欢迎语："),
                content: robot.welcome,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("无匹配："),
                content: robot.understand,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("超时语："),
                content: robot.timeoutText,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("无人工："),
                content: robot.noServices,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("时间长："),
                content: robot.loogTimeWaitText,
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("检索词："),
                content: robot.keyword.replaceAll("|", "、"),
                style: themeData.textTheme.body1,
              ),
              _lineItem(
                label: Text("转人工："),
                content: robot.artificial.replaceAll("|", "、"),
                style: themeData.textTheme.body1,
              ),
              Offstage(
                offstage: robot.system == 1,
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
