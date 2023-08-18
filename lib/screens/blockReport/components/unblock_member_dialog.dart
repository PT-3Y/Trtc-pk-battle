import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';

class UnblockMemberDialog extends StatelessWidget {
  final String mentionName;
  final String name;
  final int id;
  final VoidCallback? callback;

  const UnblockMemberDialog({required this.mentionName, required this.id, required this.name, this.callback});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
      title: Text("${language.unblock} $mentionName?", style: boldTextStyle()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$name ${language.unblockText}', style: secondaryTextStyle()),
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
                  if (!appStore.isLoading) finish(context, false);
                },
              ).expand(),
              16.width,
              AppButton(
                elevation: 0,
                color: context.primaryColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, color: Colors.white, size: 20),
                    6.width,
                    Text(language.unblock, style: boldTextStyle(color: Colors.white)),
                  ],
                ).fit(),
                onTap: () {
                  ifNotTester(() {
                    appStore.setLoading(true);

                    blockUser(userId: id, key: BlockUserKey.unblock).then((value) {
                      appStore.setLoading(false);

                      callback?.call();
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
    );
  }
}
