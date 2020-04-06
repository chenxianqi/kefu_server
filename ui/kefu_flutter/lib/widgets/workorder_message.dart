import 'package:flutter/material.dart';
import 'package:kefu_flutter/workorder/create.dart';
import '../models/im_message.dart';
import 'date_widget.dart';
import 'im_avatar.dart';

class WorkorderMessage extends StatelessWidget {
  WorkorderMessage({this.message});
  final ImMessage message;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    bool isDark = themeData.brightness == Brightness.dark;

    Widget _avatar() {
      return ImAvatar(
        avatar: message.avatar,
      );
    }

    // _goToCreateWprkOrder
    void _goToCreateWprkOrder() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateWorkOrder()));
    }

    Widget msgWidget() {
      return Container(
        margin: EdgeInsets.only(bottom: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _avatar(),
            Padding(
              padding: EdgeInsets.only(left: 7.0, right: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 3.0),
                          constraints: BoxConstraints(maxWidth: 290.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                              color: isDark
                                  ? themeData.dividerColor
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("${message.payload}",
                                  style: themeData.textTheme.title.copyWith(
                                      color: themeData.textTheme.title.color,
                                      fontSize: 15.0)),
                              GestureDetector(
                                onTap: _goToCreateWprkOrder,
                                child: Text(
                                  "创建工单",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: themeData.primaryColor),
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                ],
              ),
            ),
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
