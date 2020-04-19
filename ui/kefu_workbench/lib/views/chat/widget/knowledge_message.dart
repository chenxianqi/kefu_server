import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'date_widget.dart';

typedef SendKnowledgeMessage(KnowledgeModel message);

class KnowledgeMessage extends StatelessWidget {
  KnowledgeMessage({this.message, this.onOperation});
  final ImMessageModel message;
  final VoidCallback onOperation;

  List<KnowledgeModel> get knowledgeModelList =>
      ((json.decode(message.payload) as List)
          .map((i) => KnowledgeModel.fromJson(i))
          .toList());

  @override
  Widget build(BuildContext context) {
     ThemeData themeData = Theme.of(context);
    Widget msgWidget() {
      return Container(
        margin: EdgeInsets.only(bottom: ToPx.size(30)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: ToPx.size(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: ToPx.size(8)),
                    width: ToPx.size(550),
                    padding:
                        EdgeInsets.symmetric(horizontal: ToPx.size(20), vertical: ToPx.size(10)),
                    decoration: BoxDecoration(
                        color: Colors.white,
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
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: GestureDetector(
                      onLongPress: onOperation,
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("以下是您关心的相关问题？", style: themeData.textTheme.title),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              knowledgeModelList.map((KnowledgeModel item) {
                            return DefaultTextStyle(
                                style: themeData.textTheme.body1,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 2.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 3.0),
                                        child: Text(
                                          " • ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text("${item.title}"),
                                      )
                                    ],
                                  ),
                                ));
                          }).toList(),
                        ),
                      ],
                    ),
                    ),
                  )
                ],
              ),
            ),
            Avatar(
              imgUrl: message.avatar,
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
