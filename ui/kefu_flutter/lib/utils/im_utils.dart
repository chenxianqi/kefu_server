import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImUtils {
  /// 日期格式化
  static String formatDate(int millisecondsSinceEpoch) {
    if (millisecondsSinceEpoch.toString().length <= 10) {
      millisecondsSinceEpoch =
          int.parse(millisecondsSinceEpoch.toString() + '000');
    }
    if (millisecondsSinceEpoch == null) return "";
    int dateTimeStamp = millisecondsSinceEpoch;
    int minute = 1000 * 60;
    int hour = minute * 60;
    int day = hour * 24;
    int now = DateTime.now().millisecondsSinceEpoch;
    int diffValue = now - dateTimeStamp;
    var dayC = diffValue / day ~/ 1;
    String result;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    if (dayC >= 1) {
      result =
          "${date.year}-${date.month < 10 ? "0" + date.month.toString() : date.month}-${date.day < 10 ? "0" + date.day.toString() : date.day} ${date.hour}:${date.minute < 10 ? "0" + date.minute.toString() : date.minute}";
    } else {
      String firstString = "";
      if (date.hour > 1 && date.hour <= 6) {
        firstString = "凌晨 ";
      } else if (date.hour > 6 && date.hour <= 11) {
        firstString = "早上 ";
      } else if (date.hour > 11 && date.hour <= 12) {
        firstString = "中午 ";
      } else if (date.hour > 12 && date.hour <= 18) {
        firstString = "下午 ";
      } else if (date.hour > 18 && date.hour <= 23) {
        firstString = "晚上 ";
      }
      result = firstString +
          "${date.hour}:${date.minute < 10 ? "0" + date.minute.toString() : date.minute}";
    }
    return result;
  }

  /// 普通询问弹窗
  /// * [title] 标题
  /// * [content] 内容
  /// * [cancelText] 撤销文字 默认 = 取消
  /// * [confirmText] 确定文字 默认 = 确定
  static void alert(
    context, {
    String title = "温馨提示！",
    dynamic content,
    String cancelText = '取消',
    String confirmText = '确定',
    bool isConfirmPop = true,
    VoidCallback onCancel,
    VoidCallback onConfirm,
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          ThemeData themeData = Theme.of(context);
          return CupertinoAlertDialog(
            title: title.isEmpty
                ? null
                : Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(title,
                        style:
                            themeData.textTheme.title.copyWith(fontSize: 16.0)),
                  ),
            content: content is Widget ? content : Text('$content'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(cancelText),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  if (onCancel != null) onCancel();
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  confirmText,
                  style: TextStyle(color: themeData.primaryColor),
                ),
                isDefaultAction: true,
                onPressed: () {
                  if (isConfirmPop) Navigator.pop(context);
                  if (onConfirm != null) onConfirm();
                },
              ),
            ],
          );
        });
  }
}
