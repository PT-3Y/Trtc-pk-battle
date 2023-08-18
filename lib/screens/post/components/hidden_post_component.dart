import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';

class HiddenPostComponent extends StatelessWidget {
  final VoidCallback? onReportPost;
  final VoidCallback? onUnfriend;
  final VoidCallback? onUndo;
  final bool isFriend;
  final String userName;

  const HiddenPostComponent({this.onReportPost, this.onUnfriend, this.onUndo, required this.isFriend, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: context.dividerColor)),
      ),
      child: Column(
        children: [
          16.height,
          Icon(Icons.check_circle, color: Colors.green, size: 30),
          8.height,
          Text(
            language.hiddenPostText,
            style: secondaryTextStyle(),
            textAlign: TextAlign.center,
          ).paddingSymmetric(horizontal: 16),
          16.height,
          InkWell(
            onTap: () {
              onReportPost?.call();
            },
            child: Container(
              width: context.width(),
              decoration: BoxDecoration(color: context.cardColor, border: Border.symmetric(horizontal: BorderSide(color: context.dividerColor))),
              child: Text(language.reportPost, style: primaryTextStyle()).center(),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          if (isFriend.validate())
            InkWell(
              onTap: () {
                onUnfriend?.call();
              },
              child: Container(
                width: context.width(),
                decoration: BoxDecoration(color: context.cardColor, border: Border(bottom: BorderSide(color: context.dividerColor))),
                child: Text(language.unfriend + " " + userName.validate(), style: primaryTextStyle()).center(),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          InkWell(
            onTap: () {
              onUndo?.call();
            },
            child: Container(
              width: context.width(),
              decoration: BoxDecoration(color: context.cardColor, border: Border(bottom: BorderSide(color: context.dividerColor))),
              child: Text(language.undo, style: primaryTextStyle(color: context.primaryColor)).center(),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
