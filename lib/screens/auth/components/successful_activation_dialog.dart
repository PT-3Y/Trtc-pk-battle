import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/cached_network_image.dart';
import '../../../utils/app_constants.dart';

class SuccessfulActivationDialog extends StatefulWidget {
  final Function(String)? onSubmit;

  const SuccessfulActivationDialog({this.onSubmit});

  @override
  State<SuccessfulActivationDialog> createState() => _SuccessfulActivationDialogState();
}

class _SuccessfulActivationDialogState extends State<SuccessfulActivationDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          16.height,
          cachedImage(ic_confetti, height: 80, width: 80, fit: BoxFit.cover, color: context.primaryColor),
          Container(
            width: context.width(),
            margin: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: appGreenColor.withAlpha(20),
              border: Border(left: BorderSide(color: appGreenColor, width: 2)),
            ),
            padding: EdgeInsets.all(14),
            child: Text('Your account is now active!', style: primaryTextStyle(color: appGreenColor)),
          ),
          Text('Your account was activated successfully! You can now log in with the username and password you provided when you signed up.', style: secondaryTextStyle()),
        ],
      ).onTap(() {
        finish(context);
      }),
    );
  }
}
