import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              height: 2,
              color: primaryColor,
            ),
            flex: 1,
          ),
          Flexible(
            child: Container(
              child: Text(
                'O',
              ),
            ),
            flex: 1,
          ),
          Flexible(
            child: Container(
              height: 2,
              color: primaryColor,
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
