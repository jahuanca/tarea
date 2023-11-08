import 'package:flutter/cupertino.dart';

class NavigationItem {
  String title;
  int value;
  dynamic icon;
  void Function() dependencies;
  Widget widget;

  NavigationItem({
    @required this.title,
    @required this.icon,
    @required this.value,
    @required dependencies,
    @required widget,
  });
}
