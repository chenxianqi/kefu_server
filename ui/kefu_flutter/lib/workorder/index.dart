import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kefu_flutter/models/work_order.dart';
import 'package:kefu_flutter/models/work_order_type.dart';
import 'package:kefu_flutter/utils/im_utils.dart';

import '../kefu_flutter.dart';
import 'create.dart';
import 'detail.dart';

class WorkOrder extends StatefulWidget {
  @override
  _WorkOrderState createState() => _WorkOrderState();
}

class _WorkOrderState extends State<WorkOrder> {
  KeFuStore keFuStore;
  List<WorkOrderModel> workOrders = [];
  List<WorkOrderTypeModel> get workOrderTypes {
    try {
      return keFuStore.workOrderTypes;
    } catch (_) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      keFuStore = KeFuStore.getInstance;
      if (keFuStore.workOrderTypes.length == 0) {
        keFuStore.getWorkOrderTypes();
      }
      _initData();
    }
  }

  // init data
  void _initData() async {
    await _getWorkOrders();
  }

  // GET workorders
  Future<void> _getWorkOrders() async {
    if (keFuStore == null) {
      debugPrint("keFuStore is not instance");
      return;
    }
    Response res = await keFuStore.http.get('/public/workorders');
    if (res.data['code'] == 200) {
      workOrders = (res.data['data'] as List)
          .map((i) => WorkOrderModel.fromJson(i))
          .toList();
      setState(() {});
    }
  }

  // _goToCreateWprkOrder
  void _goToCreateWprkOrder(BuildContext context) {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreateWorkOrder()))
        .then((_) {
      _getWorkOrders();
    });
  }

  // _goToWprkOrderDetail
  void _goToWprkOrderDetail(BuildContext context, int wid) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => WorkOrderDetail(wid)))
        .then((_) {
      _getWorkOrders();
    });
  }

  String _getTypeTitle(int tid) {
    return workOrderTypes.where((item) => item.id == tid).first.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("我的工单"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "创建工单",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _goToCreateWprkOrder(context),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          workOrders.length <= 0
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.library_books,
                          color: Colors.black26,
                          size: 50,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            "暂无相关数据~",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((ctx, index) {
                  var workOrder = workOrders[index];
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () =>
                            _goToWprkOrderDetail(context, workOrder.id),
                        title: DefaultTextStyle(
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black87.withAlpha(180)),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.library_books,
                                  color: Colors.black26,
                                  size: 25,
                                ),
                                VerticalDivider(
                                    width: 5.0, color: Colors.transparent),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "${workOrder.title}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      DefaultTextStyle(
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 12.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                  "${_getTypeTitle(workOrder.tid)} "),
                                              Text(
                                                  " ${ImUtils.formatDate(workOrder.createAt, isformatFull: true)}"),
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.transparent,
                                  width: 10.0,
                                ),
                                Text(
                                  workOrder.status == 1
                                      ? "已回复"
                                      : workOrder.status == 3
                                          ? "已结束"
                                          : workOrder.status == 0
                                              ? "待处理"
                                              : workOrder.status == 2
                                                  ? "待回复"
                                                  : "未知状态",
                                  style: TextStyle(
                                      color: workOrder.status == 1
                                          ? Color(0XFF8bc34a)
                                          : workOrder.status == 3
                                              ? Color(0XFFcccCCC)
                                              : workOrder.status == 0
                                                  ? Color(0XFFFF9800)
                                                  : workOrder.status == 2
                                                      ? Color(0XFFFF9800)
                                                      : Colors.amber,
                                      fontSize: 12.0),
                                )
                              ],
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(
                          height: 0.5,
                        ),
                      )
                    ],
                  );
                }, childCount: workOrders.length))
        ],
      ),
    );
  }
}
