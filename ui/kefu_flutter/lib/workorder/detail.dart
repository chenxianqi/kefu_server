import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_html/image_properties.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kefu_flutter/models/work_order.dart';
import 'package:kefu_flutter/models/work_order_comment.dart';
import 'package:kefu_flutter/models/work_order_type.dart';
import 'package:kefu_flutter/utils/im_utils.dart';
import 'package:kefu_flutter/widgets/cached_network_image.dart';
import 'package:kefu_flutter/widgets/im_avatar.dart';
import 'package:flutter_html/flutter_html.dart';
import '../kefu_flutter.dart';

class WorkOrderDetail extends StatefulWidget {
  WorkOrderDetail(this.wid);
  final int wid;
  @override
  _WorkOrderDetailState createState() => _WorkOrderDetailState();
}

class _WorkOrderDetailState extends State<WorkOrderDetail> {
  KeFuStore keFuStore;
  WorkOrderModel workOrder;
  List<WorkOrderCommentModel> workOrderComments = [];
  List<WorkOrderTypeModel> get workOrderTypes {
    try {
      return keFuStore.workOrderTypes;
    } catch (_) {
      return [];
    }
  }

  ScrollController scrollController = ScrollController();
  TextEditingController _replyInputCtr = TextEditingController();
  int uploadProgress = 0;
  bool isUploadFail = false;
  String html = "";

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

  @override
  void dispose() {
    _replyInputCtr.dispose();
    super.dispose();
  }

  // init data
  void _initData() async {
    await _getWorkOrder();
    await _getWorkOrderComments();
  }

  // GET workorder
  Future<void> _getWorkOrder() async {
    if (keFuStore == null) {
      debugPrint("keFuStore is not instance");
      return;
    }
    Response res =
        await keFuStore.http.get('/public/workorder/' + widget.wid.toString());
    if (res.data['code'] == 200) {
      workOrder = WorkOrderModel.fromJson(res.data['data']);
      setState(() {});
    }
  }

  // close workorder
  Future<void> _close() async {
    if (keFuStore == null) {
      debugPrint("keFuStore is not instance");
      return;
    }
    ImUtils.alert(context, content: "您确定关闭该工单吗?", onConfirm: () async {
      Response res = await keFuStore.http
          .put('/public/workorder/close/' + widget.wid.toString());
      if (res.data['code'] == 200) {
        ImUtils.alert(context, isShowCancel: false, content: "工单已关闭~");
        await _getWorkOrder();
        await _getWorkOrderComments();
      }
    });
  }

