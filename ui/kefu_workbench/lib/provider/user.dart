import 'package:dio/dio.dart';

import '../core_flutter.dart';

class UserProvide with ChangeNotifier {

  UserService userService = UserService.getInstance();

  static UserProvide instance;

   // 单例
  static UserProvide getInstance() {
    if (instance != null) {
      return instance;
    }
    instance = UserProvide();
    return instance;
  }

  UserProvide(){
    scrollController = ScrollController();
    searchTextEditingController = TextEditingController();
    getUsers();
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
  List<UserModel> users = [];
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
        getUsers();
      }
    }catch(e){
      printf(e);
    }
  }
  

  /// 获取列表数据
  Future<void> getUsers() async{
    if(isLoadEnd) return;
    pageOn = pageOn +1;
    isLoading = true;
    notifyListeners();
    Response response = await userService.getList(pageOn: pageOn, pageSize: pageSize, keyword: keyword);
    isLoading = false;
    notifyListeners();
    if (response.data["code"] == 200) {
      List<UserModel> _users = (response.data["data"]['list'] as List).map((i) => UserModel.fromJson(i)).toList();
      usersTotal = response.data["data"]['total'];
      if(_users.length < pageSize){
        isLoadEnd = true;
      }
      if(pageOn > 1){
        users.addAll(_users);
      }else{
        users = _users;
      }
      notifyListeners();
    } else {
      UX.showToast("${response.data["message"]}");
    }
  }

  /// 更新单个数据
  Future<void> getUser(int id) async{
    Response response = await userService.getItem(id: id);
    if (response.data["code"] == 200) {
      UserModel _user = UserModel.fromJson(response.data["data"]);
      int index = users.indexWhere((k) => k.id == id);
      if(index != null){
        users[index] = _user;
        notifyListeners();
      }
    }
  }
  /// 找出一个
  UserModel getItem(int id){
    return users.firstWhere((k) => k.id == id);
  }

  /// 删除单个数据
  void deleteItem(int id){
    usersTotal--;
    users.removeWhere((i) => i.id == id);
  }

  // search
  void onSearch() async{
    keyword = searchTextEditingController.value.text.trim();
    if(keyword.isEmpty) return;
    pageOn = 0;
    isLoadEnd = false;
    notifyListeners();
    await getUsers();
  }

  // onRefresh
  Future<bool> onRefresh() async{
    pageOn = 0;
    keyword = "";
    isLoadEnd = false;
    searchTextEditingController.clear();
    notifyListeners();
    await getUsers();
    UX.showToast("刷新成功", position: ToastPosition.top);
    return true;
  }

  @override
  void dispose() {
    instance = null;
    scrollController?.dispose();
    searchTextEditingController?.dispose();
    super.dispose();
  }

  
}
