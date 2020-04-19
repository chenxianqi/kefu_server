import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/services/system_service.dart';
class QiniuSettingView  extends StatefulWidget{
  @override
  _QiniuSettingViewState createState() => _QiniuSettingViewState();
}

class _QiniuSettingViewState  extends State<QiniuSettingView>  with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  SystemService systemService = SystemService.getInstance();
  QiniuModel qiniuInfo;
  TextEditingController bucketCtr;
  TextEditingController accessKeyCtr;
  TextEditingController secretKeyCtr;
  TextEditingController hostCtr;
  bool isLoading = true;


  /// 获取系统信息
  void _getQiniuInfo() async{
    await Future.delayed(Duration(milliseconds: 500));
    Response response = await systemService.getQiniuInfo();
    if (response.data["code"] == 200) {
      qiniuInfo = QiniuModel.fromJson(response.data["data"]);
      bucketCtr = TextEditingController(text: qiniuInfo.bucket);
      accessKeyCtr = TextEditingController(text: qiniuInfo.accessKey);
      secretKeyCtr = TextEditingController(text: qiniuInfo.secretKey);
      hostCtr = TextEditingController(text: qiniuInfo.host);
      printf(qiniuInfo.toJson());
    } else {
      UX.showToast("${response.data["message"]}");
    }
    isLoading = false;
    setState(() {});
  }

   /// 保存
  void _save() async{
    qiniuInfo.bucket = bucketCtr.value.text.trim();
    qiniuInfo.accessKey = accessKeyCtr.value.text.trim();
    qiniuInfo.secretKey = secretKeyCtr.value.text.trim();
    qiniuInfo.host = hostCtr.value.text.trim();
    UX.showLoading(context, content: "保存中...");
    Response response = await systemService.saveQiniuInfo(qiniuInfo.toJson());
    UX.hideLoading(context);
    if (response.data["code"] == 200) {
      UX.showToast("保存成功");
    } else {
      UX.showToast("${response.data["message"]}");
    }
  }


  @override
  void initState() {
    super.initState();
    if(mounted){
      _getQiniuInfo();
    }
  }
  @override
  void dispose() {
    bucketCtr?.dispose();
    accessKeyCtr?.dispose();
    secretKeyCtr?.dispose();
    hostCtr?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    Widget _fromInput({
      String label,
      TextEditingController controller,
      String placeholder,
      bool enabled = true,
      bool autofocus = false,
    }){
      return Container(
        height: ToPx.size(90),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: themeData.dividerColor,width: ToPx.size(2)))
        ),
        padding: EdgeInsets.symmetric(horizontal: ToPx.size(40)),
        child: Row(
        children: <Widget>[
            Text("$label", style: themeData.textTheme.title,),
            Expanded(
              child: Input(
              enabled: enabled,
              autofocus: autofocus,
              border: Border.all(style: BorderStyle.none, color: Colors.transparent),
              padding: EdgeInsets.symmetric(horizontal: ToPx.size(10)),
              placeholder: "$placeholder",
              showClear: true,
              controller: controller,
            ),
            )
          ],
        ),
      );
    }
     if(isLoading){
      return Center(
        child: loadingIcon(size: ToPx.size(50)),
      );
    }
    return ListView(
          children: <Widget>[
            SizedBox(
              height: ToPx.size(20),
            ),
            
            _fromInput(
              label: "Bucket：",
              placeholder: "请输入Bucket",
              controller: bucketCtr
            ),
            _fromInput(
              label: "accessKey：",
              placeholder: "请输入accessKey",
              controller: accessKeyCtr
            ),
            _fromInput(
              label: "secretKey：",
              placeholder: "请输入secretKey",
              controller: secretKeyCtr
            ),
            _fromInput(
              label: "Host：",
              placeholder: "请输入Host",
              controller: hostCtr
            ),
            SizedBox(
              height: ToPx.size(20),
            ),
            Text("请不要随意修改该选项，可能会导致客户端上传不了文件或图片", style: themeData.textTheme.caption, textAlign: TextAlign.center,),
            Button(
              margin: EdgeInsets.symmetric(horizontal: ToPx.size(40), vertical: ToPx.size(80)),
              onPressed: _save,
               withAlpha: 200,
              child: Text("保存"),
            )

        ],
      );
  }
}