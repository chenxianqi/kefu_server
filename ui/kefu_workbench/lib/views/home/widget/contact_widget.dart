import 'package:flutter/gestures.dart';
import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/provider/home.dart';
import 'package:provider/provider.dart';

class ContactWidget extends StatelessWidget{
  ContactWidget(this.contact);
  final ContactModel contact;
  @override
  Widget build(BuildContext context) {
     ThemeData themeData = Theme.of(context);
     HomeProvide homeState = Provider.of<HomeProvide>(context);
     GlobalProvide globalProvide = Provider.of<GlobalProvide>(context);
      return Dismissible(
        dragStartBehavior: DragStartBehavior.down,
        direction: DismissDirection.endToStart,
        confirmDismiss: (DismissDirection direction) async {
          if (direction.index != 2) return false;
          globalProvide.removeSingleContact(contact.cid);
          return true;
        },
        secondaryBackground: Container(
          color: Colors.red.withAlpha(200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                width: ToPx.size(150),
              ),
            ],
          ),
        ),
        background: Container(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              onTap: () => homeState.selectContact(contact),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${contact.nickname}",
                    style: themeData.textTheme.title,
                  ),
                  Text(
                    "${Utils.epocFormat(contact?.contactCreateAt)}",
                    style: themeData.textTheme.caption,
                  ),
                ],
              ),
              leading: SizedBox(
                width: ToPx.size(100),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: 
                      contact.avatar.isEmpty ?
                      Container(
                        width: ToPx.size(90),
                        height: ToPx.size(90),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffc0c4cb)
                        ),
                        child: Text("访", style: themeData.textTheme.display1),
                      ) :
                      Avatar(
                        size: ToPx.size(90),
                        imgUrl:
                            "${contact.avatar.isEmpty ? 'http://qiniu.cmp520.com/avatar_default.png' : contact.avatar}",
                      ),
                    ),
                    Offstage(
                      offstage: contact.read == 0,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.only(top: ToPx.size(5)),
                          child: Center(
                            child: Text(
                              "${contact.read}",
                              style: themeData.textTheme.caption
                                  .copyWith(
                                      color: Colors.white,
                                      fontSize: ToPx.size(20)),
                            ),
                          ),
                          width: ToPx.size(35),
                          height: ToPx.size(35),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.only(bottom: ToPx.size(15), right: ToPx.size(13)),
                        width: ToPx.size(16),
                        height: ToPx.size(16),
                        decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: contact.online == 0 ? Colors.grey : Colors.green[400]
                      ),
                      ),
                    )
                  ],
                ),
              ),
              subtitle: Text(
                contact.lastMessageType == "text"
                ? contact.lastMessage
                : contact.lastMessageType == "photo"
                ? "图片"
                : contact.lastMessageType == "video"
                ? "视频"
                : contact.lastMessageType == "end"
                ? "会话结束"
                : contact.lastMessageType == "timeout"
                ? "会话超时，结束对话"
                : contact.lastMessageType ==
                "transfer"
                ? "客服转接..."
                : contact.lastMessageType ==
                "system"
                ? "系统提示..."
                : contact.lastMessageType ==
                "cancel"
                ? "撤回了消息"
                : "未知消息内容~",
                style: themeData.textTheme.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Divider(
              height: 1.0,
            )
          ],
        ),
        key: GlobalKey(),
      );
  }
}