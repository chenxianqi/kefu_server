import '../core_flutter.dart';

class DatePicker extends StatefulWidget {
  DatePicker({@required this.context,  this.initDate, this.maximumDate, this.maximumYear});

  final DateTime initDate;
  final DateTime maximumDate;
  final int maximumYear;
  final BuildContext context;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<DatePicker> {
  DateTime selected;

  @override
  void initState() {
    super.initState();
    if (mounted) selected = widget.initDate;
  }

  // 日期选择
  Widget _buildBottomPicker(Widget picker) {
    ThemeData themeData = Theme.of(widget.context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.bottomCenter,
      child: Container(
        height: ToPx.size(850),
        color: CupertinoColors.white,
        child: Column(
          children: <Widget>[
            Container(
                height: ToPx.size(120),
                decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border(
                        bottom: BorderSide(color: themeData.dividerColor))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Button(
                      color: Colors.transparent,
                      useIosStyle: true,
                      onPressed: () => Navigator.of(context).pop(null),
                      width: ToPx.size(150),
                      height: ToPx.size(120),
                      child: Text('取消',style: themeData.textTheme.body1),
                    ),
                    Text(''),
                    Button(
                      color: Colors.transparent,
                      useIosStyle: true,
                      onPressed: () =>  Navigator.of(context).pop(selected),
                      width: ToPx.size(150),
                      height: ToPx.size(120),
                      child: Text('确定', style: themeData.textTheme.body1.copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ],
                )),
            Expanded(
              child: DefaultTextStyle(
                style: themeData.textTheme.body1.copyWith(fontSize: ToPx.size(50)),
                child: GestureDetector(
                  onTap: () {},
                  child: SafeArea(
                    top: false,
                    child: picker,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBottomPicker(
      CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: widget.initDate,
        maximumDate: widget.maximumDate,
        maximumYear: widget.maximumYear,
        onDateTimeChanged: (DateTime newDate) {
          setState(() {
            selected = newDate;
          });
        },
      ),
    );
  }
}
