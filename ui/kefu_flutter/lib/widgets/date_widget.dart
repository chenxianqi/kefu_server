import 'package:flutter/material.dart';

import '../utils/im_utils.dart';

class DateWidget extends StatelessWidget {
  DateWidget({this.date});
  final int date;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      constraints: BoxConstraints(
        minWidth: 200.0,
      ),
      alignment: Alignment.center,
      child: Text(
        "${ImUtils.formatDate(date)}",
        style: TextStyle(color: Colors.black38),
      ),
    );
  }
}
