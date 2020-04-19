import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/provider/workorder.dart';
import 'package:provider/provider.dart';

class WorkOrderPage extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  WorkOrderPage({this.arguments});
  @override
  State<StatefulWidget> createState() {
    return _WorkOrderPageState();
  }
}

class _WorkOrderPageState extends State<WorkOrderPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  GlobalProvide globalProvide = GlobalProvide.getInstance();
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async{
    if(globalProvide.workOrderTypes.length == 0){
      await globalProvide.getWorkorderTypes();
      WorkOrderProvide.getInstance().getWorkOrders();
    }
    tabController = TabController(
          vsync: this, length: globalProvide.workOrderTypes.length);
      tabController.addListener(() {
        WorkOrderProvide.getInstance()
            .changeTabControllerIndex(tabController.index);
        WorkOrderProvide.getInstance().getWorkOrders();
      });
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(_) {
    return ChangeNotifierProvider<WorkOrderProvide>(
        create: (_) => WorkOrderProvide.getInstance(),
        child:
            Consumer<WorkOrderProvide>(builder: (context, workorderState, ___) {
          return PageContext(builder: (context) {
            ThemeData themeData = Theme.of(context);

            Widget _loading() {
              return SizedBox(
                width: ToPx.size(30),
                height: ToPx.size(30),
                child: Platform.isAndroid
                    ? CircularProgressIndicator(
                        strokeWidth: 2.0,
                      )
                    : CupertinoActivityIndicator(
                        radius: 8.0,
                      ),
              );
            }

            List<Widget> _tabView() {
              List<Widget> _widgets = [];
              for (var i = 0; i < globalProvide.workOrderTypes.length; i++) {
                int tid = globalProvide.workOrderTypes[i].id;
                var workOrders = workorderState.getWorkOrder(tid);
                _widgets.add(RefreshIndicator(
                color: themeData.primaryColorLight,
                backgroundColor: themeData.primaryColor,
                onRefresh: () async{
                  workorderState.isLoadEnd = false;
                  await WorkOrderProvide.getInstance().getWorkOrders();
                  await globalProvide.getWorkorderTypes();
                  return true;
                },
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: <Widget>[
                    SliverList(
                        delegate: SliverChildBuilderDelegate((ctx, index) {
                      var workOrder = workOrders[index];
                      return Column(
                        children: <Widget>[
                          ListTile(
                            onTap: (){
                              Navigator.pushNamed(
                              context, "/workorder/detail",
                              arguments: {"workOrder": workOrder}).then((_){
                                WorkOrderProvide.getInstance().getWorkOrders();
                              });
                            },
                            title: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ToPx.size(10)),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:EdgeInsets.only(right: ToPx.size(20)),
                                      child: Icon(
                                        Icons.library_books,
                                        color: themeData.textTheme.title.color.withAlpha(180),
                                        size: ToPx.size(50),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(bottom: ToPx.size(10)),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(child: Text("${workOrder.title}",
                                                style:themeData.textTheme.title,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                              workorderState.tabControllerIndex == globalProvide.workOrderTypes.length - 1
                                              ? Text("已删除", style: themeData.textTheme.caption.copyWith(color:Colors.red))
                                              : Text(
                                                workOrder.status == 2 ? "已回复" :
                                                workOrder.status == 3 ? "已结束" : 
                                                workOrder.status == 0 ? "待处理" : 
                                                workOrder.status == 1 ? "待回复" : "未知状态",
                                                style: themeData.textTheme.caption.copyWith(
                                                color: workOrder.status == 2 ? Color(0XFF8bc34a) : 
                                                workOrder.status == 3 ? Color(0XFFcccCCC) : 
                                                workOrder.status == 0 ? Color(0XFFFF9800) : 
                                                workOrder.status == 1 ? Color(0XFFFF9800) : Colors.amber),
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("时间：${Utils.formatDate(workOrder.createAt, isformatFull: true)}", style: themeData.textTheme.caption),
                                            Text("最后处理：${workOrder.aNickname.isEmpty ? '---' : workOrder.aNickname}", style: themeData.textTheme.caption),
                                          ],
                                        )
                                      ],
                                    )),
                                  ],
                                )),
                          ),
                          Divider(height: 1.0)
                        ],
                      );
                    }, childCount: workOrders.length)),
                    SliverToBoxAdapter(
                      child: Offstage(
                        offstage: workorderState.isLoading || workOrders.length > 0,
                        child: Padding(
                        padding: EdgeInsets.symmetric(vertical: ToPx.size(30)),
                        child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.library_books,
                            color: themeData.textTheme.title.color.withAlpha(150),
                            size: ToPx.size(60),
                          ),
                           Text("暂无相关数据~",style: themeData.textTheme.body1),
                        ],
                      ),
                      ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Offstage(
                        offstage: !workorderState.isLoading,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: ToPx.size(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _loading(),
                              Text("  加载中...",style: themeData.textTheme.body1),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )));
              }
              return _widgets;
            }

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: customAppBar(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "工单管理 ",
                        style: themeData.textTheme.display1,
                      ),
                      Offstage(
                        offstage: globalProvide.newWorkHandleCounts == 0,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: EdgeInsets.only(top: ToPx.size(5)),
                            child: Center(
                              child: Text(
                                "${globalProvide.newWorkHandleCounts}",
                                style: themeData.textTheme.caption.copyWith(
                                    color: Colors.white,
                                    fontSize: ToPx.size(20)),
                              ),
                            ),
                            width: ToPx.size(35),
                            height: ToPx.size(35),
                            decoration: BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                          ),
                        ),
                      )
                    ],
                  ),
                  actions: [
                    Button(
                        height: ToPx.size(90),
                        useIosStyle: true,
                        color: Colors.transparent,
                        width: ToPx.size(150),
                        child: Text("设置"),
                        onPressed: () => Navigator.pushNamed(context, "/workorder/setting")),
                  ]),
              body: globalProvide.workOrderTypes.length == 0
                  ? Center(child: _loading())
                  : Column(
                      children: <Widget>[
                        SizedBox(
                          height: ToPx.size(80),
                          child: TabBar(
                              isScrollable: true,
                              controller: tabController,
                              labelColor: themeData.primaryColor,
                              labelStyle: themeData.textTheme.body1.copyWith(
                                  color: themeData.primaryColor,
                                  fontWeight: FontWeight.w500),
                              unselectedLabelColor: themeData.accentColor,
                              indicatorWeight: ToPx.size(3),
                              tabs: globalProvide.workOrderTypes
                                  .map((i) => Tab(
                                        child: Text("${i.title}(${i.count})"),
                                      ))
                                  .toList()),
                        ),
                        Divider(
                          height: 0.0,
                        ),
                        Expanded(
                            child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification notification) {
                            double progress = notification.metrics.pixels /
                                notification.metrics.maxScrollExtent;
                            if (progress != null &&
                                progress >= 1.05 &&
                                progress < 2.0 &&
                                !workorderState.isLoading &&
                                !workorderState.isLoadEnd) {
                              var pageOn = workorderState.workOrderRequest['page_on'] + 1;
                              WorkOrderProvide.getInstance().getWorkOrders(pageOn: pageOn);
                              return true;
                            }
                            return true;
                          },
                          child: TabBarView(
                              controller: tabController,
                              physics: BouncingScrollPhysics(),
                              children: _tabView().toList()),
                        )),
                      ],
                    ),
            );
          });
        }));
  }
}
