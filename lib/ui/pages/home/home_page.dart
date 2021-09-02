import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:flutter_tareo/ui/widgets/radio_group_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      //appBar: getAppBar('Inicio', true),
      backgroundColor: secondColor,
      body: Column(
        children: [
          Flexible(child: Container(
            padding: EdgeInsets.all(25),
            child: Image.asset('assets/images/ic_logo.png'),
          ), flex: 1),
          Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
                child: InputLabelWidget(
                  enabled: false,
                  label: 'Versión',
                  hintText: '1.1.0'),
              ),
              flex: 1),
          Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
                alignment: Alignment.center,
                child: RadioGroupWidget(
                  label: 'Modo',
                  value: 1,
                  items: [
                    {'index': 1, 'name': "Off-line"},
                    {'index': 2, 'name': 'On-line'},
                  ],
                  size: size,
                  onChanged: (value) {},
                ),
              ),
              flex: 2),
          Flexible(
              child: Container(
                alignment: Alignment.center,
                child: IconButton(
                    onPressed: () {},
                    icon: CircleAvatar(child: Icon(Icons.refresh))),
              ),
              flex: 1)
        ],
      ),
    );
  }
}
