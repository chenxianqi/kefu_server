import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/image_properties.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/models/work_order.dart';
import 'package:kefu_workbench/models/work_order_comment.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/provider/workorder_detail.dart';
import 'package:provider/provider.dart';

class WorkOrderDetailPage extends StatefulWidget {
  final Map<dynamic, dynamic> arguments;
  WorkOrderDetailPage({this.arguments});
  @override
  State<StatefulWidget> createState() {
    return _WorkOrderDetailPageState();
  }
}

class _WorkOrderDetailPageState extends State<WorkOrderDetailPage> {

  GlobalProvide globalProvide = GlobalProvide.getInstance();
  WorkOrderDetailProvide workOrderDetailProvide = WorkOrderDetailProvide.getInstance();
  WorkOrderModel _workOrder;

  String _getTypeTitle(int tid) {
    return globalProvide.workOrderTypes.where((item) => item.id == tid).first.title;
  }

  @override
  void initState() {
    super.initState();
    _workOrder = widget.arguments['workOrder'];
    workOrderDetailProvide.getWorkOrder(_workOrder.id);
    workOrderDetailProvide.getWorkOrderComments(_workOrder.id);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(_) {
    return ChangeNotifierProvider<WorkOrderDetailProvide>(
        create: (_) => workOrderDetailProvide,
        child: Consumer<WorkOrderDetailProvide>(
            builder: (context, workorderDetailState, ___) {
          return PageContext(builder: (context) {
            ThemeData themeData = Theme.of(context);
            var workOrder = workorderDetailState.workOrder ?? _workOrder;
            Widget _html(String data) {
              bool isShowimage = data.contains(">下载附件</a>");
              return Html(
                data: "$data",
                showImages: !isShowimage,
                imageProperties: ImageProperties(height: ToPx.size(250)),
                onLinkTap: (String link) {
                  Clipboard.setData(ClipboardData(text: link));
                  UX.alert(context, content: "附件下载链接已复制到粘贴板");
                },
                onImageTap: (String img) {
                  if (img == null || img.isEmpty) return;
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                            child: ZoomableWidget(
                          onTap: () => Navigator.pop(context),
                          maxScale: 2.0,
                          minScale: 0.5,
                          child: CachedNetworkImage(
                              width: MediaQuery.of(context).size.width / 1,
                              height: MediaQuery.of(context).size.height / 1,
                              src: img,
                              bgColor: Colors.transparent,
                              fit: BoxFit.fitWidth),
                        ));
                      });
                },
              );
            }

            Widget _lineBox(
                {String label, dynamic content, Color contentColor}) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: ToPx.size(20), vertical: ToPx.size(10)),
                child: DefaultTextStyle(
                    style: themeData.textTheme.title,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("$label"),
                        Expanded(
                            child: content is String
                                ? Text(
                                    "$content",
                                    style: TextStyle(color: contentColor),
                                  )
                                : content is Widget ? content : Text("")),
                      ],
                    )),
              );
            }

            Widget _conment(WorkOrderCommentModel comment) {
              return Container(
                padding: EdgeInsets.only(bottom: ToPx.size(20)),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ToPx.size(20)),
                      child: Divider(
                        height: 0.5,
                      ),
                    ),
                    SizedBox(
                      height: ToPx.size(20),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ToPx.size(20), vertical: ToPx.size(10)),
                            child: comment.aid == 0
                                ? Avatar(
                                    imgUrl: comment.uAvatar.isNotEmpty
                                        ? comment.uAvatar
                                        : "http://qiniu.cmp520.com/avatar_degault_3.png",
                                  )
                                : Avatar(
                                    imgUrl: comment.aAvatar.isNotEmpty
                                        ? comment.aAvatar
                                        : "http://qiniu.cmp520.com/avatar_degault_3.png",
                                  )),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  comment.aid == 0
                                      ? "${comment.uNickname}"
                                      : "${comment.aNickname}",
                                  style: themeData.textTheme.body1),
                              Padding(
                                  padding: EdgeInsets.only(bottom: ToPx.size(10)),
                                  child: _html(comment.content)),
                              Text(
                                "${Utils.formatDate(comment.createAt, isformatFull: true)}",
                                style: themeData.textTheme.caption
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }

            Widget _inputForm() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(
                                  color: themeData.dividerColor, width: ToPx.size(10)))),
                      padding: EdgeInsets.symmetric(horizontal: ToPx.size(20)),
                      child: workorderDetailState.isUploadFail
                          ? Text("上传失败了~",
                              style: themeData.textTheme.caption)
                          : workorderDetailState.uploadProgress > 0 && workorderDetailState.uploadProgress < 100
                          ? Text(
                              "文件上传中${workorderDetailState.uploadProgress}%...",
                              style: themeData.textTheme.caption.copyWith(
                                color: Colors.grey
                              )
                            )
                          : Offstage(
                              offstage: workorderDetailState.html.isEmpty,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.attach_file,
                                    size: 15.0,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "你已成功添加附件，重新上传可替换~",
                                    style: themeData.textTheme.caption.copyWith(
                                      color:  Color(0XFF8bc34a)
                                    ))
                                ],
                              ),
                            )),
                  Container(
                    height: ToPx.size(150),
                    padding: EdgeInsets.symmetric(horizontal: ToPx.size(15)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top: BorderSide(
                                color: themeData.dividerColor, width: ToPx.size(1)))),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                cursorColor: themeData.primaryColor,
                                controller: workorderDetailState.replyInputCtr,
                                decoration: InputDecoration(
                                    hintText: "请输入内容~",
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
                                  fontSize: 15.0,
                                ),
                                minLines: 1,
                                maxLines: 3,
                              ),
                            ),
                            SizedBox(
                              height: ToPx.size(143),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.cloud_upload,
                                      size: ToPx.size(60),
                                      color: Colors.black87.withAlpha(50),
                                    ),
                                    onPressed: () => workorderDetailState.onPickFile(context),
                                  ),
                                  SizedBox(
                                    width: ToPx.size(25),
                                  ),
                                  SizedBox(
                                    width: ToPx.size(145),
                                    height: ToPx.size(65),
                                    child: RaisedButton(
                                        color: themeData.primaryColor,
                                        onPressed: workorderDetailState.reply,
                                        child: Text(
                                          "提交",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            }

            Widget _loading() {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                width: ToPx.size(30),
                height: ToPx.size(30),
                child: Platform.isAndroid
                    ? CircularProgressIndicator(
                        strokeWidth: 2.0,
                      )
                    : CupertinoActivityIndicator(
                        radius: 15.0,
                      )),
                      Text("\r\n加载中...", style: themeData.textTheme.caption,)
                ]
              ),
              );
            }

            return Scaffold(
                backgroundColor: Colors.white,
                appBar: customAppBar(
                    title: Text(
                      "工单详情",
                      style: themeData.textTheme.display1,
                    ),
                    actions: [
                      Offstage(
                        offstage: workOrder.status == 3 || workOrder.delete == 1,
                        child: Button(
                        height: ToPx.size(90),
                        useIosStyle: true,
                        color: Colors.transparent,
                        width: ToPx.size(150),
                        child: Text("关闭工单"),
                        onPressed: ()=>workorderDetailState.closeWorkOrder(context)),
                      ),
                      Offstage(
                        offstage: workOrder.status != 3 || workOrder.delete == 1,
                        child: Button(
                        height: ToPx.size(90),
                        useIosStyle: true,
                        color: Colors.transparent,
                        width: ToPx.size(150),
                        child: Text("删除工单"),
                        onPressed: ()=>workorderDetailState.deleteWorkOrder(context)),
                      )
                    ]),
                body: workorderDetailState.isLoading ?
                _loading() :
                Column(
                  children: <Widget>[
                    Expanded(
                        child: RefreshIndicator(
                        color: themeData.primaryColorLight,
                        backgroundColor: themeData.primaryColor,
                        onRefresh: () async{
                         await workOrderDetailProvide.getWorkOrder(_workOrder.id, isLoading: false);
                         await workOrderDetailProvide.getWorkOrderComments(_workOrder.id);
                          return true;
                        },
                        child: CustomScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          controller: workorderDetailState.customScrollView,
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Column(
                            children: <Widget>[
                            SizedBox(height: 10.0),
                            _lineBox(
                              label: "用户：",
                              content: "${workOrder.uNickname}"),
                            _lineBox(
                                label: "标题：",
                                content: "${workOrder.title}"),
                            _lineBox(
                                label: "内容：",
                                content: _html("${workOrder.content}")),
                            _lineBox(
                                label: "电话：",
                                content: "${workOrder.phone}"),
                            _lineBox(
                                label: "邮箱：",
                                content: "${workOrder.email.isEmpty ? '未提供邮箱' : workOrder.email}"),
                            _lineBox(
                                label: "时间：",
                                content: "${Utils.formatDate(workOrder.createAt, isformatFull: true)}"),
                            _lineBox(
                                label: "类型：",
                                content:"${_getTypeTitle(workOrder.tid)}"),
                            _lineBox(
                              label: "状态：",
                              content: Text(
                                workOrder.status == 2 ? "已回复" :
                                workOrder.status == 3 ? "已结束" : 
                                workOrder.status == 0 ? "待处理" : 
                                workOrder.status == 1 ? "待回复" : "未知状态",
                                style: TextStyle(
                                color: workOrder.status == 2 ? Color(0XFF8bc34a) : 
                                workOrder.status == 3 ? Color(0XFFcccCCC) : 
                                workOrder.status == 0 ? Color(0XFFFF9800) : 
                                workOrder.status == 1 ? Color(0XFFFF9800) : Colors.amber),
                              )),
                            ],
                          ),
                        ),
                        workorderDetailState.workOrderComments.length == 0
                        ? SliverToBoxAdapter(
                            child: Column(
                              children: <Widget>[
                                Divider(),
                                Text(
                                  "暂无回复内容~",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey),
                                ),
                                SizedBox(height: 50.0)
                              ],
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (ctx, index) {
                            var comment = workorderDetailState.workOrderComments[index];
                            return _conment(comment);
                          }, childCount: workorderDetailState.workOrderComments.length)),
                        SliverToBoxAdapter(
                          child: Offstage(
                            offstage: workOrder.status != 3,
                            child: Column(
                            children: <Widget>[
                              Divider(),
                              Text(
                                "工单已结束~",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey),
                              ),
                              SizedBox(height: 50.0)
                            ],
                          ),
                          ),
                        ),
                      ],
                    ))),
                     Offstage(
                       offstage: workOrder.status == 3,
                       child: _inputForm(),
                     )
                  ],
                ));
          });
        }));
  }
}
