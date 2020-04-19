import 'package:kefu_workbench/core_flutter.dart';

import 'widget/flow.dart';
import 'widget/services.dart';
class StatisticalPage extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  StatisticalPage({this.arguments});
  @override
  State<StatefulWidget> createState() {
    return _StatisticalPage();
  }
}
class _StatisticalPage extends State<StatisticalPage>  with SingleTickerProviderStateMixin{

  TabController tabController;

    @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  
  @override
  Widget build(_) {
    return PageContext(builder: (context){
      ThemeData themeData = Theme.of(context);
      return Scaffold(
        appBar: customAppBar(
            title: Text(
              "统计",
              style: themeData.textTheme.display1,
            ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: ToPx.size(80),
              child: TabBar(
              labelColor: themeData.primaryColor,
              labelStyle: themeData.textTheme.body1.copyWith(color:  themeData.primaryColor, fontWeight: FontWeight.w500),
              unselectedLabelColor: themeData.accentColor,
              indicatorWeight: ToPx.size(3),
              controller: tabController,
              tabs: <Widget>[
                Tab(
                  child: Text("用户访问量"),
                ),
                Tab(
                  child: Text("服务量统计"),
                ),
              ],
            ),),
            Divider(height: 0.0,),
            Expanded(
              child: TabBarView(
              controller: tabController,
              physics: BouncingScrollPhysics(),
              children: <Widget>[
              FlowView(),
              ServiceCountView(),
            ],),
            )
          ],
        ),
      );
    });
  }
}
