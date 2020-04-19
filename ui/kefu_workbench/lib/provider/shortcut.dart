import 'package:dio/dio.dart';

import '../core_flutter.dart';

class ShortcutProvide with ChangeNotifier {

  ShortcutService shortcutService = ShortcutService.getInstance();

  static ShortcutProvide instance;

   // 单例
  static ShortcutProvide getInstance() {
    if (instance != null) {
      return instance;
    }
    instance = ShortcutProvide();
    return instance;
  }

  ShortcutProvide(){
    scrollController = ScrollController();
    searchTextEditingController = TextEditingController();
    getShortcuts();
  }

  int pageOn = 0;
  int pageSize = 25;
  bool isLoading = false;
  ScrollController scrollController;
  TextEditingController searchTextEditingController;
  List<ShortcutModel> shortcuts = [];


  /// 获取列表数据
  Future<void> getShortcuts() async{
    isLoading = true;
    notifyListeners();
    Response response = await shortcutService.getShortcuts();
    isLoading = false;
    notifyListeners();
    if (response.data["code"] == 200) {
      shortcuts = (response.data['data'] as List).map((i) => ShortcutModel.fromJson(i)).toList();
      notifyListeners();
    } else {
      UX.showToast(response.data['message']);
    }
  }


  /// 找出一个
  ShortcutModel getItem(int id){
    return shortcuts.firstWhere((k) => k.id == id);
  }

  /// 删除单个数据
  void deleteItem(int id){
    shortcuts.removeWhere((i) => i.id == id);
  }

  // onRefresh
  Future<bool> onRefresh() async{
    searchTextEditingController.clear();
    notifyListeners();
    await getShortcuts();
    UX.showToast("刷新成功", position: ToastPosition.top);
    return true;
  }

   /// edit
  void goEdit(BuildContext context, ShortcutModel shortcut) async{
    Navigator.pushNamed(context, "/shortcut_edit", arguments: {"shortcut": shortcut}).then((isSuccess){
      if(isSuccess == true){
        getShortcuts();
      }
    });
  }


  /// add
  void goAdd(BuildContext context) async{
    Navigator.pushNamed(context, "/shortcut_add").then((isSuccess){
      if(isSuccess == true){
        getShortcuts();
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
