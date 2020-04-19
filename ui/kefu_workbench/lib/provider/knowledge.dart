import 'package:dio/dio.dart';

import '../core_flutter.dart';

class KnowledgeProvide with ChangeNotifier {

  static KnowledgeProvide instance;

   // 单例
  static KnowledgeProvide getInstance() {
    if (instance != null) {
      return instance;
    }
    instance = KnowledgeProvide();
    return instance;
  }
  
  KnowledgeProvide(){
    scrollController = ScrollController();
    getKnowledges();
    // 监听滚动
    scrollController?.addListener(() => _onScrollViewControllerAddListener());
  }

  int pageOn = 0;
  int pageSize = 25;
  bool isLoadEnd = false;
  bool isLoading = false;
  ScrollController scrollController;
  List<KnowledgeModel> knowledges = [];
  String keyword = "";


  /// 获取列表数据
  Future<void> getKnowledges() async{
    if(isLoadEnd) return;
    pageOn = pageOn +1;
    isLoading = true;
    notifyListeners();
    Response response = await KnowledgeService.getInstance().getList(pageOn: pageOn, pageSize: pageSize, keyword: keyword);
    isLoading = false;
    notifyListeners();
    if (response.data["code"] == 200) {
      List<KnowledgeModel> _knowledges = (response.data["data"]['list'] as List).map((i) => KnowledgeModel.fromJson(i)).toList();
      if(_knowledges.length < pageSize){
        isLoadEnd = true;
      }
      if(pageOn > 1){
        knowledges.addAll(_knowledges);
      }else{
        knowledges = _knowledges;
      }
      notifyListeners();
    } else {
      UX.showToast("${response.data["message"]}");
    }
  }

  /// 更新单个数据
  Future<void> getKnowledge(int id) async{
    Response response = await KnowledgeService.getInstance().getItem(id: id);
    if (response.data["code"] == 200) {
      KnowledgeModel _knowledge = KnowledgeModel.fromJson(response.data["data"]);
      int index = knowledges.indexWhere((k) => k.id == id);
      if(index != null){
        knowledges[index] = _knowledge;
        notifyListeners();
      }
    }
  }

  /// 删除单个数据
  void deleteItem(int id){
    knowledges.removeWhere((i) => i.id == id);
  }

  /// 找出一个
  KnowledgeModel getItem(int id){
    return knowledges.firstWhere((k) => k.id == id);
  }

  // onRefresh
  Future<bool> onRefresh() async{
    pageOn = 0;
    isLoadEnd = false;
    notifyListeners();
    await getKnowledges();
    UX.showToast("刷新成功", position: ToastPosition.top);
    return true;
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
        getKnowledges();
      }
    }catch(e){
      printf(e);
    }
  }

  /// add
  void goAdd(BuildContext context) async{
    Navigator.pushNamed(context, "/knowledge_add").then((isSuccess){
      if(isSuccess == true){
        pageOn = 0;
        isLoadEnd = false;
        notifyListeners();
        getKnowledges();
      }
    });
  }
  

  @override
  void dispose() {
    printf("销毁了KnowledgeProvide");
    instance = null;
    scrollController?.dispose();
    super.dispose();
  }

  
}
