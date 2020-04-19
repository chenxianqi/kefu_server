import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:provider/provider.dart';

class ChatEndDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    GlobalProvide  globalState = Provider.of<GlobalProvide>(context);
    ContactModel currentContact = globalState.currentContact;
    Color lineColor = currentContact?.online == 1  ? Colors.green[400] : Colors.grey;

    Widget _listTile({
      String title,
      String context
    }){
      return Container(
        padding: EdgeInsets.only(left: ToPx.size(40), right:  ToPx.size(20), top: ToPx.size(20), bottom:  ToPx.size(20)),
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("$title", style: themeData.textTheme.title.copyWith(
              color: Colors.white
            ),),
            Expanded(
              child: Text("$context", style: themeData.textTheme.title.copyWith(
              color: Colors.white
            ),),
            )
          ],
        ),
      );
    }

    Widget _userInfo(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: ToPx.size(30), bottom: ToPx.size(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Avatar(
                  size: ToPx.size(130),
                  imgUrl: currentContact == null || currentContact.avatar.isEmpty ? 
                      "http://qiniu.cmp520.com/avatar_default.png" : currentContact.avatar,
                ),
               Padding(
                 padding: EdgeInsets.only(top: ToPx.size(20)),
                 child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("${currentContact?.nickname}  ", style: themeData.textTheme.display1,),
                      Container(
                        width: ToPx.size(10),
                        height: ToPx.size(10),
                        decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lineColor
                      ),
                      ),
                      Text(
                        currentContact?.online == 0 ? " 离线" : " 在线",
                        style: themeData.textTheme.caption.copyWith(
                        fontSize: ToPx.size(22),
                        color: lineColor
                      ),
                      ),
                    ],
                  )
               )
              ],
            )
          ),
          Divider(color: Colors.black.withAlpha(50)),
          Expanded(
            child: Column(
              children: <Widget>[
                  _listTile(
                    title: "   用户 ID：",
                    context: "${currentContact?.fromAccount}"
                  ),
                  _listTile(
                    title: "所在地区：",
                    context: "${currentContact.address.isEmpty ? "未知的位置信息" : currentContact.address}"
                  ),
                  _listTile(
                    title: "联系方式：",
                    context: "${currentContact.phone.isEmpty ? "暂无联系方式" : currentContact.phone}"
                  ),
                  _listTile(
                    title: "所在平台：",
                    context: "${globalState.getPlatformTitle(currentContact.platform)}"
                  ),
                  _listTile(
                    title: "创建时间：",
                    context: "${Utils.epocFormat(currentContact?.createAt)}"
                  ),
                  _listTile(
                    title: "备注信息：",
                    context: "${currentContact.remarks.isEmpty ? "暂无备注信息" : currentContact?.remarks}"
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Button(
                            margin: EdgeInsets.only(bottom: ToPx.size(50)),
                            color: themeData.primaryColorDark,
                            width: ToPx.size(220),
                            height: ToPx.size(60),
                            onPressed: () => Navigator.popAndPushNamed(context, "/user_edit", arguments: {
                              "user": UserModel.fromJson(currentContact.toJson())
                            }),
                            child: Text(
                              "编辑用户信息",
                              style: themeData.textTheme.title
                                  .copyWith(color: themeData.primaryColorLight),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          )
        ]
      );
    }

    return Container(
      color: themeData.primaryColor,
      padding: EdgeInsets.only(top: ToPx.size(30)),
      child: DefaultTabController(
        length: 1,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: ToPx.size(70),
              child: TabBar(
              labelColor: Colors.amber,
              isScrollable: true,
              labelStyle: themeData.textTheme.caption.copyWith(color:  themeData.primaryColor, fontWeight: FontWeight.w500),
              unselectedLabelColor: themeData.accentColor,
              indicatorWeight: ToPx.size(3),
              tabs: <Widget>[
                Tab(
                  child: Text("用户信息"),
                ),
              ],
            ),),
            Divider(height: 0.0,color: Colors.black.withAlpha(50)),
            Expanded(
              child: TabBarView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
              _userInfo(),
            ],),
            )
          ],
        )
      ),
    );
  }
}
