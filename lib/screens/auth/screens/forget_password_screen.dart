import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/auth/screens/sign_in_screen.dart';
import 'package:socialv/utils/common.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final forgetPassFormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Observer(
        builder: (_) => Stack(
          children: [
            Column(
              children: [
                headerContainer(
                  child: Text(
                    language.forgetPassword,
                    style: boldTextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ).paddingOnly(bottom: 16),
                  context: context,
                ),
                Form(
                  key: forgetPassFormKey,
                  child: Container(
                    width: context.width(),
                    color: context.cardColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          20.height,
                          Text(language.enterTheEmailAssociated, style: secondaryTextStyle(), textAlign: TextAlign.center),
                          50.height,
                          AppTextField(
                            enabled: !appStore.isLoading,
                            autoFocus: true,
                            controller: emailController,
                            textFieldType: TextFieldType.EMAIL,
                            textStyle: boldTextStyle(),
                            isValidationRequired: true,
                            decoration: inputDecoration(
                              context,
                              label: language.enterYourEmail,
                              labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                            ),
                          ).paddingSymmetric(horizontal: 16),
                          100.height,
                          appButton(
                              context: context,
                              text: language.getMail,
                              onTap: () async {
                                hideKeyboard(context);

                                if (!appStore.isLoading) {
                                  if (forgetPassFormKey.currentState!.validate()) {
                                    forgetPassFormKey.currentState!.save();
                                    appStore.setLoading(true);
                                    await forgetPassword(email: emailController.text.trim()).then((value) {
                                      appStore.setLoading(false);
                                      toast(value.message);

                                      finish(context);
                                    }).catchError((e) {
                                      appStore.setLoading(false);
                                      toast(e.toString());
                                    });
                                  }
                                }
                              }),
                          16.height,
                          Text(
                            language.backToLogin,
                            style: secondaryTextStyle(),
                          ).onTap(() {
                            finish(context);
                            SignInScreen().launch(context);
                          })
                        ],
                      ),
                    ),
                  ).expand(),
                )
              ],
            ),
            LoadingWidget().visible(appStore.isLoading)
          ],
        ),
      ),
    );
  }
}
