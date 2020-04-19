import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/provider/chat.dart';
import 'package:kefu_workbench/provider/global.dart';
import 'package:provider/provider.dart';

import 'widget/bottom_bar.dart';
import 'widget/emoji_panel.dart';
import 'widget/end_drawer.dart';
import 'widget/knowledge_message.dart';
import 'widget/photo_message.dart';
import 'widget/shortcut_panel.dart';
import 'widget/system_message.dart';
import 'widget/text_message.dart';
import 'widget/transfer_panel.dart';


class ChatPage extends StatelessWidget {
  final Map<dynamic, dynamic> arguments;
  ChatPage({this.arguments});
  void openDrawer(context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(_) {
    bool isReadOnly = arguments['isReadOnly'] ?? false;
    int accountId = arguments['accountId'];
    int serviceId = arguments['serviceId'];
    int userId = arguments['userId'];
    String title = arguments['title'];
    ChatProvide chatProvide = ChatProvide.getInstance(isReadOnly: isReadOnly, accountId: accountId, serviceId: serviceId, userId: userId);
    return ChangeNotifierProvider<ChatProvide>(
      create: (_) => chatProvide,
      child: Consumer<ChatProvide>(
        builder: (context, chatState , _){
        return PageContext(builder: (context){
          ThemeData themeData = Theme.of(context);
          return Consumer<GlobalProvide>(
          builder: (context, globalState, _){
             List<ImMessageModel> messagesRecords = globalState.currentUserMessagesRecords(chatState.accountId);
            return Scaffold(
                appBar: customAppBar(
                  title: Text(
                    title ?? (globalState.isPong ? "对方正在输入..." : "${globalState.currentContact?.nickname}"),
                    style: themeData.textTheme.display1,
                  ),
                  actions: [
                    Offstage(
                      offstage:chatState.isReadOnly || globalState.currentContact == null || globalState.currentContact?.isSessionEnd == 1,
                      child: Button(
                      useIosStyle: true,
                      width: ToPx.size(110),
                      color: Colors.transparent,
                      onPressed: () => chatState.onShowEndMessageAlert(context),
                      child: Text("结束会话", style: themeData.textTheme.caption.copyWith(
                        color: Colors.amber
                      ),),
                    ),
                    ),
                    Offstage(
                      offstage: chatState.isReadOnly,
                      child: Builder(
                      builder: (ctx) {
                        return IconButton(
                          icon: Icon(Icons.person_pin),
                          onPressed: ()=>openDrawer(ctx),
                        );
                    })
                    )
                    
                  ]
                ),
                body: Column(children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onPanDown: (_) {
                        chatState.onToggleShortcutPanel(false);
                        chatState.onHideEmoJiPanel();
                        chatState.onToggleTransferPanel(false);
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: 
                      chatState.isChatFullLoading ?
                      Center(
                        child: loadingIcon(size: ToPx.size(50)),
                      ) :
                      CustomScrollView(
                        controller: chatState.scrollController,
                        reverse: true,
                        slivers: <Widget>[
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20.0),
                            sliver: SliverList(
                                delegate: SliverChildBuilderDelegate((ctx, i) {
                                int index = messagesRecords.length - i - 1;
                              ImMessageModel _msg = messagesRecords[index];
                              /// 判断是否需要显示时间
                              if (i == messagesRecords.length - 1 || (_msg.timestamp - 120) > messagesRecords[index - 1].timestamp) {
                                _msg.isShowDate = true;
                              }
                              switch (_msg.bizType) {
                                case "text":
                                case "welcome":
                                  return TextMessage(
                                    message: _msg,
                                    isSelf: _msg.fromAccount != (accountId ?? globalState.currentContact.fromAccount),
                                    onCancel: () => chatState.onCancelMessage(_msg),
                                    onOperation: () => chatState.onOperation(context, _msg),
                                  );
                                case "photo":
                                  return PhotoMessage(
                                    message: _msg,
                                    isSelf:
                                        _msg.fromAccount == globalState.serviceUser.id,
                                    onCancel: () => chatState.onCancelMessage(_msg),
                                    onOperation: () => chatState.onOperation(context, _msg),
                                  );
                                case "end":
                                case "transfer":
                                case "cancel":
                                case "timeout":
                                case "system":
                                  return SystemMessage(
                                    message: _msg,
                                    isSelf: _msg.fromAccount == globalState.serviceUser.id,
                                  );
                                case "knowledge":
                                  return KnowledgeMessage(
                                    message: _msg,
                                    onOperation: () => chatState.onOperation(context, _msg),
                                  );
                                default:
                                  return SizedBox();
                              }
                            }, childCount: messagesRecords.length)),
                          ),
                          SliverToBoxAdapter(
                            child: Offstage(
                              offstage: !globalState.isLoadingMorRecord,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Platform.isAndroid
                                        ? SizedBox(
                                            width: 10.0,
                                            height: 10.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                            ))
                                        : CupertinoActivityIndicator(),
                                    Text(
                                      "  加载更多",
                                      style: TextStyle(color: Colors.black38),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  chatState.isReadOnly ?
                  SizedBox() :
                  Container(
                    color: Colors.white,
                    child: SafeArea(
                      top: false,
                      child: Column(
                        children: <Widget>[
                          Offstage(
                            offstage: globalState.advanceText.isEmpty || globalState.advanceText == "",
                            child: Container(
                            width: double.infinity,
                            color: Colors.grey.withAlpha(80),
                            padding: EdgeInsets.symmetric(horizontal: ToPx.size(20), vertical: ToPx.size(20)),
                            child: Text("客户输入：${globalState.advanceText}...", style: themeData.textTheme.caption,),
                          ),
                          ),
                          BottomBar(
                            editingController: chatState.editingController,
                            focusNode: chatState.focusNode,
                            onSubmit: chatState.onSubmit,
                            isShowEmoJiPanel: chatState.isShowEmoJiPanel,
                            isShowShortcutPanel: chatState.isShowShortcutPanel,
                            onShowEmoJiPanel: chatState.onShowEmoJiPanel,
                            onHideEmoJiPanel: chatState.onHideEmoJiPanel,
                            onInputChanged: chatState.onInputChanged,
                            onPickrImage: () => chatState.onPickImage(context),
                            enabled: globalState.currentContact.isSessionEnd == 0,
                            onToggleShortcutPanel: () => chatState.onToggleShortcutPanel(!chatState.isShowShortcutPanel),
                            onToggleTransferPanel: () => chatState.onToggleTransferPanel(!chatState.isShowTransferPanel),
                          ),
                          EmoJiPanel(
                            isShow: chatState.isShowEmoJiPanel,
                            onSelected: (value){
                              chatState.editingController.text = chatState.editingController.value.text + value;
                              chatState.editingController.selection = 
                              TextSelection.collapsed(offset: chatState.editingController.value.text.length);
                            },
                          ),
                          ShortcutPanel(
                            onSelected: chatState.onSelectedShortcut,
                            listData: globalState.shortcuts,
                            isShow: chatState.isShowShortcutPanel,
                          ),
                          TransferPanel(
                            onSelected: chatState.onSelectedSeviceUser,
                            listData: chatState.serviceOnlineUsers,
                            isShow: chatState.isShowTransferPanel,
                          ),
                        ],
                      ),
                    ),
                  )
                ],),
                endDrawer: globalState.currentContact == null || chatState.isReadOnly ? null : Drawer(
                  child: ChatEndDrawer(),
                ),
              );
            });
        });
      },
  ));

  }
}
