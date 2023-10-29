import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';

class EmptyDataWidget extends StatelessWidget {
  final String titulo;
  final void Function() onPressed;
  final Size size;

  EmptyDataWidget({@required this.titulo, @required this.size, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(titulo),
          ),
          SizedBox(height: size.height * 0.025),
          Container(
            child: CircleAvatar(
              backgroundColor: infoColor,
              child:
                  IconButton(onPressed: onPressed, icon: Icon(Icons.refresh)),
            ),
          ),
        ],
      ),
    );
  }
}
