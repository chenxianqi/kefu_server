import 'package:flutter/material.dart';

import 'cached_network_image.dart';

class ImAvatar extends StatelessWidget {
  ImAvatar({this.avatar});

  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 33.0,
        height: 33.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
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
        ),
        child: CachedImage(
            width: 30.0,
            radius: BorderRadius.all(Radius.circular(30.0)),
            height: 30.0,
            bgColor: Colors.transparent,
            src: avatar,
            fit: BoxFit.fill));
  }
}
