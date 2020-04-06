import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kefu_flutter/models/work_order.dart';
import 'package:kefu_flutter/models/work_order_type.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kefu_flutter/utils/im_utils.dart';

import '../kefu_flutter.dart';

class CreateWorkOrder extends StatefulWidget {
  @override
  _CreateWorkOrderState createState() => _CreateWorkOrderState();
}

class _CreateWorkOrderState extends State<CreateWorkOrder> {
  KeFuStore keFuStore;
  WorkOrderModel request = WorkOrderModel();
  int selectTypeIndex = 0;
  List<WorkOrderTypeModel> get workOrderTypes {
    try {
      return keFuStore.workOrderTypes;
    } catch (_) {
      return [];
    }
  }

  int uploadProgress = 0;
  String html = "";
  bool isUploadFail = false;

  TextEditingController _titleCtr = TextEditingController();
  TextEditingController _phoneCtr = TextEditingController();
  TextEditingController _emailCtr = TextEditingController();
  TextEditingController _contentCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      keFuStore = KeFuStore.getInstance;
      if (keFuStore.workOrderTypes.length == 0) {
        keFuStore.getWorkOrderTypes();
      }
    }
  }

  @override
  void dispose() {
    _titleCtr.dispose();
    _phoneCtr.dispose();
    _emailCtr.dispose();
    _contentCtr.dispose();
    super.dispose();
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

  void _save() async {
    request.title = _titleCtr.value.text;
    request.phone = _phoneCtr.value.text;
    request.email = _emailCtr.value.text;
    request.content = _contentCtr.value.text;
    if (request.tid == null) {
      ImUtils.alert(context,
          cancelText: "关闭", isShowCancel: false, content: "请选择工单类型！");
      return;
    }
    if (request.title.isEmpty) {
      ImUtils.alert(context,
          cancelText: "关闭", isShowCancel: false, content: "请输入工单标题！");
      return;
    }
    if (request.phone.isEmpty) {
      ImUtils.alert(context,
          cancelText: "关闭", isShowCancel: false, content: "请输入手机号！");
      return;
    }
    if (request.content.isEmpty) {
      ImUtils.alert(context,
          cancelText: "关闭", isShowCancel: false, content: "请输入工单内容！");
      return;
    }
    request.content += html;
    var requestJson = request.toJson();
    requestJson.removeWhere((key, value) {
      return value == null;
    });
    try {
      Response res = await keFuStore.http
          .post("/public/workorder/create", data: request.toJson());
      print(res.data.toString());
      if (res.data['code'] == 200) {
        ImUtils.alert(context,
            isShowCancel: false,
            onConfirm: () => Navigator.pop(context),
            content: "工单提交成功~");
      }
    } on DioError catch (e) {
      ImUtils.alert(context,
          cancelText: "关闭",
          isShowCancel: false,
          content: e.response.data["message"]);
    }
  }

  void _onSelectType() {
    ThemeData themeData = Theme.of(context);
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: selectTypeIndex);
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        barrierColor: Color.fromRGBO(0, 0, 0, 0.5),
        barrierDismissible: false,
        barrierLabel: 'route',
        maintainState: false,
        pageBuilder: (___, _, __) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              child: SizedBox(
                height: 280.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 45.0,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "选择工单类型",
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.black54),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              request.tid = workOrderTypes[selectTypeIndex].id;
                              setState(() {});
                            },
                            child: Text("确定",
                                style: TextStyle(
                                    color: themeData.primaryColor,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                          scrollController: scrollController,
                          itemExtent: 40.0,
                          backgroundColor: Colors.white,
                          onSelectedItemChanged: (int index) {
                            selectTypeIndex = index;
                            request.tid = workOrderTypes[index].id;
                            setState(() {});
                          },
                          children: List<Widget>.generate(workOrderTypes.length,
                              (int index) {
                            return Center(
                              child: Text(
                                workOrderTypes[index].title,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 14.0),
                              ),
                            );
                          })),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    Widget _selectBox(
        {String label,
        String content,
        VoidCallback onTap,
        Color contentColor}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          height: 50.0,
          child: DefaultTextStyle(
              style: TextStyle(
                  color: Colors.black87.withAlpha(180), fontSize: 14.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("$label"),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "$content",
                              style: TextStyle(color: contentColor),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black87.withAlpha(180),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 0.5,
                  )
                ],
              )),
        ),
      );
    }

    Widget _inputFrom(
        {double height = 50.0,
        String label,
        double labelTop = 0.0,
        String placeholder,
        int minLines,
        int maxLines,
        TextEditingController controller,
        String tips,
        TextInputType keyboardType,
        bool isShowDivider = true,
        CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: height,
        child: DefaultTextStyle(
            style:
                TextStyle(color: Colors.black87.withAlpha(180), fontSize: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: crossAxisAlignment,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: labelTop),
                        child: Text("$label"),
                      ),
                      Expanded(
                        child: TextField(
                          cursorColor: themeData.primaryColor,
                          controller: controller,
                          keyboardType: keyboardType,
                          decoration: InputDecoration(
                              hintText: placeholder,
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey.withAlpha(150),
                              ),
                              counterStyle:
                                  TextStyle(color: Colors.grey.withAlpha(200)),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 3.0),
                              counterText: ""),
                          style: TextStyle(
                            color: Colors.black87.withAlpha(180),
                            fontSize: 15.0,
                          ),
                          minLines: minLines,
                          maxLines: maxLines,
                        ),
                      )
                    ],
                  ),
                ),
                Opacity(
                  opacity: isShowDivider ? 1.0 : 0.0,
                  child: Divider(
                    height: 0.5,
                  ),
                ),
                Offstage(
                  offstage: tips == null || tips.isEmpty,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      "$tips",
                      style: TextStyle(fontSize: 11.0, color: Colors.amber),
                    ),
                  ),
                )
              ],
            )),
      );
    }

    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("创建工单")),
        body: ListView(
          children: <Widget>[
            _selectBox(
                label: "类型：",
                content: request.cid == null
                    ? "选择工单类型"
                    : "${workOrderTypes[selectTypeIndex].title}",
                onTap: _onSelectType),
            _inputFrom(
                label: "标题：", placeholder: "请输入工单标题~", controller: _titleCtr),
            _inputFrom(
                label: "手机：",
                keyboardType: TextInputType.phone,
                controller: _phoneCtr,
                placeholder: "请输入您的手机~",
                tips: "必填，预留手机号方便客服联系到您~",
                height: 65.0),
            _inputFrom(
                label: "邮箱：",
                keyboardType: TextInputType.emailAddress,
                controller: _emailCtr,
                placeholder: "请输入您的电子邮箱~",
                tips: "非必填，预留邮箱后若工单回复后会通过邮箱通知您~",
                height: 65.0),
            _inputFrom(
                label: "内容：",
                placeholder: "请输入您的工单内容~",
                minLines: 3,
                maxLines: 5,
                controller: _contentCtr,
                height: 100,
                labelTop: 3.0,
                crossAxisAlignment: CrossAxisAlignment.start),
            _selectBox(
                label: "附件：",
                content: isUploadFail
                    ? "上传失败了~"
                    : uploadProgress > 0
                        ? "文件上传中$uploadProgress%..."
                        : html.isEmpty ? "上传附件" : "已上传附件，重新上传可替换~",
                onTap: _uploadFile,
                contentColor: isUploadFail
                    ? Colors.red
                    : html.isNotEmpty && uploadProgress == 0
                        ? Color(0XFF8bc34a)
                        : null),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("温馨提示：由于客服值班时间原因，工单回复较慢，请您耐心等待~",
                  style: TextStyle(fontSize: 11.0, color: Colors.red)),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
                child: SizedBox(
                  height: 45.0,
                  child: RaisedButton(
                      color: themeData.primaryColor,
                      onPressed: _save,
                      child: Text(
                        "提交",
                        style: TextStyle(color: Colors.white),
                      )),
                ))
          ],
        ));
  }
}
