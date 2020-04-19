
import 'package:kefu_workbench/core_flutter.dart';

class BottomBar extends StatelessWidget{
  BottomBar({
    this.isShowEmoJiPanel = false,
    this.onHideEmoJiPanel,
    this.onShowEmoJiPanel,
    this.onPickrImage,
    this.focusNode,
    this.editingController,
    this.onSubmit,
    this.onInputChanged,
    this.enabled = true,
    this.onToggleTransferPanel,
    this.onToggleShortcutPanel,
    this.isShowShortcutPanel,
  });
  final bool enabled;
  final bool isShowEmoJiPanel;
  final bool isShowShortcutPanel;
  final VoidCallback onHideEmoJiPanel;
  final VoidCallback onShowEmoJiPanel;
  final VoidCallback onToggleTransferPanel;
  final VoidCallback onToggleShortcutPanel;
  final VoidCallback onPickrImage;
  final FocusNode focusNode;
  final TextEditingController editingController;
  final VoidCallback onSubmit;
  final ValueChanged<String> onInputChanged;

  void _onSubmit(BuildContext context) {
    onSubmit();
    if(isShowEmoJiPanel) return;
    if(isShowShortcutPanel) return;
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  Widget build(BuildContext context) {
   ThemeData themeData = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: ToPx.size(20), vertical:ToPx.size(10),),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.withAlpha(60), width: .5),
            bottom: BorderSide(
                color: Colors.grey.withAlpha(isShowEmoJiPanel ? 60 : 0),
                width: .5),
          )),
      constraints: BoxConstraints(
        minHeight: 80.0,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            child: Row(
              children: <Widget>[
                GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.insert_emoticon,
                        color: Colors.black26,
                        size: ToPx.size(60),
                      ),
                    ),
                    onTap: isShowEmoJiPanel
                        ? onHideEmoJiPanel
                        : onShowEmoJiPanel),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(3.0),
                    child: Icon(
                      Icons.image,
                      color: Colors.black26,
                      size: ToPx.size(60),
                    ),
                  ),
                  onTap: onPickrImage,
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(3.0),
                    child: Icon(
                      Icons.assignment,
                      color: Colors.black26,
                      size: ToPx.size(58),
                    ),
                  ),
                  onTap: onToggleShortcutPanel,
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(3.0),
                    child: Icon(
                      Icons.swap_horizontal_circle,
                      color: Colors.black26,
                      size: ToPx.size(58),
                    ),
                  ),
                  onTap: onToggleTransferPanel,
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Container(
                      constraints: BoxConstraints(minHeight: ToPx.size(80)),
                      padding: EdgeInsets.symmetric(horizontal:ToPx.size(10)),
                      child: Input(
                        placeholder: enabled ? "请输入内容~" : "当前会话已结束~",
                        focusNode: focusNode,
                        controller: editingController,
                        minLines: 1,
                        enabled: enabled,
                        maxLines: 5,
                        maxLength: 200,
                        border: Border.all(style: BorderStyle.none, width: 0.0),
                        onEditingComplete: () => _onSubmit(context),
                        textInputAction: Platform.isIOS
                            ? TextInputAction.send
                            : TextInputAction.newline,
                        onChanged: (String value) {
                          onInputChanged(value);
                        },
                      ))),
              Offstage(
                offstage: (Platform.isIOS && !isShowEmoJiPanel) && (Platform.isIOS && !isShowShortcutPanel),
                child: Center(
                  child: SizedBox(
                    width: 60.0,
                    child: Button(
                      width: ToPx.size(100),
                      height: ToPx.size(60),
                      color: Theme.of(context).primaryColor,
                      onPressed:  () => _onSubmit(context),
                      child: Text(
                        "发送",
                        style: themeData.textTheme.title.copyWith(
                          color: themeData.primaryColorLight
                        )
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}