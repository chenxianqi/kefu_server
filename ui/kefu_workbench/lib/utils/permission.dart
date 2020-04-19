
// 检测系统权限
import 'package:kefu_workbench/core_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
export 'package:permission_handler/permission_handler.dart';

Future<bool> checkPermission(context, {PermissionGroup permissionGroupType}) async {
  try {
    PermissionStatus permission;
    // 相机
    if (permissionGroupType == PermissionGroup.camera){
      await PermissionHandler().requestPermissions([PermissionGroup.camera]);
      permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    }
    // 位置
    if (permissionGroupType == PermissionGroup.locationWhenInUse){
      await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]);
      permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.locationWhenInUse);
    }
    // 相册
    if (permissionGroupType == PermissionGroup.photos) {
      await PermissionHandler().requestPermissions([PermissionGroup.photos]);
      permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);
    }
    // 文件读写
    if (permissionGroupType == PermissionGroup.storage) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler().checkPermissionStatus(
          PermissionGroup.storage);
    }
    // 通知
    if (permissionGroupType == PermissionGroup.notification) {
      await PermissionHandler().requestPermissions([PermissionGroup.notification]);
      permission = await PermissionHandler().checkPermissionStatus(
          PermissionGroup.notification);
    }
    if (permission != PermissionStatus.granted) {
      // 提示内容
      String permissionName;
      if (permissionGroupType == PermissionGroup.camera)
        permissionName = "相机权限";
      if (permissionGroupType == PermissionGroup.photos)
        permissionName = "相册权限";
      if (permissionGroupType == PermissionGroup.notification)
        permissionName = "通知权限";
      if (permissionGroupType == PermissionGroup.storage)
        permissionName = "文件读写权限";
      if (permissionGroupType == PermissionGroup.locationWhenInUse)
        permissionName = "位置定位权限，APP无法帮您识别您的车牌归属地";
      UX.alert(
          context, content: "您还没有授权使用$permissionName，现在去设置？",
          onConfirm: () async {
            // 打开设置
            await PermissionHandler().openAppSettings();
          });

      return false;
    }else{
      return true;
    }
  }catch(e){
    return false;
  }
}