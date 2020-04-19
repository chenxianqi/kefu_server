import 'package:dio/dio.dart';
import 'package:kefu_workbench/models/work_order.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/services/workorder_service.dart';

import '../core_flutter.dart';

class WorkOrderProvide with ChangeNotifier {
  static WorkOrderProvide instance;

  WorkOrderService workOrderService = WorkOrderService.getInstance();

  // 单例
  static WorkOrderProvide getInstance() {
    if (instance != null) {
      return instance;
    }
    instance = WorkOrderProvide();
    return instance;
  }
  
  GlobalProvide globalProvide = GlobalProvide.getInstance();

  WorkOrderProvide() {
    _init();
  }
  void _init() async{
    await getWorkOrders(pageOn: 1);
  }
  bool isLoadEnd = false;
  bool isLoading = false;
  Map<String, dynamic> workOrderRequest = {
    "del": 0,
    "page_on": 0,
    "page_size": 15,
    "status": "0,1,2",
    "tid": 0
  };
  Map<int,List<WorkOrderModel>> workOrdersMap = {};
  List<WorkOrderModel> getWorkOrder(int tid){
    try{
      return workOrdersMap[tid] ?? [];
    }catch(_){
      return [];
    }
  }
  int workOrdersTotal = 0;
  int tabControllerIndex = 0;
  void changeTabControllerIndex(int index){
    tabControllerIndex = index;
    isLoadEnd = false;
    // workOrdersMap[tid] = [];
    notifyListeners();
  }
  String get workOrderRequestStatus{
    if(tabControllerIndex == globalProvide.workOrderTypes.length-1 && globalProvide.workOrderTypes.length > 1){
        return '0,1,2,3';
      }
      if(tabControllerIndex == globalProvide.workOrderTypes.length-2 && globalProvide.workOrderTypes.length > 1){
        return '3';
      }
      return "0,1,2";
  }

  // 获取工单列表
  Future<void> getWorkOrders({int pageOn = 1}) async {
    if(this.isLoadEnd || this.isLoading) return;
    workOrderRequest["page_on"] = pageOn;
    var tid = globalProvide.workOrderTypes[tabControllerIndex].id;
    workOrderRequest["tid"] = tid;
    workOrderRequest['status'] = this.workOrderRequestStatus;
    workOrderRequest['del'] = tid == -2 ? 1 : 0;
    this.isLoading = true;
    notifyListeners();
    Response response = await workOrderService.getWorkOrders(workOrderRequest);
    if (response.data["code"] == 200) {
      List<WorkOrderModel> _workOrders = (response.data["data"]['list'] as List).map((i) => WorkOrderModel.fromJson(i)).toList();
      workOrdersTotal = response.data["data"]['total'];
      if(_workOrders.length < workOrderRequest["page_size"]){
        isLoadEnd = true;
      }
      if(pageOn > 1){
        workOrdersMap[tid].addAll(_workOrders);
      }else{
        workOrdersMap[tid] = [];
        workOrdersMap[tid] = _workOrders;
      }
      await Future.delayed(Duration(milliseconds: 500));
      this.isLoading = false;
      notifyListeners();
    } else {
      UX.showToast("${response.data["message"]}");
    }
  }

   

  @override
  void dispose() {
    instance = null;
    super.dispose();
  }
}
