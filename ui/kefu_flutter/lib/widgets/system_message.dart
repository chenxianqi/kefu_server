import 'package:flutter/material.dart';
import '../models/im_message.dart';

class SystemMessage extends StatelessWidget {
  SystemMessage({this.message, this.isSelf});
  final ImMessage message;
  final bool isSelf;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.0),
      child: Container(
        height: 23.0,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        constraints: BoxConstraints(
          minWidth: 200.0,
        ),
        alignment: Alignment.center,
        child: DefaultTextStyle(
            style: TextStyle(color: Colors.black38),
            child: Builder(builder: (_) {
              switch (message.bizType) {
                case "cancel":
                  return Text(isSelf ? "您撤回了一条消息" : "对方撤回了一条消息");
                case "end":
                  return Text("本次会话结束，感谢您的耐心与支持！");
                case "transfer":
                  return Text('已为您接入${message.transferAccount}号客服');
                case "timeout":
                  return Text('由于您长时间未回复，系统结束了本次会话');
                case "system":
                  return Text('${message.payload}');
                default:
                  return SizedBox();
              }
            })),
      ),
    );
  }
}
