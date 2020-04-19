import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/provider/robot.dart';
import 'package:provider/provider.dart';

class RobotsPage extends StatelessWidget {
  final Map<dynamic, dynamic> arguments;
  RobotsPage({this.arguments});

  @override
  Widget build(_) {
    return ChangeNotifierProvider<RobotProvide>(
      create: (_) => RobotProvide.getInstance(),
      child: Consumer<RobotProvide>(builder: (context, robotState, _){
         return PageContext(builder: (context){
            ThemeData themeData = Theme.of(context);
            return Scaffold(
              backgroundColor: themeData.primaryColorLight,
              appBar: customAppBar(
                  title: Text(
                    "机器人列表",
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
                      child: Text("新增"),
                      onPressed: () => robotState.goAdd(context)
                    ),
                    ),
                  ],
                ),
              body: 
              robotState.isLoading && robotState.robots.length == 0 ? Center(
                child: loadingIcon(size: ToPx.size(50)),
              ): 
              RefreshIndicator(
                color: themeData.primaryColorLight,
                backgroundColor: themeData.primaryColor,
                onRefresh: robotState.onRefresh,
                child: CustomScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Offstage(
                        offstage: robotState.robots.length > 0 || robotState.isLoading,
                        child: Padding(
                          padding: EdgeInsets.only(top: ToPx.size(50)),
                          child: Text("暂无数据~", style: themeData.textTheme.body1, textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index){
                        RobotModel robot = robotState.robots[index];
                        return Column(
                          children: <Widget>[
                            ListTile(
                              onTap: () => Navigator.pushNamed(context, "/robot_detail",arguments: {
                                "robot": robot
                              }),
                              subtitle: Row(
                                children: <Widget>[
                                  Text("服务平台：", style: themeData.textTheme.caption),
                                  Text("${GlobalProvide.getInstance().getPlatformTitle(robot.platform)}", style: themeData.textTheme.caption),
                                ],
                              ),
                              trailing: RichText(
                                text: TextSpan(
                                  style: themeData.textTheme.caption,
                                  children: [
                                    TextSpan(text: "状态："),
                                    TextSpan(text: robot.isRun == 1 ? "运行中" : "暂停中", style: themeData.textTheme.caption.copyWith(
                                      color: robot.isRun == 1 ? Colors.green : Colors.amber
                                    )),
                                  ]
                                ),
                              ),
                              leading: Avatar(
                                size: ToPx.size(100),
                                imgUrl: robot.avatar == null || robot.avatar.isEmpty ?
                                "http://qiniu.cmp520.com/avatar_default.png" : robot.avatar
                              ),
                              title: Text("${robot.nickname}", style: themeData.textTheme.title, maxLines: 2, overflow: TextOverflow.ellipsis,),
                            ),
                            Divider(height: 1.0,)
                          ],
                        );
                      },
                      childCount: robotState.robots.length
                     ),
                    ),
                ],
              )
              ),
            );
          });
      },),
    );

  }
}

