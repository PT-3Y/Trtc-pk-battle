import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';

class BlockMemberDialog extends StatelessWidget {
  final String mentionName;
  final int id;
  final VoidCallback? callback;

  BlockMemberDialog({required this.mentionName, required this.id, this.callback});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Stack(
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
            title: Text("${language.block} $mentionName?", style: boldTextStyle()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(language.blockText, style: secondaryTextStyle()),
                16.height,
                Row(
                  children: [
                    AppButton(
                      elevation: 0,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: radius(defaultAppButtonRadius),
                        side: BorderSide(color: viewLineColor),
                      ),
                      color: context.scaffoldBackgroundColor,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.close, color: textPrimaryColorGlobal, size: 20),
                          6.width,
                          Text(language.cancel, style: boldTextStyle()),
                        ],
                      ).fit(),
                      onTap: () {
                        finish(context);
                      },
                    ).expand(),
                    16.width,
                    AppButton(
                      elevation: 0,
                      color: Colors.red,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.block, color: Colors.white, size: 20),
                          6.width,
                          Text(language.block, style: boldTextStyle(color: Colors.white)),
                        ],
                      ).fit(),
                      onTap: () {
                        ifNotTester(() async {
                          appStore.setLoading(true);

                          blockUser(userId: id, key: BlockUserKey.block).then((value) async {
                            appStore.setLoading(false);

                            if (appStore.recentMemberSearchList.any((element) => element.id == id)) {
                              appStore.recentMemberSearchList.removeWhere((element) => element.id == id);
                              await setValue(SharePreferencesKey.RECENT_SEARCH_MEMBERS, jsonEncode(appStore.recentMemberSearchList));
                            }

                            callback!.call();
                            toast(value.message);
                          }).catchError((e) {
                            appStore.setLoading(false);
                            toast(e.toString());
                          });
                        });
                        finish(context, false);
                      },
                    ).expand(),
                  ],
                ),
              ],
            ),
          ),
          LoadingWidget().visible(appStore.isLoading)
        ],
      ),
    );
  }
}
