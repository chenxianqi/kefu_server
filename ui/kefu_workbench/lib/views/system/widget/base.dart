import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/services/system_service.dart';
class BaseSettingView  extends StatefulWidget{
  @override
  _BaseSettingViewState createState() => _BaseSettingViewState();
}

class _BaseSettingViewState  extends State<BaseSettingView> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  SystemService systemService = SystemService.getInstance();
  TextEditingController systemNameCtr;
  TextEditingController copyrightCtr;
  String selectUploadTitle;
  String logo;
  bool isLoading = true;
  List<UploadsConfigModel> uploadsConfig = [];
  SystemInfoModel systemInfo;

  /// 获取系统信息
  void _getSystemInfo() async{
    await Future.delayed(Duration(milliseconds: 500));
    Response response = await systemService.getSystemInfo();
    if (response.data["code"] == 200) {
      systemInfo = SystemInfoModel.fromJson(response.data["data"]);
      systemNameCtr = TextEditingController(text: systemInfo.title);
      copyrightCtr = TextEditingController(text: systemInfo.copyRight);
      logo = systemInfo.logo;
      _getUploadsConfig();
      setState(() {});
    } else {
      UX.showToast("${response.data["message"]}");
    }
  }

  /// 选择图片上传
  void _pickerImage() async{
    String imgUser = await uploadImage<String>(context, maxWidth: 300.0);
    if(imgUser == null) return;
    logo = imgUser;
    setState(() {});
  }

  /// 获取上传配置信息
  void _getUploadsConfig() async{
    Response response = await systemService.getUploadsConfig();
    if (response.data["code"] == 200) {
      uploadsConfig = (response.data["data"] as List).map((i){
        UploadsConfigModel uploadsConfigModel = UploadsConfigModel.fromJson(i);
        if(uploadsConfigModel.id == systemInfo.uploadMode){
          selectUploadTitle = uploadsConfigModel.name;
        }
        return uploadsConfigModel;
      }).toList();
      setState(() {});
    } else {
      UX.showToast("${response.data["message"]}");
    }
    setState(() {
      isLoading = false;
    });
  }

  /// 保存
  void _save() async{
    systemInfo.title = systemNameCtr.value.text.trim();
    systemInfo.copyRight = copyrightCtr.value.text.trim();
    systemInfo.logo = logo;
    for (UploadsConfigModel item in uploadsConfig) {
      if(item.name == selectUploadTitle){
        systemInfo.uploadMode = item.id;
        break;
      }
    }
    UX.showLoading(context, content: "保存中...");
    Response response = await systemService.saveSystemInfo(systemInfo.toJson());
    UX.hideLoading(context);
    if (response.data["code"] == 200) {
      UX.showToast("保存成功");
      GlobalProvide.getInstance().getConfigs();
    } else {
      UX.showToast("${response.data["message"]}");
    }

  }


  @override
  void initState() {
    super.initState();
    if(mounted){
      _getSystemInfo();
    }
  }

  @override
  void dispose() {
    systemNameCtr?.dispose();
    copyrightCtr?.dispose();
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
            Container(
              width: double.infinity,
              color: Colors.grey.withAlpha(20),
              padding: EdgeInsets.all(ToPx.size(30)),
              child: GestureDetector(
                onTap: _pickerImage,
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  children: <Widget>[
                    logo == null || logo.isEmpty ?
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: ToPx.size(50)),
                        child: Text("点击上传LOGO", style: themeData.textTheme.caption,),
                      ),
                    ) :
                    Center(
                      child: CachedNetworkImage(
                      bgColor: Colors.transparent,
                      src: logo
                    )),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.camera_alt, color:themeData.primaryColor.withAlpha(50), size: ToPx.size(35),)
                    )
                  ],
                )
              )
            ),
            
            _fromInput(
              label: "系统名称：",
              placeholder: "请输入系统名称",
              controller: systemNameCtr
            ),
            _fromInput(
              label: "版权信息：",
              placeholder: "请输入版权信息",
              controller: copyrightCtr
            ),

            DropdownButtonHideUnderline(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ToPx.size(30), vertical: ToPx.size(10)),
                child: InputDecorator(
              decoration: InputDecoration(
                labelText: '选择资源存储空间服务商：',
                hintText: '请选择所属平台',
                labelStyle: themeData.textTheme.title.copyWith(
                  color: themeData.primaryColor,
                  fontSize: ToPx.size(36)
                ),
                contentPadding: EdgeInsets.zero,
              ),
              child: DropdownButton<String>(
                value: selectUploadTitle,
                onChanged: (String newValue) {
                  setState(() {
                    selectUploadTitle = newValue;
                  });
                },
                items: uploadsConfig.map<DropdownMenuItem<String>>((UploadsConfigModel item) {
                  return DropdownMenuItem<String>(
                    value: item.name,
                    child: Text(item.name, style: themeData.textTheme.title,),
                  );
                }).toList(),
              ),
            ),
              )
            ),

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