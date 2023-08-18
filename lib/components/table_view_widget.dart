import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TableViewWidget extends StatelessWidget {
  final Widget? renderContext;

  TableViewWidget(this.renderContext);

  @override
  Widget build(BuildContext context) {
    setOrientationLandscape();
    return Scaffold(
      appBar: appBarWidget(''),
      body: SizedBox(
        width: context.width(),
        height: context.height(),
        child: renderContext,
      ),
    );
  }
}
