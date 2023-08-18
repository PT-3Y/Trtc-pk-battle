import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/app_constants.dart';

class FaqTabComponent extends StatelessWidget {
  final List<List<dynamic>>? faqs;

  FaqTabComponent({this.faqs});

  @override
  Widget build(BuildContext context) {
    if (faqs.validate().isEmpty) {
      return NoDataWidget(
        imageWidget: NoDataLottieWidget(),
        title: language.noDataFound,
      ).center();
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: faqs.validate().map((e) {
          return ExpansionTile(
            textColor: context.primaryColor,
            childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(e.first),
            children: [
              Text(parseHtmlString(e.last), style: secondaryTextStyle()),
            ],
          );
        }).toList(),
      );
    }
  }
}
