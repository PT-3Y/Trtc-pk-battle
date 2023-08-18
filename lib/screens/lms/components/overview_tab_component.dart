import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/html_widget.dart';

class OverviewTabComponent extends StatelessWidget {
  final String? overviewContent;

  OverviewTabComponent({Key? key, this.overviewContent});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(postContent: overviewContent).paddingAll(16);
  }
}
