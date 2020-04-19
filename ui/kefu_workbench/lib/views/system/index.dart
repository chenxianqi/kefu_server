import 'package:kefu_workbench/core_flutter.dart';

import 'widget/base.dart';
import 'widget/company.dart';
import 'widget/platform.dart';
import 'widget/qiniu.dart';

class SystemPage extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  SystemPage({this.arguments});
  @override
  State<StatefulWidget> createState() {
    return _SystemPageState();
  }
}

class _SystemPageState extends State<SystemPage> with SingleTickerProviderStateMixin{
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 4);
    tabController.addListener((){
       FocusScope.of(context).requestFocus(FocusNode());
    });
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
        backgroundColor: Colors.white,
        appBar: customAppBar(
            title: Text(
              "系统设置",
              style: themeData.textTheme.display1,
            )),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: ToPx.size(80),
              child: TabBar(
              labelColor: themeData.primaryColor,
              isScrollable: true,
              labelStyle: themeData.textTheme.body1.copyWith(color:  themeData.primaryColor, fontWeight: FontWeight.w500),
              unselectedLabelColor: themeData.accentColor,
              indicatorWeight: ToPx.size(3),
              controller: tabController,
              tabs: <Widget>[
                Tab(
                  child: Text("基本设置"),
                ),
                Tab(
                  child: Text("公司信息"),
                ),
                Tab(
                  child: Text("七牛云存储配置"),
                ),
                Tab(
                  child: Text("客户端平台"),
                ),
              ],
            ),),
            Divider(height: 0.0,),
            Expanded(
              child: TabBarView(
              controller: tabController,
              physics: BouncingScrollPhysics(),
              children: <Widget>[
              BaseSettingView(),
              CompamySettingView(),
              QiniuSettingView(),
              PlatformSettingView(),
            ],),
            )
          ],
        ),
      );
    });
  }
}
