import 'package:kefu_workbench/core_flutter.dart';
import 'package:kefu_workbench/resources/emoji.dart';


typedef EmoJiPanelCallback(String emoji);

class EmoJiPanel extends StatelessWidget {
  EmoJiPanel({this.isShow = false, this.onSelected});
  final bool isShow;
  final EmoJiPanelCallback onSelected;
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !isShow,
      child: Container(
        width: double.infinity,
        height: ToPx.size(500),
        color: Colors.white,
        child: GridView.builder(
            itemCount: emojis.length,
            padding: EdgeInsets.all(6.0),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 11),
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () => onSelected(emojis[index]),
                child: Text(
                  "${emojis[index]}",
                  style: TextStyle(fontSize: Platform.isAndroid ? 25 : 30),
                ),
              );
            }),
      ),
    );
  }
}
