import 'package:flutter/cupertino.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';

class ItemAction {
  IconData icon;
  Color backgroundColor;
  Function action;
  bool isShow;

  ItemAction(
      {@required this.icon,
      @required this.backgroundColor,
      @required this.action,
      this.isShow = BOOLEAN_TRUE_VALUE});
}
