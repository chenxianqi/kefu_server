import 'package:dio/dio.dart';
import 'package:kefu_workbench/provider/global.dart';

import '../core_flutter.dart';

class ChatReCordProvide with ChangeNotifier {

  AdminService adminService = AdminService.getInstance();
  PublicService publicService = PublicService.getInstance();
  static ChatReCordProvide instance;

   // 单例
  static ChatReCordProvide getInstance() {
    if (instance != null) {
      return instance;
    }
    instance = ChatReCordProvide();
    return instance;
  }

  ChatReCordProvide(){
    scrollController = ScrollController();
    searchTextEditingController = TextEditingController();
    getAdmins();
    // 监听滚动
    scrollController?.addListener(() => _onScrollViewControllerAddListener());

    DateTime _dateTime = DateTime.now();
    date = "${_dateTime.year}-${_dateTime.month < 10 ? '0'+_dateTime.month.toString() : _dateTime.month}-${_dateTime.day < 10 ? '0'+_dateTime.day.toString() : _dateTime.day}";
  }

  int pageOn = 0;
  int pageSize = 25;
  int total = 0;
  bool isLoadEnd = false;
  bool isLoading = false;
  String date;
  bool isDeWeighting = false;
  bool isReception = false;
  ScrollController scrollController;
  TextEditingController searchTextEditingController;
  List<AdminModel> admins = [AdminModel(id: 0, nickname: "全部")];
  List<ServicesStatisticalModel> servicesStatisticals = [];
  AdminModel selectedAdmin = AdminModel(id: 0, nickname: "全部");

  String getAdminNickName(int id){
    return admins.firstWhere((i)=>i.id == id).nickname;
  }

  // 监听滚动条
  void _onScrollViewControllerAddListener() async{
    try {
      ScrollPosition position = scrollController.position;
      if (position.pixels + 10.0 > position.maxScrollExtent &&
          !isLoadEnd && !isLoading) {
        // 判断网络
        if (!await checkNetWork()) {
          UX.showToast('您的网络异常，请检查您的网络!', position: ToastPosition.top);
          return;
        }
        getAdmins();
      }
    }catch(e){
      printf(e);
    }
  }
  
  // 选择客服
  void onSelected(AdminModel admin){
    if(selectedAdmin != null && admin.id == selectedAdmin.id) return;
    selectedAdmin = admin;
    admins = [];
    notifyListeners();
     _reload();
  }

  /// 获取客服列表数据
  Future<void> getAdmins() async{
    Response response = await adminService.getAdmins(pageOn: 1, pageSize: 1000, keyword: "");
    if (response.data["code"] == 200) {
      var _admins= (response.data["data"]['list'] as List).map((i){
        AdminModel  _admin = AdminModel.fromJson(i);
        return _admin;
      }).toList();
      admins = [];
      admins.add(AdminModel(id: 0, nickname: "全部"));
      admins.addAll(_admins);
      getServicesStatistical();
      notifyListeners();
    } else {
      UX.showToast("${response.data["message"]}");
    }
  }


  /// 获取服务记录
  Future<void> getServicesStatistical() async{
    if(isLoadEnd) return;
    pageOn = pageOn +1;
    isLoading = true;
    notifyListeners();
    Response response = await publicService.getServicesStatistical(pageOn: pageOn, pageSize: pageSize, cid: selectedAdmin?.id, date: date, isDeWeighting: isDeWeighting,isReception: isReception);
    isLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      total = response.data['data']['total'];
      List<ServicesStatisticalModel> _servicesStatisticals= (response.data['data']['list'] as List).map((i) => ServicesStatisticalModel.fromJson(i)).toList();
      if(_servicesStatisticals.length < pageSize){
        isLoadEnd = true;
      }
      if(pageOn > 1){
        servicesStatisticals.addAll(_servicesStatisticals);
      }else{
        servicesStatisticals = _servicesStatisticals;
      }
      notifyListeners();
    } else {
      UX.showToast("${response.data["message"]}");
    }
  }

  // 选择注册日期
  void onSelectDate(BuildContext context) async{
    var _date = await UX.selectDatePicker(context, oldDate: date);
    if (_date == null || _date == date) return;
    date = _date;
    pageOn = 0;
    isLoadEnd = false;
    notifyListeners();
    getServicesStatistical();
  }

  // 设置是否去重
  void setDeWeighting(bool isDeWeighting){
    this.isDeWeighting = isDeWeighting;
    notifyListeners();
    _reload();
  }

  // 仅显示未接待
  void setReception(bool isReception){
    this.isReception = isReception;
    notifyListeners();
    _reload();
  }


  // onRefresh
  Future<bool> onRefresh() async{
    await _reload();
    UX.showToast("刷新成功", position: ToastPosition.top);
    return true;
  }

  // reload
  Future<void> _reload() async{
    pageOn = 0;
    isLoadEnd = false;
    searchTextEditingController.clear();
    notifyListeners();
    await getAdmins();
  }

  @override
  void dispose() {
    instance = null;
    scrollController?.dispose();
    searchTextEditingController?.dispose();
    super.dispose();
  }

  
}
