
import 'package:dio/dio.dart';
import 'package:kefu_workbench/models/work_order.dart';
import 'package:kefu_workbench/models/work_order_comment.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/services/workorder_service.dart';

import '../core_flutter.dart';

class WorkOrderDetailProvide with ChangeNotifier {

 WorkOrderService workOrderService = WorkOrderService.getInstance();
 
  static WorkOrderDetailProvide instance;

   // 单例
  static WorkOrderDetailProvide getInstance() {
    if (instance != null) {
      return instance;
    }
    instance = WorkOrderDetailProvide();
    return instance;
  }

   GlobalProvide globalState = GlobalProvide.getInstance();

   
  WorkOrderModel workOrder;
  List<WorkOrderCommentModel> workOrderComments = [];
  bool isUploadFail = false;
  bool isLoading = false;
  int uploadProgress = 0;
  String html = "";
  TextEditingController replyInputCtr = TextEditingController();
  ScrollController customScrollView = ScrollController();


    /// 选择图片
  void onPickFile(BuildContext context) async{
    File _file = await uploadImage<File>(context);
    if (_file == null) return;
    isUploadFail = false;
    notifyListeners();
    String url = await globalState.uploadFile(_file, onSendProgress: (int sent, int total){
      debugPrint("uploadProgress=${(sent / total * 100).ceil()}%");
      uploadProgress = (sent / total * 100).ceil();
      if(uploadProgress == 100) uploadProgress = 0;
      notifyListeners();
    },fail: (){
      isUploadFail = true;
      notifyListeners();
    });
    String suffix = url.substring(url.lastIndexOf(".") + 1);
    if ("jpg,jpeg,png,JPG,JPEG,PNG".contains(suffix)) {
      html =
          "<br><img style='max-width:45%;margin-top:5px;' preview='1' src='" +
              url +
              "' />";
    } else {
      html =
          "<br><img style='width:20px;height:20px;top:3px; right:3px;position: relative;' preview='1' src='http://qiniu.cmp520.com/fj.png' />";
      html += "<a target='_blank' style='color: #2e9dfc;' href='" +
          url +
          "'>下载附件</a>";
    }
    notifyListeners();
  }

  void uploadFile(){
  }

  // 回复
  void reply() async{
    String content = replyInputCtr.value.text + html;
    if (content.isEmpty) {
      UX.showToast("请输输入内容！");
      return;
    }
    Response response = await workOrderService.reply({
      "wid": workOrder.id,
      "content": content,
    });
    if (response.data['code'] == 200) {
      await getWorkOrder(workOrder.id, isLoading: false);
      await getWorkOrderComments(workOrder.id);
      replyInputCtr.clear();
      html = "";
      await Future.delayed(Duration(milliseconds: 500));
      customScrollView.animateTo(customScrollView.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }


  // 关闭工单
  void closeWorkOrder(BuildContext context) async{
    ThemeData themeData = Theme.of(context);
    String _content = "";
    UX.alert(
      context,
      title: "温馨提示！",
      confirmText: "关闭",
      isConfirmPop: false,
      content: Material(
        color: Colors.transparent,
        child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: ToPx.size(10)),
           child: Text("请输入关闭原因！"), 
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ToPx.size(10)),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: ToPx.size(1),color: Colors.grey.withAlpha(100)),
              borderRadius: BorderRadius.all(Radius.circular(ToPx.size(10))),
            ),
            child: TextFormField(
              onChanged: (String value){
                _content = value;
              },
              cursorColor: themeData.primaryColor,
              decoration: InputDecoration(
                hintText: "请输入关闭原因~",
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
          )
        ],
      ),
      ),
      onConfirm: () async{
        if(_content.isEmpty){
          UX.showToast("请输入关闭原因~");
          return;
        }
        Response response = await workOrderService.close({
          "wid": workOrder.id,
          "remark": _content,
        });
        if (response.data['code'] == 200) {
          UX.showToast("工单已关闭");
          Navigator.pop(context);
          await getWorkOrder(workOrder.id, isLoading: false);
        }else{
          UX.showToast("${response.data["message"]}");
        }
      }
    );
  }

  // 删除工单
  void deleteWorkOrder(BuildContext context) async{
    UX.alert(
      context,
      title: "温馨提示！",
      confirmText: "删除",
      isConfirmPop: false,
      content: "您确定要删除该工单吗？",
      onConfirm: () async{
        Response response = await workOrderService.delWorkOrder(workOrder.id);
        if (response.data['code'] == 200) {
          UX.showToast("工单删除成功~");
          Navigator.pop(context);
          await getWorkOrder(workOrder.id, isLoading: false);
        }else{
          UX.showToast("${response.data["message"]}");
        }
      }
    );
  }

  // 获取工单
  Future<void> getWorkOrder(int id, {bool isLoading = true}) async{
    if(this.isLoading || id == null) return;
    this.isLoading = isLoading;
    notifyListeners();
    Response response = await workOrderService.getWorkOrder(id);
    if (response.data["code"] == 200) {
      workOrder = WorkOrderModel.fromJson(response.data['data']);
      this.isLoading = false;
      notifyListeners();
    } else {
      UX.showToast("${response.data["message"]}");
    }
  }

    // 获取工单coments
  Future<void> getWorkOrderComments(int id) async{
    if(id == null) return;
    Response response = await workOrderService.getWorkOrderComments(id);
    if (response.data["code"] == 200) {
      workOrderComments = (response.data['data'] as List)
          .map((i) => WorkOrderCommentModel.fromJson(i))
          .toList();
      notifyListeners();
    } else {
      UX.showToast("${response.data["message"]}");
    }
  }


  @override
  void dispose() {
    instance = null;
    replyInputCtr?.dispose();
    customScrollView?.dispose();
    super.dispose();
  }

  
}
