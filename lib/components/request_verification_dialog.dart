import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';

class RequestVerificationDialog extends StatelessWidget {
  const RequestVerificationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
      title: Text(language.applyForVerification, style: boldTextStyle()).center(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: '${language.verifiedAccountsHaveBlue} ', style: secondaryTextStyle(fontFamily: fontFamily)),
                WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                TextSpan(text: ' ${language.nextToTheirNames}', style: secondaryTextStyle(fontFamily: fontFamily)),
              ],
            ),
          ),
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
                  finish(context, false);
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
                    Text(language.request, style: boldTextStyle(color: Colors.white)),
                  ],
                ).fit(),
                onTap: () {
                  ifNotTester(() {
                    appStore.setLoading(true);

                    verificationRequest().then((value) {
                      appStore.setLoading(false);
                      appStore.setVerificationStatus(VerificationStatus.pending);

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
