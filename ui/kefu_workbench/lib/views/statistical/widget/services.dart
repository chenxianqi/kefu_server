import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
class ServiceCountView  extends StatefulWidget{
  @override
  _ServiceCountViewState createState() => _ServiceCountViewState();
}

class _ServiceCountViewState  extends State<ServiceCountView> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;
  List<StatisticalCountModel> statisticalCountItems = [];
  List<ServicesCountModel> servicesCountItems = [];
  PageController pageController;
  String dateStart;
  String dateEnd;
  PublicService publicService = PublicService.getInstance();
  bool isLoading = true;
  int pageIndex = 0;
  int get servicesCounts{
    int _count = 0;
    for(var i = 0; i<servicesCountItems.length; i++){
      _count += int.parse(servicesCountItems[i].count);
    }
    return _count;
  }

  /// 获取信息
  Future<void> _getCountStatistical() async{
    await Future.delayed(Duration(milliseconds: 500));
    Response response = await publicService.getCountStatistical(dateStart: dateStart, dateEnd: dateEnd);
    if (response.data["code"] == 200) {
      servicesCountItems = (response.data['data']['members'] as List).map((i) => ServicesCountModel.fromJson(i)).toList();
      statisticalCountItems = (response.data['data']['statistical'] as List).map((i) => StatisticalCountModel.fromJson(i)).toList();
      printf(servicesCountItems.toList());
      printf(statisticalCountItems.toList());
    } else {
      UX.showToast("${response.data["message"]}");
    }
    isLoading = false;
    setState(() {});
  }

  // 选择开始时间
  void _onSelectStartDate(BuildContext context) async{
    var _date = await UX.selectDatePicker(context, oldDate: dateStart);
    if (_date == null || _date == dateStart) return;
   if(DateTime.parse(_date).millisecondsSinceEpoch > DateTime.parse(dateEnd).millisecondsSinceEpoch){
      UX.showToast("开始时间不能大于结束时间");
      return;
    }
    dateStart = _date;
    setState(() {});
    _getCountStatistical();
  }

  // 选择结束时间
  void _onSelectEndDate(BuildContext context) async{
    var _date = await UX.selectDatePicker(context, oldDate: dateEnd);
    if (_date == null || _date == dateEnd) return;
    if(DateTime.parse(_date).millisecondsSinceEpoch < DateTime.parse(dateStart).millisecondsSinceEpoch){
      UX.showToast("结束时间不能小于开始时间");
      return;
    }
    dateEnd = _date;
    setState(() {});
     _getCountStatistical();
  }

  // 刷新
  Future<bool> _onRefresh() async{
    await _getCountStatistical();
    UX.showToast("刷新成功", position: ToastPosition.top);
    return true;
  }

  @override
  void initState() {
    super.initState();
    if(mounted){
      DateTime _dateStartTime = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - (86400000 * 6));
      dateStart = "${_dateStartTime.year}-${_dateStartTime.month < 10 ? '0'+_dateStartTime.month.toString() : _dateStartTime.month}-${_dateStartTime.day < 10 ? '0'+_dateStartTime.day.toString() : _dateStartTime.day}";;
      DateTime _dateEndTime = DateTime.now();
      dateEnd = "${_dateEndTime.year}-${_dateEndTime.month < 10 ? '0'+_dateEndTime.month.toString() : _dateEndTime.month}-${_dateEndTime.day < 10 ? '0'+_dateEndTime.day.toString() : _dateEndTime.day}";;
      _getCountStatistical();
      pageController = PageController(initialPage: pageIndex);
    }
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    if(isLoading){
      return Center(
        child: loadingIcon(size: ToPx.size(50)),
      );
    }
    return Column(
          children: <Widget>[
            SizedBox(
              height: ToPx.size(20),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _onSelectStartDate(context),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.date_range, color: themeData.textTheme.body1.color, size: ToPx.size(30),),
                        Text(" $dateStart", style: themeData.textTheme.body1,)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ToPx.size(50)),
                    child: Text("至", style: themeData.textTheme.body1,),
                  ),
                  GestureDetector(
                     onTap: () => _onSelectEndDate(context),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.date_range, color: themeData.textTheme.body1.color, size: ToPx.size(30),),
                        Text("  $dateEnd", style: themeData.textTheme.body1,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (int index){
                  pageIndex = index;
                  setState(() {});
                },
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                          Text("各渠道服务量统计(${servicesCounts.toString() + '人次'})"),
                          Expanded(
                            child: DefaultTabController(
                              length: statisticalCountItems.length,
                              child: Column(children: <Widget>[
                                SizedBox(
                                  height: ToPx.size(80),
                                  child: TabBar(
                                  labelColor: themeData.primaryColor,
                                  isScrollable: true,
                                  labelStyle: themeData.textTheme.body1.copyWith(color:  themeData.primaryColor, fontWeight: FontWeight.w500),
                                  unselectedLabelColor: themeData.accentColor,
                                  indicatorWeight: ToPx.size(3),
                                  tabs: statisticalCountItems.map((i) => Tab(
                                    child: Text("${i.date}"),
                                  )).toList()
                                ),),
                                Divider(height: 0.0,),
                                Expanded(
                                  child: TabBarView(
                                  physics: BouncingScrollPhysics(),
                                  children: statisticalCountItems.map((i){
                                    return RefreshIndicator(
                                    color: themeData.primaryColorLight,
                                    backgroundColor: themeData.primaryColor,
                                    onRefresh: () => _onRefresh(),
                                    child:  ListView.builder(
                                      itemBuilder: (context, index){
                                        StatisticalItems statisticalItem = i.statisticalItems[index];
                                        return Column(children: <Widget>[
                                          ListTile(
                                          title: Row(children: <Widget>[
                                            Text("${index+1}、", style: themeData.textTheme.title,),
                                            Text("${statisticalItem.title}", style: themeData.textTheme.title,)
                                          ],),
                                          trailing: Text("${statisticalItem.count}人", style: themeData.textTheme.title.copyWith(
                                            color: Colors.green
                                          ),),
                                        ),
                                        Divider(height: 0.0)
                                        ],);
                                      },
                                      itemCount: i.statisticalItems.length,
                                    )
                                  );
                                  }).toList()),
                                )
                              ],),
                            ),
                          ),
                          Offstage(
                             offstage: pageIndex == 1,
                            child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.ease);
                            },
                            child: Icon(Icons.keyboard_arrow_up, size: ToPx.size(100),color: Colors.grey,),
                          ),
                          )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                          Offstage(
                            offstage: pageIndex == 0,
                            child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                            },
                            child: Icon(Icons.keyboard_arrow_down, size: ToPx.size(80),color: Colors.grey,),
                          ),
                          ),
                          Text("客服接入量统计(${servicesCounts.toString() + '人次'})"),
                          Divider(),
                          Expanded(
                            child: RefreshIndicator(
                              color: themeData.primaryColorLight,
                              backgroundColor: themeData.primaryColor,
                              onRefresh: () => _onRefresh(),
                              child: ListView.builder(
                              itemBuilder: (context, index){
                                ServicesCountModel servicesCountItem = servicesCountItems[index];
                                return Column(children: <Widget>[
                                  ListTile(
                                  title: Row(children: <Widget>[
                                    Text("${index+1}、", style: themeData.textTheme.title,),
                                    Text("${servicesCountItem.nickname}", style: themeData.textTheme.title,)
                                  ],),
                                  trailing: Text("服务${servicesCountItem.count}人", style: themeData.textTheme.title.copyWith(
                                    color: Colors.green
                                  ),),
                                ),
                                Divider(height: 0.0)
                                ],);
                              },
                              itemCount: servicesCountItems.length,
                            )
                            ))
                      ],
                    ),
                  ),
                ],
              )
            )
        ],
      );
  }
}