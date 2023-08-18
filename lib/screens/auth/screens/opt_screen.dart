import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/app_constants.dart';

class OtpScreen extends StatefulWidget {
  final Function(String? otpCode) onTap;

  OtpScreen({required this.onTap});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    String otpCode = '';

    void submitOtp() {
      if (otpCode.validate().isNotEmpty) {
        if (otpCode.validate().length >= 6) {
          hideKeyboard(context);
          appStore.setLoading(true);
          widget.onTap.call(otpCode);
        } else {
          toast(language.pleaseEnterValidOtp);
        }
      } else {
        toast(language.pleaseEnterValidOtp);
      }
    }

    return Scaffold(
      appBar: appBarWidget(
        language.confirmOtp,
        backWidget: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
        elevation: 0,
        color: context.scaffoldBackgroundColor,
        systemUiOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark, statusBarColor: context.scaffoldBackgroundColor),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(language.sentOTPText, style: secondaryTextStyle(size: 16)),
                32.height,
                OTPTextField(
                  pinLength: 6,
                  boxDecoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: radius(8),
                    border: Border.all(color: context.primaryColor),
                  ),
                  onChanged: (s) {
                    otpCode = s;
                    log(otpCode);
                  },
                  onCompleted: (pin) {
                    otpCode = pin;
                    submitOtp();
                  },
                ).fit(),
                30.height,
                AppButton(
                  onTap: () {
                    submitOtp();
                  },
                  text: language.confirm,
                  color: context.primaryColor,
                  textColor: Colors.white,
                  width: context.width(),
                ),
              ],
            ),
          ),
          Observer(builder: (context) {
            return LoadingWidget().visible(appStore.isLoading);
          }),
        ],
      ),
    );
  }
}
