import 'package:flutter/material.dart';
import '../models/im_message.dart';
import 'date_widget.dart';
import 'im_avatar.dart';

class TextMessage extends StatelessWidget {
  TextMessage({this.message, this.onCancel, this.onOperation, this.isSelf});
  final ImMessage message;
  final VoidCallback onCancel;
  final VoidCallback onOperation;
  final bool isSelf;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    Widget _avatar(bool show) {
      return Offstage(
          offstage: !show,
          child: ImAvatar(
            avatar: message.avatar,
          ));
    }

    Widget _cancel() {
      return Offstage(
        offstage: !message.isShowCancel,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: onCancel,
              child:
                  Text(" 撤回 ", style: TextStyle(color: themeData.primaryColor)),
            ),
          ],
        ),
      );
    }

    Widget msgWidget() {
      return Container(
        margin: EdgeInsets.only(bottom: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            _avatar(!isSelf),
            Padding(
              padding: EdgeInsets.only(
                  left: isSelf ? 0 : 7.0, right: isSelf ? 7.0 : 0),
              child: Column(
                crossAxisAlignment:
                    isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      _cancel(),
                      GestureDetector(
                        onLongPress: onOperation,
                        child: Container(
                          margin: EdgeInsets.only(top: 3.0),
                          constraints: BoxConstraints(maxWidth: 290.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                              color: isSelf
                                  ? themeData.primaryColor
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0.0, 3.0),
                                  color: Colors.black26.withAlpha(5),
                                  blurRadius: 4.0,
                                ),
                                BoxShadow(
                                  offset: Offset(0.0, 3.0),
                                  color: Colors.black26.withAlpha(5),
                                  blurRadius: 4.0,
                                ),
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0))),
                          child: Text("${message.payload}",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: isSelf
                                      ? Colors.white
                                      : Colors.black87.withAlpha(180))),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            _avatar(isSelf),
          ],
        ),
      );
    }

    return Column(
      children: <Widget>[
        Offstage(
          offstage: !message.isShowDate,
          child: DateWidget(
            date: message.timestamp,
          ),
        ),
        msgWidget()
      ],
    );
  }
}
