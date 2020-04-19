import 'package:dio/dio.dart';
import 'package:kefu_workbench/models/work_order_type.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/services/system_service.dart';
import 'package:kefu_workbench/services/workorder_service.dart';

import '../core_flutter.dart';

class WorkOrderSettingProvide with ChangeNotifier {
  static WorkOrderSettingProvide instance;

  WorkOrderService workOrderService = WorkOrderService.getInstance();
  TextEditingController textEditingController = TextEditingController();

  // 单例
  static WorkOrderSettingProvide getInstance() {
    if (instance != null) {
      return instance;
    }
    instance = WorkOrderSettingProvide();
    return instance;
  }
  
  GlobalProvide globalProvide = GlobalProvide.getInstance();

  WorkOrderSettingProvide() {
    _init();
  }

  void _init() async{
    globalProvide.getWorkorderTypes();
    this.isOpenWorkorder = globalProvide.imConfigs.openWorkorder == 1;
  }

  List<WorkOrderTypeModel>  workorderTypes;
  bool isOpenWorkorder = false;
  bool isLoading = false;

  List<WorkOrderTypeModel> get getWorkorderTypes{
    return globalProvide.workOrderTypes.sublist(1, globalProvide.workOrderTypes.length - 2);
  }

  Widget _formWidget(BuildContext context, {String value = "", Function(String) onChanged, String hintText = ""}){
    ThemeData themeData = Theme.of(context);
    textEditingController.text = value;
    return Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: ToPx.size(10)),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: ToPx.size(1),color: Colors.grey.withAlpha(100)),
            borderRadius: BorderRadius.all(Radius.circular(ToPx.size(10))),
          ),
          child: TextFormField(
            onChanged: onChanged,
            controller: textEditingController,
            cursorColor: themeData.primaryColor,
              decoration: InputDecoration(
                hintText: "$hintText",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: ToPx.size(28),
                  color: Colors.grey.withAlpha(150),
                ),
                counterStyle: TextStyle(
                    color: Colors.grey.withAlpha(200)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 3.0),
                counterText: ""),
                style: TextStyle(
                  color: Colors.black87.withAlpha(180),
                ),
            ),
          ),
      );
  }

  // 添加工单
  void createWorkOrder(BuildContext context) async{
    String _content = "";
    UX.alert(
      context,
      title: "温馨提示！",
      confirmText: "提交",
      isConfirmPop: false,
      content: _formWidget(context, onChanged: (value)=>_content = value, hintText: "请输入类型名称~"),
      onConfirm: () async{
        if(_content.isEmpty){
          UX.showToast("请输入类型名称~");
          return;
        }
        Response response = await workOrderService.addType({
          "title": _content,
        });
        if (response.data['code'] == 200) {
          Navigator.pop(context);
          globalProvide.getWorkorderTypes();
        }else{
          UX.showToast("${response.data["message"]}");
        }
      }
    );
  }

  void setOpenWorkorder(BuildContext context, bool isSwitch){
    String title = "您确定打开工单功能吗？";
    int openWorkorder = 1;
     if(!isSwitch){
        title = "您确定关闭工单功能吗？";
        openWorkorder = 0;
      }
    UX.alert(
      context,
      title: "温馨提示！",
      confirmText: "提交",
      isConfirmPop: false,
      content: title,
      onCancel: (){
        this.isOpenWorkorder = !isSwitch;
        notifyListeners();
      },
      onConfirm: () async{
        Response response = await SystemService.getInstance().toggleOpenWorkorder(openWorkorder);
        if (response.data['code'] == 200) {
          Navigator.pop(context);
          globalProvide.getConfigs();
           this.isOpenWorkorder = isSwitch;
           if(isSwitch){
             UX.showToast("工单单功已启动");
           }else{
             UX.showToast("工单功能已关闭");
           }
           notifyListeners();
        }else{
          UX.showToast("${response.data["message"]}");
          this.isOpenWorkorder = !isSwitch;
          notifyListeners();
        }
      }
    );
  }

  void operating(BuildContext context, WorkOrderTypeModel workOrderType) async{
    ThemeData themeData = Theme.of(context);
    WorkOrderTypeModel _workOrderType = WorkOrderTypeModel.fromJson(workOrderType.toJson());
    int index = await showCupertinoModalPopup(
      context: context,
      builder: (_){
        return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('修改', style: themeData.textTheme.body2),
                onPressed: () {
                  Navigator.pop(context, 0);
                },
              ),
              CupertinoActionSheetAction(
                child: Text('删除', style: themeData.textTheme.body2),
                onPressed: () {
                  Navigator.pop(context, 1);
                },
              ),
            ],
            cancelButton: SizedBox(
              child: CupertinoActionSheetAction(
                isDestructiveAction: true,
                child: Text('取消', style: themeData.textTheme.body2),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            )
        );
      }
    );
    if(index == 0){
      UX.alert(
        context,
        title: "温馨提示！",
        confirmText: "更新",
        isConfirmPop: false,
        content: _formWidget(context, value: _workOrderType.title, onChanged: (value)=>_workOrderType.title = value, hintText: "请输入类型名称~"),
        onConfirm: () async{
          if(workOrderType.title == _workOrderType.title) {
             Navigator.pop(context);
            return;
          }
          if(_workOrderType.title.isEmpty){
            UX.showToast("请输入类型名称~");
            return;
          }
          Response response = await workOrderService.updateType(_workOrderType.toJson());
          if (response.data['code'] == 200) {
            Navigator.pop(context);
            globalProvide.getWorkorderTypes();
            UX.showToast("更新成功~");
          }else{
            UX.showToast("${response.data["message"]}");
          }
        }
      );
    }else if(index == 1){
      UX.alert(
        context,
        title: "温馨提示！",
        content: "您确定要删除该分类吗？",
        onConfirm: () async{
          Response response = await workOrderService.delype(_workOrderType.id);
          if (response.data['code'] == 200) {
            globalProvide.getWorkorderTypes();
          }else{
            UX.showToast("${response.data["message"]}");
          }
        }
      );
    }
  }

   @override
  void dispose() {
    instance = null;
    textEditingController?.dispose();
    super.dispose();
  }


}
