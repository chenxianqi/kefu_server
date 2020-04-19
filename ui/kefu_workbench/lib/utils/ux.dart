
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kefu_workbench/core_flutter.dart';

enum ToastPosition {
  top,
  bottom,
  center
}

class UX {

  // 显示loading
  static Timer _timerLoading;
  static void showLoading(BuildContext context, {String content = '请稍等...', Function onTimeOut}) {
    _timerLoading?.cancel();
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) {
          return MiniLoading(context: context, content: content);
        }));
    _timerLoading = Timer.periodic(Duration(milliseconds: 60000), (_){
      _timerLoading?.cancel();
      hideLoading(context);
      if(onTimeOut != null) onTimeOut();
    });
  }

  // 隐藏loading
  static void hideLoading(BuildContext context) {
    _timerLoading?.cancel();
    Navigator.pop(context);
  }

  // 显示toast
  static void showToast(String content, {ToastPosition position = ToastPosition.center}){
    Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: position == ToastPosition.center ? ToastGravity.CENTER : position == ToastPosition.top ? ToastGravity.TOP : ToastGravity.BOTTOM,
      timeInSecForIos: 2,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.8),
      fontSize: ToPx.size(28)
    );
  }

  // 撤销toast
  static void cancelToast(){
    Fluttertoast.cancel();
  }

  /// 普通询问弹窗
  /// * [title] 标题
  /// * [content] 内容
  /// * [cancelText] 撤销文字 默认 = 取消
  /// * [confirmText] 确定文字 默认 = 确定
  static Future<bool> alert(context,{
    String title = "温馨提示！",
    dynamic content,
    String cancelText = '取消',
    String confirmText = '确定',
    bool isConfirmPop = true,
    VoidCallback onCancel,
    VoidCallback onConfirm,
  }) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          ThemeData themeData = Theme.of(context);
          return CupertinoAlertDialog(
            title: title.isEmpty ? null : Padding(
              padding: EdgeInsets.only(bottom: ToPx.size(20)),
              child: Text(title),
            ),
            content: content is Widget ? content : Text('$content', style: TextStyle(height: 1.5),),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(cancelText, style: themeData.textTheme.title.copyWith(
                  color: themeData.errorColor
                )),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  if (onCancel != null){
                    onCancel();
                  }
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  confirmText,
                ),
                isDefaultAction: true,
                onPressed: () {
                  if(isConfirmPop) Navigator.pop(context);
                  if (onConfirm != null) onConfirm();
                },
              ),
            ],
          );
        });
  }

  // 图片预览
  static void photoPreview(context,{List<String> images}){
    Navigator.push(context, PageRouteBuilder(
        barrierDismissible: true,
        opaque: false,
        pageBuilder: (context, _, __){
          return PhotoPreview(images: images, context: context,);
        }
    ));
  }

  // 图片选择 sheet
  static Future<int> selectImageSheet(context) async {
    ThemeData themeData = Theme.of(context);
    var imageSource = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context){
        return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('拍照', style: themeData.textTheme.body2),
                onPressed: () {
                  Navigator.pop(context, 0); // ImageSource.camera
                },
              ),
              CupertinoActionSheetAction(
                child: Text('打开相册', style: themeData.textTheme.body2),
                onPressed: () {
                  Navigator.pop(context, 1); // ImageSource.gallery
                },
              ),
              CupertinoActionSheetAction(
                child: Text('选择文件', style: themeData.textTheme.body2),
                onPressed: () {
                  Navigator.pop(context, 2); // ImageSource.gallery
                },
              ),
            ],
            cancelButton: SizedBox(
              child: CupertinoActionSheetAction(
                isDestructiveAction: true,
                child: Text('取消', style: themeData.textTheme.body2),
                onPressed: () {
                  Navigator.pop(context, null);
                },
              ),
            )
        );
      }
    );
    return imageSource;
  }

  // 时间选择器 IOS 风格
  static Future<String> selectDatePicker(context, {String oldDate, int maximumYear,  DateTime maximumDate}) async{
    DateTime initDate = oldDate != null ? DateTime.tryParse(oldDate) : DateTime.now();
    var date =  await Navigator.of(context).push(
        PageRouteBuilder(
            opaque: false,
            barrierColor: Color.fromRGBO(0, 0, 0, 0.5),
            barrierDismissible: true,
            barrierLabel: 'route',
            maintainState: false,
            pageBuilder: (BuildContext ctx, Animation<double> _, Animation<double> __){
              return DatePicker(
                  context: context,
                  maximumDate: maximumDate,
                  maximumYear: maximumYear != null ? maximumYear : DateTime.now().year,
                  initDate: initDate != null ? initDate : DateTime.now()
              );
            },
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
                ) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            }
        )
    );
    if (date == null) return null;
    final String month = date.month < 10 ? '0' + date.month.toString() : date.month.toString();
    final String day = date.day < 10 ? '0' + date.day.toString() : date.day.toString();
    final String selectedDate = date.year.toString() + '-' + month + '-' + day;
    return selectedDate;
  }


}
