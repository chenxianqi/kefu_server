import 'package:kefu_workbench/views/user_edit/index.dart';

import 'core_flutter.dart';
import 'provider/global.dart';
import 'views/admin_detail/index.dart';
import 'views/admin_edit/index.dart';
import 'views/admins/index.dart';
import 'views/auth/index.dart';
import 'views/chat/index.dart';
import 'views/chat_record/index.dart';
import 'views/edit_password/index.dart';
import 'views/edit_profile/index.dart';
import 'views/home/index.dart';
import 'views/knowledge/index.dart';
import 'views/knowledge_detail/index.dart';
import 'views/knowledge_edit/index.dart';
import 'views/platform_edit/index.dart';
import 'views/robot_detail/index.dart';
import 'views/robot_edit/index.dart';
import 'views/robots/index.dart';
import 'views/shortcut_edit/index.dart';
import 'views/shortcuts/index.dart';
import 'views/statistical/index.dart';
import 'views/system/index.dart';
import 'views/user_detail/index.dart';
import 'views/users/index.dart';
import 'views/workorder/index.dart';
import 'views/workorder_detail/index.dart';
import 'views/workorder_setting/index.dart';

class Routers {
  static Widget buildPage(String path, {Object arguments}) {
    GlobalProvide globalProvide = GlobalProvide.getInstance();
    bool isLogin = globalProvide.isLogin;

    if(!isLogin) return LoginPage(arguments: arguments);
    globalProvide.setCurrentRoutePath(path.replaceAll("/", ""));
    switch (path) {
      case "/login":
        return LoginPage(arguments: arguments);
        break;
      case "/home":
        return HomePage(arguments: arguments);
        break;
      case "/statistical":
        return StatisticalPage(arguments: arguments);
        break;
      case "/chat":
        return ChatPage(arguments: arguments);
        break;
      case "/knowledge":
        return KnowledgePage(arguments: arguments);
      case "/edit_profile":
        return EditProfilePage(arguments: arguments);
      case "/edit_password":
        return EditPasswordPage(arguments: arguments);
      case "/knowledge_detail":
        return KnowledgeDetailPage(arguments: arguments);
      case "/knowledge_add":
      case "/knowledge_edit":
        return KnowledgeEditPage(arguments: arguments);
        break;
      case "/robots":
        return RobotsPage(arguments: arguments);
        break;
      case "/robot_add":
      case "/robot_edit":
        return RobotEditPage(arguments: arguments);
        break;
      case "/robot_detail":
        return RobotDetailPage(arguments: arguments);
        break;
      case "/users":
        return UsersPage(arguments: arguments);
        break;
      case "/user_edit":
        return UserEditPage(arguments: arguments);
      case "/user_detail":
        return UserDetailPage(arguments: arguments);
        break;
      case "/admins":
        return AdminsPage(arguments: arguments);
        break;
      case "/admin_detail":
        return AdminDetailPage(arguments: arguments);
      case "/admin_edit":
      case "/admin_add":
        return AdminEditPage(arguments: arguments);
        break;
      case "/chat_record":
        return ChatReCordPage(arguments: arguments);
        break;
      case "/shortcuts":
        return ShortcutsPage(arguments: arguments);
        break;
      case "/shortcut_edit":
      case "/shortcut_add":
        return ShortcutEditPage(arguments: arguments);
        break;
      case "/system":
        return SystemPage(arguments: arguments);
        break;
      case "/platform_edit":
      case "/platform_add":
        return PlatformEditPage(arguments: arguments);
        break;
      case "/workorder":
        return WorkOrderPage(arguments: arguments);
        break;
      case "/workorder/detail":
        return WorkOrderDetailPage(arguments: arguments);
        break;
      case "/workorder/setting":
        return WorkOrderSettingPage(arguments: arguments);
        break;
      default:
        return Scaffold(
          body: Center(
            child: Text("not fund page"),
          ),
        );
    }
  }
}
