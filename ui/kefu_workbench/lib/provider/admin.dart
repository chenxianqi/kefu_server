import 'package:dio/dio.dart';

import '../core_flutter.dart';

class AdminProvide with ChangeNotifier {

  AdminService adminService = AdminService.getInstance();

  static AdminProvide instance;

   // 单例
  static AdminProvide getInstance() {
    if (instance != null) {
      return instance;
    }
    instance = AdminProvide();
    return instance;
  }

  AdminProvide(){
    scrollController = ScrollController();
    searchTextEditingController = TextEditingController();
    getAdmins();
    // 监听滚动
    scrollController?.addListener(() => _onScrollViewControllerAddListener());
  }

  int pageOn = 0;
  int pageSize = 25;
  bool isLoadEnd = false;
  bool isLoading = false;
  String keyword = "";
  ScrollController scrollController;
  TextEditingController searchTextEditingController;
  List<AdminModel> admins = [];
  int usersTotal = 0;

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
  

  /// 获取列表数据
  Future<void> getAdmins() async{
    if(isLoadEnd) return;
    pageOn = pageOn +1;
    isLoading = true;
    notifyListeners();
    Response response = await adminService.getAdmins(pageOn: pageOn, pageSize: pageSize, keyword: keyword);
    isLoading = false;
    notifyListeners();
    if (response.data["code"] == 200) {
      List<AdminModel> _admins= (response.data["data"]['list'] as List).map((i) => AdminModel.fromJson(i)).toList();
      usersTotal = response.data["data"]['total'];
      if(_admins.length < pageSize){
        isLoadEnd = true;
      }
      if(pageOn > 1){
        admins.addAll(_admins);
      }else{
        admins = _admins;
      }
      notifyListeners();
    } else {
      UX.showToast("${response.data["message"]}");
    }
  }

  /// 更新单个数据
  Future<void> getUser(int id) async{
    Response response = await adminService.getItem(id: id);
    if (response.data["code"] == 200) {
      AdminModel _admin = AdminModel.fromJson(response.data["data"]);
      int index = admins.indexWhere((k) => k.id == id);
      if(index != null){
        admins[index] = _admin;
        notifyListeners();
      }
    }
  }
  /// 找出一个
  AdminModel getItem(int id){
    return admins.firstWhere((k) => k.id == id);
  }

  /// 删除单个数据
  void deleteItem(int id){
    usersTotal--;
    admins.removeWhere((i) => i.id == id);
  }

  // search
  void onSearch() async{
    pageOn = 0;
    keyword = searchTextEditingController.value.text.trim();
    isLoadEnd = false;
    notifyListeners();
    await getAdmins();
  }

  // onRefresh
  Future<bool> onRefresh() async{
    pageOn = 0;
    keyword = "";
    isLoadEnd = false;
    searchTextEditingController.clear();
    notifyListeners();
    await getAdmins();
    UX.showToast("刷新成功", position: ToastPosition.top);
    return true;
  }


  /// add
  void goAdd(BuildContext context) async{
    Navigator.pushNamed(context, "/admin_add").then((isSuccess){
      if(isSuccess == true){
        pageOn = 0;
        isLoadEnd = false;
        notifyListeners();
        getAdmins();
      }
    });
  }

  @override
  void dispose() {
    instance = null;
    scrollController?.dispose();
    searchTextEditingController?.dispose();
    super.dispose();
  }

  
}
