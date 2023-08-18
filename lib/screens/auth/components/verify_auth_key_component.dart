import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import '../../../utils/app_constants.dart';

class VerifyAuthKeyComponent extends StatefulWidget {
  final Function(String)? onSubmit;
  final VoidCallback? callback;

  const VerifyAuthKeyComponent({this.onSubmit, this.callback});

  @override
  State<VerifyAuthKeyComponent> createState() => _VerifyAuthKeyComponentState();
}

class _VerifyAuthKeyComponentState extends State<VerifyAuthKeyComponent> {
  TextEditingController authKey = TextEditingController();
  final verifyAuthFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
      title: Text(language.addActivationKeyText, style: boldTextStyle()),
      content: Form(
        key: verifyAuthFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              isValidationRequired: true,
              autoFocus: true,
              controller: authKey,
              textFieldType: TextFieldType.OTHER,
              decoration: inputDecoration(
                context,
                label: '${language.activationKey}:',
                labelStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
              ),
            ),
            16.height,
            Row(
              children: [
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultAppButtonRadius)),
                    ),
                    side: MaterialStateProperty.all(BorderSide(color: appColorPrimary.withOpacity(0.5))),
                  ),
                  onPressed: () {
                    hideKeyboard(context);
                    finish(context, false);
                    widget.callback?.call();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.close, color: textPrimaryColorGlobal, size: 20),
                      6.width,
                      Text(language.cancel, style: boldTextStyle()),
                    ],
                  ).paddingSymmetric(vertical: 4).fit(),
                ).expand(),
                16.width,
                AppButton(
                  elevation: 0,
                  color: context.primaryColor,
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.link, color: Colors.white, size: 20),
                      6.width,
                      Text(language.activate, style: boldTextStyle(color: Colors.white)),
                    ],
                  ).fit(),
                  onTap: () {
                    if (verifyAuthFormKey.currentState!.validate()) {
                      verifyAuthFormKey.currentState!.save();
                      hideKeyboard(context);
                      widget.onSubmit?.call(authKey.text);
                      finish(context);
                    }
                  },
                ).expand(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
