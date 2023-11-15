import 'package:flutter/cupertino.dart';

class NavigationItem {
  String title;
  int value;
  dynamic icon;
  void Function() dependencies;
  dynamic widget;

  NavigationItem({
    @required this.title,
    @required this.icon,
    @required this.value,
    @required this.dependencies,
    @required this.widget,
  });
}
