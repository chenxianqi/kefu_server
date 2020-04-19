import 'package:flutter/material.dart';
import 'package:kefu_workbench/models/index.dart';
import 'package:kefu_workbench/utils//index.dart';

class SystemMessage extends StatelessWidget {
  SystemMessage({this.message, this.isSelf});
  final ImMessageModel message;
  final bool isSelf;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: ToPx.size(30)),
      child: Container(
        height: ToPx.size(45),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: ToPx.size(20)),
        alignment: Alignment.center,
        child: DefaultTextStyle(
            style: themeData.textTheme.caption,
            child: Builder(builder: (_) {
              switch (message.bizType) {
                case "cancel":
                  return Text(isSelf ? "您撤回了一条消息" : "对方撤回了一条消息");
                case "end":
                  return Text(isSelf ? "你结束了会话" : "对方结束了会话");
                case "timeout":
                case "system":
                case "transfer":
                  return Text('${message.payload}');
                default:
                  return SizedBox();
              }
            })),
      ),
    );
  }
}