  // reply
  Future<void> _reply() async {
    if (keFuStore == null) {
      debugPrint("keFuStore is not instance");
      return;
    }
    String content = _replyInputCtr.value.text + html;
    if (content.isEmpty) {
      ImUtils.alert(context, isShowCancel: false, content: "请输输入内容！");
      return;
    }
    Response res = await keFuStore.http.post('/public/workorder/reply', data: {
      "wid": workOrder.id,
      "content": content,
    });
    if (res.data['code'] == 200) {
      await _getWorkOrder();
      await _getWorkOrderComments();
      _replyInputCtr.clear();
      FocusScope.of(context).requestFocus(FocusNode());
      html = "";
      setState(() {});
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _uploadFile() async {
    setState(() {
      isUploadFail = false;
    });
    int index = await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text(
                    '拍照',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context, 1);
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    '从手机选择照片',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context, 2);
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    '其它文件',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context, 3);
                  },
                ),
              ],
              cancelButton: SizedBox(
                child: CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  child: Text(
                    '取消',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                ),
              ));
        });
    File _file;
    if (index == 1) {
      _file = await ImagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 2000);
    } else if (index == 2) {
      _file = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 2000);
    } else if (index == 3) {
      _file = await FilePicker.getFile();
    }
    if (_file == null) return;
    keFuStore?.uploadFile(_file, onSendProgress: (int sent, int total) {
      debugPrint("uploadProgress=${(sent / total * 100).ceil()}%");
      setState(() {
        uploadProgress = (sent / total * 100).ceil();
      });
    }, fail: () {
      setState(() {
        isUploadFail = true;
        html = "";
        uploadProgress = 0;
      });
    }, success: (String url) {
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
      setState(() {
        isUploadFail = false;
        uploadProgress = 0;
      });
    });
  }

  // GET workorderComments
  Future<void> _getWorkOrderComments() async {
    if (keFuStore == null) {
      debugPrint("keFuStore is not instance");
      return;
    }
    Response res = await keFuStore.http
        .get('/public/workorder/comments/' + widget.wid.toString());
    if (res.data['code'] == 200 && res.data['data'] is List) {
      workOrderComments = (res.data['data'] as List)
          .map((i) => WorkOrderCommentModel.fromJson(i))
          .toList();
      setState(() {});
    }
  }

  String _getTypeTitle(int tid) {
    return workOrderTypes.where((item) => item.id == tid).first.title;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Widget _html(String data) {
      bool isShowimage = data.contains(">下载附件</a>");
      return Html(
        data: "$data",
        showImages: !isShowimage,
        imageProperties: ImageProperties(height: 100.0),
        onLinkTap: (String link) {
          Clipboard.setData(ClipboardData(text: link));
          ImUtils.alert(context, content: "附件下载链接已复制到粘贴板", isShowCancel: false);
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
                  child: CachedImage(
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

    Widget _lineBox({String label, dynamic content, Color contentColor}) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: DefaultTextStyle(
            style:
                TextStyle(color: Colors.black87.withAlpha(180), fontSize: 15.0),
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
        padding: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Divider(
                height: 0.5,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: comment.aid == 0
                        ? ImAvatar(
                            avatar: comment.uAvatar.isNotEmpty
                                ? comment.uAvatar
                                : "http://qiniu.cmp520.com/avatar_degault_3.png",
                          )
                        : ImAvatar(
                            avatar: comment.aAvatar.isNotEmpty
                                ? comment.aAvatar
                                : "http://qiniu.cmp520.com/avatar_degault_3.png",
                          )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(comment.aid != 0 ? "${comment.aNickname}" : "我",
                          style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.black87.withAlpha(180))),
                      Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: _html(comment.content)),
                      Text(
                        "${ImUtils.formatDate(comment.createAt, isformatFull: true)}",
                        style: TextStyle(fontSize: 13.0, color: Colors.grey),
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(
                          color: themeData.dividerColor, width: 0.5))),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: isUploadFail
                  ? Text("上传失败了~",
                      style: TextStyle(fontSize: 12.0, color: Colors.grey))
                  : uploadProgress > 0
                      ? Text(
                          "文件上传中$uploadProgress%...",
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        )
                      : Offstage(
                          offstage: html.isEmpty,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.attach_file,
                                size: 15.0,
                                color: Colors.grey,
                              ),
                              Text(
                                "你已成功添加附件，重新上传可替换~",
                                style: TextStyle(
                                    fontSize: 12.0, color: Color(0XFF8bc34a)),
                              )
                            ],
                          ),
                        )),
          Container(
            height: 80.0,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top:
                        BorderSide(color: themeData.dividerColor, width: 0.5))),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        cursorColor: themeData.primaryColor,
                        controller: _replyInputCtr,
                        decoration: InputDecoration(
                            hintText: "请输入内容~",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey.withAlpha(150),
                            ),
                            counterStyle:
                                TextStyle(color: Colors.grey.withAlpha(200)),
                            contentPadding: EdgeInsets.symmetric(vertical: 3.0),
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
                      height: 79.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.cloud_upload,
                              size: 35.0,
                              color: Colors.black87.withAlpha(50),
                            ),
                            onPressed: _uploadFile,
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          SizedBox(
                            width: 70.0,
                            height: 35.0,
                            child: RaisedButton(
                                color: themeData.primaryColor,
                                onPressed: _reply,
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
      return SizedBox(
        width: 30.0,
        height: 30.0,
        child: Platform.isAndroid
            ? CircularProgressIndicator(
                strokeWidth: 2.0,
              )
            : CupertinoActivityIndicator(
                radius: 15.0,
              ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("工单详情"),
          actions: <Widget>[
            Offstage(
              offstage: workOrder != null && workOrder.status == 3,
              child: FlatButton(
                child: Text(
                  "关闭工单",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _close,
              ),
            )
          ],
        ),
        body: workOrder == null
            ? Center(child: _loading())
            : Column(
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: CustomScrollView(
                            controller: scrollController,
                            slivers: <Widget>[
                              SliverToBoxAdapter(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    _lineBox(
                                        label: "标题：",
                                        content: "${workOrder.title}"),
                                    _lineBox(
                                        label: "内容：",
                                        content: _html(workOrder.content)),
                                    _lineBox(
                                        label: "电话：",
                                        content: "${workOrder.phone}"),
                                    _lineBox(
                                        label: "邮箱：",
                                        content: "${workOrder.email}"),
                                    _lineBox(
                                        label: "时间：",
                                        content:
                                            "${ImUtils.formatDate(workOrder.createAt, isformatFull: true)}"),
                                    _lineBox(
                                        label: "类型：",
                                        content:
                                            "${_getTypeTitle(workOrder.tid)}"),
                                    _lineBox(
                                        label: "状态：",
                                        content: workOrder.status == 1
                                            ? "已回复"
                                            : workOrder.status == 3
                                                ? "已结束"
                                                : workOrder.status == 0
                                                    ? "待处理"
                                                    : workOrder.status == 2
                                                        ? "待回复"
                                                        : "未知状态",
                                        contentColor: workOrder.status == 1
                                            ? Color(0XFF8bc34a)
                                            : workOrder.status == 3
                                                ? Color(0XFFcccCCC)
                                                : workOrder.status == 0
                                                    ? Color(0XFFFF9800)
                                                    : workOrder.status == 2
                                                        ? Color(0XFFFF9800)
                                                        : null),
                                  ],
                                ),
                              ),
                              workOrderComments.length == 0
                                  ? SliverToBoxAdapter(
                                      child: Column(
                                        children: <Widget>[
                                          Divider(),
                                          Text(
                                            "暂无回复内容,请您耐心等待~",
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
                                      var comment = workOrderComments[index];
                                      return _conment(comment);
                                    }, childCount: workOrderComments.length))
                            ],
                          ))),
                  Offstage(
                    offstage: workOrder.status == 3,
                    child: _inputForm(),
                  )
                ],
              ));
  }
}
