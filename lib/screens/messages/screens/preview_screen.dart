import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';

import '../../../utils/app_constants.dart';

class PreviewScreen extends StatelessWidget {
  final File wallPaperFile;

  PreviewScreen({required this.wallPaperFile});

  @override
  Widget build(BuildContext context) {
    bool isChange = false;

    return WillPopScope(
      onWillPop: () {
        finish(context, isChange);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(language.preview, style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.iconColor),
            onPressed: () {
              finish(context, isChange);
            },
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.file(
              File(wallPaperFile.path.validate()),
              height: context.height(),
              width: context.width(),
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.height,
                Row(
                  children: [
                    Divider(indent: 16, height: 32, color: context.dividerColor).expand(),
                    Text(language.today, style: secondaryTextStyle(size: 12)).paddingSymmetric(horizontal: 8),
                    Divider(endIndent: 16, height: 32, color: context.dividerColor).expand(),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(language.thisIsPreviewOf, style: primaryTextStyle()),
                      4.height,
                      Text(
                        DateFormat('h:mm a').format(DateTime.now()),
                        style: secondaryTextStyle(size: 12),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(color: context.primaryColor, borderRadius: radius(commonRadius)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(language.setACustomWallpaper, style: primaryTextStyle(color: Colors.white)),
                        4.height,
                        Text(
                          DateFormat('h:mm a').format(DateTime.now()),
                          style: secondaryTextStyle(size: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              child: appButton(
                height: 50,
                context: context,
                text: language.setWallpaper,
                onTap: () async {
                  isChange = true;
                  finish(context, isChange);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
