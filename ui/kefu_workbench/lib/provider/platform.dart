import '../core_flutter.dart';

class PlatformProvide with ChangeNotifier {

  static PlatformProvide instance;

   // 单例
  static PlatformProvide getInstance() {
    if (instance != null) {
      return instance;
    }
    instance = PlatformProvide();
    return instance;
  }

  

  @override
  void dispose() {
    instance = null;
    super.dispose();
  }

  
}
