import 'package:flutter/material.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'date_widget.dart';

class TextMessage extends StatelessWidget {
  TextMessage({this.message, this.onCancel, this.onOperation, this.isSelf});
  final ImMessageModel message;
  final VoidCallback onCancel;
  final VoidCallback onOperation;
  final bool isSelf;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    Widget _avatar(bool show) {
      return Offstage(
          offstage: !show,
          child: Avatar(
            imgUrl: message.avatar,
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
        margin: EdgeInsets.only(bottom: ToPx.size(30)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            _avatar(!isSelf),
            Padding(
              padding: EdgeInsets.only(
                  left: isSelf ? 0 : ToPx.size(15), right: isSelf ? ToPx.size(15) : 0),
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
                          margin: EdgeInsets.only(top: ToPx.size(8)),
                          constraints: BoxConstraints(maxWidth: ToPx.size(550),),
                          padding: EdgeInsets.symmetric(
                              horizontal: ToPx.size(20), vertical: ToPx.size(12)),
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
                                  fontSize: ToPx.size(28),
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
