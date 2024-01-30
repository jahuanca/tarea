import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/utils/item_action.dart';

List<Widget> getItemsActions({
  List<ItemAction> actions,
}) {
  List<Widget> widgets = [];
  actions.forEach((e) {
    widgets.add(Flexible(child: Container(), flex: 1));
    widgets.add(Container(
      alignment: Alignment.center,
      child: CircleAvatar(
        backgroundColor: e.backgroundColor,
        child: IconButton(
            onPressed: e.action,
            icon: Icon(
              e.icon,
              color: Colors.white,
            )),
      ),
    ));
  });

  widgets.add(Flexible(child: Container(), flex: 1));

  return widgets;
}
