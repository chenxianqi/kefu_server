import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:kefu_workbench/provider/user.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  final Map<dynamic, dynamic> arguments;
  UsersPage({this.arguments});

  @override
  Widget build(_) {
    return ChangeNotifierProvider<UserProvide>(
      create: (_) => UserProvide.getInstance(),
      child: Consumer<UserProvide>(builder: (context, userState, _){
         return PageContext(builder: (context){
            ThemeData themeData = Theme.of(context);
            return Scaffold(
              backgroundColor: themeData.primaryColorLight,
              appBar: customAppBar(
                  title: Text(
                    "用户列表(${userState.usersTotal}人)",
                    style: themeData.textTheme.display1,
                  ),
                ),
              body: 
              userState.isLoading && userState.users.length == 0 ? Center(
                child: loadingIcon(size: ToPx.size(50)),
              ): 
              RefreshIndicator(
                color: themeData.primaryColorLight,
                backgroundColor: themeData.primaryColor,
                onRefresh: userState.onRefresh,
                child: CustomScrollView(
                controller: userState.scrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: themeData.dividerColor, width: ToPx.size(2)))
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Input(
                                onEditingComplete: userState.onSearch,
                                textInputAction: TextInputAction.search,
                                controller: userState.searchTextEditingController,
                                border: Border.all(style: BorderStyle.none, color: Colors.transparent),
                                padding: EdgeInsets.symmetric(horizontal: ToPx.size(20)),
                                placeholder: "请输入关键词查找用户~",
                                onChanged: (value){
                                  if(value.trim().isEmpty){
                                    userState.isLoadEnd = false;
                                    userState.pageOn = 0;
                                    userState.keyword = "";
                                    userState.getUsers();
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(CupertinoIcons.search, color: Colors.grey),
                              onPressed: userState.onSearch,
                            )
                          ],
                        ),
                      )
                    ],),
                  ),
                    SliverToBoxAdapter(
                      child: Offstage(
                        offstage: userState.users.length > 0 || userState.isLoading,
                        child: Padding(
                          padding: EdgeInsets.only(top: ToPx.size(50)),
                          child: Text("暂无数据~", style: themeData.textTheme.body1, textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index){
                        UserModel user = userState.users[index];
                        return Column(
                          children: <Widget>[
                            ListTile(
                              onTap: () => Navigator.pushNamed(context, "/user_detail",arguments: {
                                "user": user
                              }),
                              subtitle: Row(
                                children: <Widget>[
                                  Text("所在平台：", style: themeData.textTheme.caption),
                                  Expanded(child: Text("${GlobalProvide.getInstance().getPlatformTitle(user.platform)}", style: themeData.textTheme.caption, overflow: TextOverflow.ellipsis,))
                                ],
                              ),
                              trailing: Text("${Utils.formatDate(user.createAt)}"),
                              leading: Avatar(
                                size: ToPx.size(100),
                                imgUrl: user.avatar == null || user.avatar.isEmpty ?
                                "http://qiniu.cmp520.com/avatar_default.png" : user.avatar
                              ),
                              title: Text("${user.nickname}", style: themeData.textTheme.title, maxLines: 2, overflow: TextOverflow.ellipsis,),
                            ),
                            Divider(height: 1.0,)
                          ],
                        );
                      },
                      childCount: userState.users.length
                     ),
                    ),
                    SliverToBoxAdapter(
                      child: Offstage(
                        child: Center(
                          child: SizedBox(
                            height: ToPx.size(150),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                loadingIcon(),
                                Text('  内容加载中...',
                                    style: themeData.textTheme.caption)
                              ],
                            ),
                          ),
                        ),
                        offstage: !userState.isLoading || userState.isLoadEnd
                      )
                    ),
                    SliverToBoxAdapter(
                      child: Offstage(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: ToPx.size(40)),
                          child: Center(
                              child: Text(
                                  '没有更多了', style: themeData.textTheme.caption)
                          ),),
                        offstage: !userState.isLoadEnd || userState.users.length == 0
                      )
                    ),
                ],
              )
              ),
            );
          });
      },),
    );

  }
}

