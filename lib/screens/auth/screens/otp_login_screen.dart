import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_body.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/auth/screens/complete_profile_screen.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/post/screens/single_post_screen.dart';
import 'package:socialv/utils/app_constants.dart';

class OTPLoginScreen extends StatefulWidget {
  final int? activityId;

  const OTPLoginScreen({this.activityId});

  @override
  State<OTPLoginScreen> createState() => _OTPLoginScreenState();
}

class _OTPLoginScreenState extends State<OTPLoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController numberController = TextEditingController();

  Country selectedCountry = defaultCountry();

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() => init());
  }

  Future<void> init() async {
    appStore.setLoading(false);
  }

  //region Methods
  Future<void> changeCountry() async {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(textStyle: secondaryTextStyle(color: textSecondaryColorGlobal)),
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountry = country;
        log(jsonEncode(selectedCountry.toJson()));
        setState(() {});
      },
    );
  }

  Future<void> login({required Map req, bool isSocialLogin = false}) async {
    appStore.setLoading(true);

    hideKeyboard(context);

    await loginUser(request: req, isSocialLogin: isSocialLogin, setLoggedIn: false).then((value) async {
      Map req = {"player_id": getStringAsync(SharePreferencesKey.ONE_SIGNAL_PLAYER_ID), "add": 1};
      await setPlayerId(req).then((value) {
        //
      }).catchError((e) {
        log("Player id error : ${e.toString()}");
      });

      if (value.isProfileUpdated.validate()) {
        appStore.setLoggedIn(true);
        getMemberById();
      } else {
        appStore.setLoading(false);
        CompleteProfileScreen(activityId: widget.activityId, contact: numberController.text).launch(context);
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> sendOTP() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      appStore.setLoading(true);
      toast(language.sendingOtp);

      await loginService.loginWithOTP(
        context,
        phoneNumber: numberController.text.trim(),
        countryCode: selectedCountry.phoneCode,
        countryISOCode: selectedCountry.countryCode,
        callback: (request) async {
          await login(req: request, isSocialLogin: true);
        },
      ).then((res) async {
        //
      }).catchError(
        (e) {
          appStore.setLoading(false);

          toast(e.toString(), print: true);
        },
      );
    }
  }

  Future<void> getMemberById() async {
    await getLoginMember().then((value) {
      appStore.setLoginUserId(value.id.toString());
      appStore.setLoginAvatarUrl(value.avatarUrls!.full.validate());

      appStore.setLoginName(value.userLogin.validate());
      appStore.setLoginFullName(value.name.validate());
      appStore.setLoading(false);
      if (widget.activityId != null) {
        SinglePostScreen(postId: widget.activityId.validate()).launch(context, isNewTask: true);
      } else {
        push(DashboardScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  // endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark, statusBarColor: context.scaffoldBackgroundColor),
      ),
      body: Body(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language.enterYourPhoneNumber, style: boldTextStyle()),
              16.height,
              Form(
                key: formKey,
                child: AppTextField(
                  controller: numberController,
                  textFieldType: TextFieldType.PHONE,
                  decoration: inputDecorationFilled(
                    context,
                    fillColor: context.cardColor,
                    prefix: Text('+${selectedCountry.phoneCode}', style: primaryTextStyle()),
                    hint: selectedCountry.example,
                    hintStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                  ),
                  autoFocus: true,
                  onFieldSubmitted: (s) {
                    sendOTP();
                  },
                ),
              ),
              30.height,
              AppButton(
                onTap: () {
                  sendOTP();
                },
                text: language.sendOtp,
                color: context.primaryColor,
                textColor: Colors.white,
                width: context.width(),
                elevation: 0,
              ),
              16.height,
              TextButton(
                child: Text(language.changeCountry, style: boldTextStyle()),
                onPressed: () {
                  changeCountry();
                },
              ).center(),
            ],
          ),
        ),
      ),
    );
  }
}
