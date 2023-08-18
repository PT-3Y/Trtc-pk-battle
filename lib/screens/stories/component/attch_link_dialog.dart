import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import '../../../utils/app_constants.dart';

class AttachLinkDialog extends StatefulWidget {
  final Function(String)? onSubmit;
  final String? linkText;

  const AttachLinkDialog({this.onSubmit, this.linkText});

  @override
  State<AttachLinkDialog> createState() => _AttachLinkDialogState();
}

class _AttachLinkDialogState extends State<AttachLinkDialog> {
  TextEditingController storyLinkController = TextEditingController();
  final linkFormKey = GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();
    storyLinkController.text = widget.linkText.validate();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
      title: Text(language.attachLinkHere, style: boldTextStyle()),
      content: Form(
        key: linkFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              isValidationRequired: true,
              autoFocus: true,
              controller: storyLinkController,
              textFieldType: TextFieldType.URL,
              decoration: inputDecoration(
                context,
                label: language.link,
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
                      Text(language.attach, style: boldTextStyle(color: Colors.white)),
                    ],
                  ).fit(),
                  onTap: () {
                    if (linkFormKey.currentState!.validate()){
                      linkFormKey.currentState!.save();
                      hideKeyboard(context);
                      log('storyLinkController.text: ${storyLinkController.text}');

                      widget.onSubmit?.call(storyLinkController.text);
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
