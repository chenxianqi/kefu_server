import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/im_message.dart';
import '../models/knowledge_model.dart';
import 'date_widget.dart';
import 'im_avatar.dart';

typedef SendKnowledgeMessage(KnowledgeModel message);

class KnowledgeMessage extends StatelessWidget {
  KnowledgeMessage({this.message, this.onSend});
  final ImMessage message;
  final SendKnowledgeMessage onSend;
  bool get isSelf {
    return true;
  }

  List<KnowledgeModel> get knowledgeModelList =>
      ((json.decode(message.payload) as List)
          .map((i) => KnowledgeModel.fromJson(i))
          .toList())
        ..add(KnowledgeModel(title: "以上都不是？我要找人工"));

  @override
  Widget build(BuildContext context) {
    Widget msgWidget() {
      return Container(
        margin: EdgeInsets.only(bottom: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ImAvatar(
              avatar: message.avatar,
            ),
            Padding(
              padding: EdgeInsets.only(left: 7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 3.0),
                    width: 290.0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("以下是您关心的相关问题？",
                            style: TextStyle(
                                color: Colors.black87.withAlpha(180),
                                fontSize: 16.0)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              knowledgeModelList.map((KnowledgeModel item) {
                            return GestureDetector(
                              onTap: () => onSend(item),
                              child: DefaultTextStyle(
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 15.0),
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
                                  )),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )
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
