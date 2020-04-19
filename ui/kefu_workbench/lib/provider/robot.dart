import 'package:dio/dio.dart';

import '../core_flutter.dart';

class RobotProvide with ChangeNotifier {

  RobotService robotService = RobotService.getInstance();

  static RobotProvide instance;

   // 单例
  static RobotProvide getInstance() {
    if (instance != null) {
      return instance;
    }
    instance = RobotProvide();
    return instance;
  }

  RobotProvide(){
    getRobots();
  }

  bool isLoading = false;
  List<RobotModel> robots = [];

    /// 获取列表数据
  Future<void> getRobots() async{
    isLoading = true;
    notifyListeners();
    Response response = await robotService.getList();
    isLoading = false;
    notifyListeners();
    if (response.data["code"] == 200) {
      robots = (response.data["data"] as List).map((i) => RobotModel.fromJson(i)).toList();
      notifyListeners();
    } else {
      UX.showToast("${response.data["message"]}");
    }
  }

  /// 更新单个数据
  Future<void> getRobot(int id) async{
    Response response = await RobotService.getInstance().getItem(id: id);
    if (response.data["code"] == 200) {
      RobotModel _robot = RobotModel.fromJson(response.data["data"]);
      int index = robots.indexWhere((k) => k.id == id);
      if(index != null){
        robots[index] = _robot;
        notifyListeners();
      }
    }
  }
  /// 找出一个
  RobotModel getItem(int id){
    return robots.firstWhere((k) => k.id == id);
  }

  /// 删除单个数据
  void deleteItem(int id){
    robots.removeWhere((i) => i.id == id);
  }

    // onRefresh
  Future<bool> onRefresh() async{
    await getRobots();
    UX.showToast("刷新成功", position: ToastPosition.top);
    return true;
  }


  /// add
  void goAdd(BuildContext context) async{
    Navigator.pushNamed(context, "/robot_add").then((isSuccess){
      if(isSuccess == true){
        getRobots();
      }
    });
  }

  

  @override
  void dispose() {
    instance = null;
    super.dispose();
  }

  
}
