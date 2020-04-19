import 'package:dio/dio.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/services/system_service.dart';
class CompamySettingView  extends StatefulWidget{
  @override
  _CompamySettingViewState createState() => _CompamySettingViewState();
}

class _CompamySettingViewState  extends State<CompamySettingView> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  SystemService systemService = SystemService.getInstance();
  CompanyModel companyInfo;
  TextEditingController companyNameCtr;
  TextEditingController serviceTimeCtr;
  TextEditingController emailCtr;
  TextEditingController telCtr;
  TextEditingController addrCtr;
  bool isLoading = true;
  String logo;


  /// 获取系统信息
  void _getCompanyInfo() async{
    await Future.delayed(Duration(milliseconds: 500));
    Response response = await systemService.getCompanyInfo();
    if (response.data["code"] == 200) {
      companyInfo = CompanyModel.fromJson(response.data["data"]);
      companyNameCtr = TextEditingController(text: companyInfo.title);
      serviceTimeCtr = TextEditingController(text: companyInfo.service);
      emailCtr = TextEditingController(text: companyInfo.email);
      telCtr = TextEditingController(text: companyInfo.tel);
      addrCtr = TextEditingController(text: companyInfo.address);
      logo = companyInfo.logo;
      printf(companyInfo.toJson());
    } else {
      UX.showToast("${response.data["message"]}");
    }
    isLoading = false;
    setState(() {});
  }

  /// 选择图片上传
  void _pickerImage() async{
    String imgUser = await uploadImage<String>(context, maxWidth: 300.0);
    if(imgUser == null) return;
    logo = imgUser;
    setState(() {});
  }

  /// 保存
  void _save() async{
    companyInfo.title = companyNameCtr.value.text.trim();
    companyInfo.service = serviceTimeCtr.value.text.trim();
    companyInfo.email = emailCtr.value.text.trim();
    companyInfo.tel = telCtr.value.text.trim();
    companyInfo.address = addrCtr.value.text.trim();
    companyInfo.logo = logo;
    UX.showLoading(context, content: "保存中...");
    Response response = await systemService.saveCompanyInfo(companyInfo.toJson());
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
      _getCompanyInfo();
    }
  }

  @override
  void dispose() {
    companyNameCtr?.dispose();
    serviceTimeCtr?.dispose();
    emailCtr?.dispose();
    telCtr?.dispose();
    addrCtr?.dispose();
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
              label: "公司名称：",
              placeholder: "请输入公司名称",
              controller: companyNameCtr
            ),
            _fromInput(
              label: "服务时间：",
              placeholder: "请输入服务时间",
              controller: serviceTimeCtr
            ),
            _fromInput(
              label: "公司邮箱：",
              placeholder: "请输入公司邮箱",
              controller: emailCtr
            ),
            _fromInput(
              label: "公司电话：",
              placeholder: "请输入公司电话",
              controller: telCtr
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: themeData.dividerColor,width: ToPx.size(2)))
                ),
                padding: EdgeInsets.symmetric(horizontal: ToPx.size(40), vertical: ToPx.size(10)),
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Text("公司地址：", style: themeData.textTheme.title,),
                    Expanded(
                      child: Input(
                      minLines: 5,
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      border: Border.all(style: BorderStyle.none, color: Colors.transparent),
                      padding: EdgeInsets.symmetric(horizontal: ToPx.size(10)),
                      placeholder: "请输入公司地址",
                      controller: addrCtr,
                    ),
                    )
                  ],
                ),
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