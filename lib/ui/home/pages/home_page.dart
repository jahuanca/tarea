import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/ui/home/controllers/home_controller.dart';
import 'package:flutter_tareo/ui/home/utils/constants.dart';
import 'package:flutter_tareo/ui/home/utils/strings_contants.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:flutter_tareo/ui/widgets/radio_group_widget.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<HomeController>(
      init: controller,
      builder: (_) => Scaffold(
        backgroundColor: secondColor,
        body: Column(
          children: [
            Flexible(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Image.asset(HOME_URL_LOGO),
                ),
                flex: ONE_INT_VALUE),
            Flexible(
                child: GetBuilder<HomeController>(
                  id: HOME_PAGE_ID_VERSION,
                  builder: (_) => Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * HOME_PADDING_VALUE),
                    child: InputLabelWidget(
                        enabled: BOOLEAN_FALSE_VALUE,
                        label: HOME_PAGE_LABEL_VERSION,
                        hintText: _.lastVersion),
                  ),
                ),
                flex: ONE_INT_VALUE),
            Flexible(
                child: GetBuilder<HomeController>(
                  id: HOME_PAGE_ID_VERSION,
                  builder: (_) => Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * HOME_PADDING_VALUE),
                    child: InputLabelWidget(
                        enabled: BOOLEAN_FALSE_VALUE,
                        label: HOME_PAGE_LABEL_LAST_CONNECTION,
                        hintText: _.lastVersionDate),
                  ),
                ),
                flex: ONE_INT_VALUE),
            Flexible(
                child: GetBuilder<HomeController>(
                  id: HOME_PAGE_ID_MODE,
                  builder: (_) => Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * HOME_PADDING_VALUE),
                    alignment: Alignment.center,
                    child: RadioGroupWidget(
                      label: HOME_PAGE_LABEL_MODE,
                      value: _.modo,
                      items: [
                        {'index': 0, 'name': "Off-line"},
                        {'index': 1, 'name': 'On-line'},
                      ],
                      size: size,
                      onChanged: _.changeModo,
                    ),
                  ),
                ),
                flex: TWO_INT_VALUE),
            Flexible(
                child: Container(
                  alignment: Alignment.center,
                  child: GetBuilder<HomeController>(
                    id: HOME_PAGE_ID_REFRESH,
                    builder: (_) => CircleAvatar(
                        backgroundColor:
                            _.modo == ZERO_INT_VALUE ? Colors.grey : infoColor,
                        child: IconButton(
                          onPressed: _.modo == ZERO_INT_VALUE
                              ? NULL_VALUE
                              : _.goSincronizar,
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
                flex: ONE_INT_VALUE)
          ],
        ),
      ),
    );
  }
}
