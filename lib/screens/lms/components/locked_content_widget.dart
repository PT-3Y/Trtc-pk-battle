import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/app_constants.dart';

class LockedContentWidget extends StatelessWidget {
  const LockedContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appOrangeColor.withAlpha(30),
        border: Border(left: BorderSide(color: appOrangeColor, width: 2)),
      ),
      child: Text(
        language.thisContentIsProtected,
        style: primaryTextStyle(color: appOrangeColor),
      ),
    );
  }
}
