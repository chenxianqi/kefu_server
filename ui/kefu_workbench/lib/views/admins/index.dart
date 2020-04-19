import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/admin.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:provider/provider.dart';

class AdminsPage extends StatelessWidget {
  final Map<dynamic, dynamic> arguments;
  AdminsPage({this.arguments});

  @override
  Widget build(_) {
    return ChangeNotifierProvider<AdminProvide>(
      create: (_) => AdminProvide.getInstance(),
      child: Consumer<AdminProvide>(builder: (context, adminState, _){
         return PageContext(builder: (context){
            ThemeData themeData = Theme.of(context);
            Color lineColor(int online){
                return online == 1  ? Colors.green[400] : online == 0 ? Colors.grey : online == 2 ? Colors.amber : Colors.grey;
            }
            return Scaffold(
              backgroundColor: themeData.primaryColorLight,
              appBar: customAppBar(
                  title: Text(
                    "客服列表(${adminState.usersTotal}人)",
                    style: themeData.textTheme.display1,
                  ),
                  actions: [
                    Offstage(
                      offstage: GlobalProvide.getInstance()?.serviceUser?.root != 1,
                      child:  Button(
                      height: ToPx.size(90),
                      useIosStyle: true,
                      color: Colors.transparent,
                      width: ToPx.size(150),
                      child: Text("新增"),
                      onPressed: () => adminState.goAdd(context)
                    )),
                  ],
                ),
              body: adminState.isLoading && adminState.admins.length == 0 ? Center(
                child: loadingIcon(size: ToPx.size(50)),
              ): 
              RefreshIndicator(
                color: themeData.primaryColorLight,
                backgroundColor: themeData.primaryColor,
                onRefresh: adminState.onRefresh,
                child: CustomScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                controller: adminState.scrollController,
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
                                onEditingComplete: adminState.onSearch,
                                textInputAction: TextInputAction.done,
                                controller: adminState.searchTextEditingController,
                                border: Border.all(style: BorderStyle.none, color: Colors.transparent),
                                padding: EdgeInsets.symmetric(horizontal: ToPx.size(20)),
                                placeholder: "请输入关键词查找客服~",
                                onChanged: (value){
                                  if(value.trim().isEmpty){
                                    adminState.isLoadEnd = false;
                                    adminState.pageOn = 0;
                                    adminState.keyword = "";
                                    adminState.getAdmins();
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(CupertinoIcons.search, color: Colors.grey,),
                              onPressed: adminState.onSearch,
                            )
                          ],
                        ),
                      )
                    ],),
                  ),
                    SliverToBoxAdapter(
                      child: Offstage(
                        offstage: adminState.admins.length > 0 || adminState.isLoading,
                        child: Padding(
                          padding: EdgeInsets.only(top: ToPx.size(50)),
                          child: Text("暂无数据~", style: themeData.textTheme.body1, textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index){
                        AdminModel admin = adminState.admins[index];
                        return Column(
                          children: <Widget>[
                            ListTile(
                              onTap: () => Navigator.pushNamed(context, "/admin_detail",arguments: {
                                "admin": admin
                              }),
                              subtitle: Row(
                                children: <Widget>[
                                  Text("最后在线时间：", style: themeData.textTheme.caption),
                                  Text("${Utils.epocFormat(admin.lastActivity)}")
                                ],
                              ),
                              trailing: Text(
                                admin.online == 0 ? " 离线" :
                                admin.online == 1 ? " 在线" :
                                admin.online == 2 ? " 离开" : "未知",
                                style: themeData.textTheme.caption.copyWith(
                                fontSize: ToPx.size(22),
                                color: lineColor(admin.online)
                              ),),
                              leading: Avatar(
                                size: ToPx.size(100),
                                imgUrl: admin.avatar == null || admin.avatar.isEmpty ?
                                "http://qiniu.cmp520.com/avatar_default.png" : admin.avatar
                              ),
                              title: Text("${admin.nickname}", style: themeData.textTheme.title, maxLines: 2, overflow: TextOverflow.ellipsis,),
                            ),
                            Divider(height: 1.0,)
                          ],
                        );
                      },
                      childCount: adminState.admins.length
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
                        offstage: !adminState.isLoading || adminState.isLoadEnd
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
                        offstage: !adminState.isLoadEnd || adminState.admins.length == 0
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

