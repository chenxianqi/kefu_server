import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
class FlowView  extends StatefulWidget{
  @override
  _FlowViewState createState() => _FlowViewState();
}

class _FlowViewState  extends State<FlowView> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;
  List<FlowModel> flows = [];
  String dateStart;
  String dateEnd;
  PublicService publicService = PublicService.getInstance();
  bool isLoading = true;

  /// 获取信息
  Future<void> _getIpStatistical() async{
    await Future.delayed(Duration(milliseconds: 500));
    Response response = await publicService.getIpStatistical(dateStart: dateStart, dateEnd: dateEnd);
    if (response.data["code"] == 200) {
      flows = (response.data['data'] as List).map((i) => FlowModel.fromJson(i)).toList();
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
    _getIpStatistical();
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
     _getIpStatistical();
  }

  // 刷新
  Future<bool> _onRefresh() async{
    await _getIpStatistical();
    UX.showToast("刷新成功", position: ToastPosition.top);
    return true;
  }



  @override
  void initState() {
    super.initState();
    if(mounted){
      DateTime _dateTime = DateTime.now();
      String _date = "${_dateTime.year}-${_dateTime.month < 10 ? '0'+_dateTime.month.toString() : _dateTime.month}-${_dateTime.day < 10 ? '0'+_dateTime.day.toString() : _dateTime.day}";
      dateStart = _date;
      dateEnd = _date;
      _getIpStatistical();
    }
  }

  @override
  void dispose() {
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
              child: RefreshIndicator(
                  color: themeData.primaryColorLight,
                  backgroundColor: themeData.primaryColor,
                  onRefresh: () => _onRefresh(),
                  child: ListView.builder(
                    itemBuilder: (context, index){
                      FlowModel flow = flows[index];
                      return Column(children: <Widget>[
                        ListTile(
                        title: Row(children: <Widget>[
                          Text("${index+1}、", style: themeData.textTheme.title,),
                          Text("${flow.title}", style: themeData.textTheme.title,)
                        ],),
                        trailing: Text("${flow.count}人次", style: themeData.textTheme.title.copyWith(
                          color: Colors.amber
                        ),),
                      ),
                      Divider(height: 0.0)
                      ],);
                    },
                    itemCount: flows.length,
                  )
                ))
        ],
      );
  }
}