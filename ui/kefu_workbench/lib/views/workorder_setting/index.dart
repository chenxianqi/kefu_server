import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/models/work_order_type.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/provider/workorde_setting.dart';
import 'package:provider/provider.dart';

class WorkOrderSettingPage extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  WorkOrderSettingPage({this.arguments});
  @override
  State<StatefulWidget> createState() {
    return _WorkOrderSettingPageState();
  }
}

class _WorkOrderSettingPageState extends State<WorkOrderSettingPage> {



  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(_) {
    return ChangeNotifierProvider<WorkOrderSettingProvide>(
        create: (_) => WorkOrderSettingProvide.getInstance(),
        child: Consumer<WorkOrderSettingProvide>(
            builder: (context, workorderSettingState, ___) {
          return PageContext(builder: (context) {
            ThemeData themeData = Theme.of(context);
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: customAppBar(
                    title: Text(
                      "工单设置",
                      style: themeData.textTheme.display1,
                    ),
                    actions: [
                     Button(
                        height: ToPx.size(90),
                        useIosStyle: true,
                        color: Colors.transparent,
                        width: ToPx.size(150),
                        child: Text("添加分类"),
                        onPressed: () => workorderSettingState.createWorkOrder(context),)
                    ]),
                body: Column(
                  children: <Widget>[
                  SizedBox(
                    height: ToPx.size(80),
                    child: Stack(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Platform.isAndroid
                        ? Switch(
                            value: workorderSettingState.isOpenWorkorder,
                            onChanged: (bool isSwitch) => workorderSettingState.setOpenWorkorder(context, isSwitch),
                            activeColor: Color(0xFF8bc34a))
                        : Transform.scale(
                            scale: .7,
                            child: CupertinoSwitch(
                            value: workorderSettingState.isOpenWorkorder,
                            onChanged: (bool isSwitch) => workorderSettingState.setOpenWorkorder(context, isSwitch),
                            activeColor: Color(0xFF8bc34a))),
                        Text(workorderSettingState.isOpenWorkorder ? "工单功能启用中" : "工单功能关闭中", style: themeData.textTheme.title.copyWith(
                          color: workorderSettingState.isOpenWorkorder ? Color(0xFF8bc34a) :  Color(0xFFcccccc)
                        ),),
                        ],
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onHorizontalDragUpdate: (_) => workorderSettingState.setOpenWorkorder(context, !workorderSettingState.isOpenWorkorder),
                        onTap: () => workorderSettingState.setOpenWorkorder(context, !workorderSettingState.isOpenWorkorder),
                      )
                    ],
                  ),
                  ),
                  Text("工单关闭后客户端无法发起工单", style: themeData.textTheme.caption, textAlign: TextAlign.center,),
                  Divider(),
                  Expanded(
                    child: RefreshIndicator(
                    color: themeData.primaryColorLight,
                    backgroundColor: themeData.primaryColor,
                    onRefresh: () async{
                      await GlobalProvide.getInstance().getWorkorderTypes();
                      return true;
                    },
                    child: CustomScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Column(children: <Widget>[
                          Text("工单分类管理"),
                          Divider(),
                        ],),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((ctx, index){
                          WorkOrderTypeModel workOrderType = workorderSettingState.getWorkorderTypes[index];
                          return SizedBox(
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  onTap: () => workorderSettingState.operating(context, workOrderType),
                                  title: Row(
                                    children: <Widget>[
                                      Icon(Icons.library_books, size: ToPx.size(40),color: themeData.textTheme.title.color),
                                      Text("  ${workOrderType.title}", style: themeData.textTheme.title,),
                                    ],
                                  )
                                ),
                                Divider(height: ToPx.size(1),)
                              ],
                            ));
                        }, childCount: workorderSettingState.getWorkorderTypes.length),
                      ),
                    ],
                  ))),
                  ],
                ));
          });
        }));
  }
}
