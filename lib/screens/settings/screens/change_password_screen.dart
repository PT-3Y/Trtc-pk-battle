import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final changePassFormKey = GlobalKey<FormState>();

  TextEditingController oldPassCont = TextEditingController();
  TextEditingController newPassCont = TextEditingController();
  TextEditingController confirmPassCont = TextEditingController();

  FocusNode oldPassFocus = FocusNode();
  FocusNode newPassFocus = FocusNode();
  FocusNode confirmPassFocus = FocusNode();

  Future<void> changePass() async {
    hideKeyboard(context);

    ifNotTester(() async {
      if (changePassFormKey.currentState!.validate()) {
        changePassFormKey.currentState!.save();

        if (confirmPassCont.text == newPassCont.text) {
          appStore.setLoading(true);

          Map request = {"old_password": oldPassCont.text, "new_password": newPassCont.text};

          await changePassword(request: request).then((value) {
            appStore.setLoading(false);
            toast(value.message);

            finish(context);
          }).catchError((e) {
            appStore.setLoading(false);
            toast(e.toString());
          });
        } else {
          toast(language.confirmPasswordError);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.changePassword, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Observer(
        builder: (_) => Stack(
          children: [
            Form(
              key: changePassFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppTextField(
                      enabled: !appStore.isLoading,
                      autoFocus: true,
                      controller: oldPassCont,
                      focus: oldPassFocus,
                      nextFocus: newPassFocus,
                      textInputAction: TextInputAction.next,
                      textFieldType: TextFieldType.PASSWORD,
                      textStyle: boldTextStyle(),
                      suffixIconColor: appStore.isDarkMode ? bodyDark : bodyWhite,
                      decoration: inputDecoration(
                        context,
                        label: language.oldPassword,
                        contentPadding: EdgeInsets.all(0),
                        labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                      ),
                      isPassword: true,
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                    AppTextField(
                      enabled: !appStore.isLoading,
                      controller: newPassCont,
                      focus: newPassFocus,
                      nextFocus: confirmPassFocus,
                      textInputAction: TextInputAction.next,
                      textFieldType: TextFieldType.PASSWORD,
                      textStyle: boldTextStyle(),
                      suffixIconColor: appStore.isDarkMode ? bodyDark : bodyWhite,
                      decoration: inputDecoration(
                        context,
                        label: language.newPassword,
                        contentPadding: EdgeInsets.all(0),
                        labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                      ),
                      isPassword: true,
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                    AppTextField(
                      enabled: !appStore.isLoading,
                      controller: confirmPassCont,
                      focus: confirmPassFocus,
                      textInputAction: TextInputAction.done,
                      textFieldType: TextFieldType.PASSWORD,
                      textStyle: boldTextStyle(),
                      suffixIconColor: appStore.isDarkMode ? bodyDark : bodyWhite,
                      decoration: inputDecoration(
                        context,
                        label: language.confirmPassword,
                        contentPadding: EdgeInsets.all(0),
                        labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                      ),
                      isPassword: true,
                      onFieldSubmitted: (x) {
                        changePass();
                      },
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                    appButton(
                      context: context,
                      text: language.submit.capitalizeFirstLetter(),
                      onTap: () async {
                        if (!appStore.isLoading) changePass();
                      },
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                  ],
                ),
              ),
            ),
            LoadingWidget().center().visible(appStore.isLoading)
          ],
        ),
      ),
    );
  }
}
