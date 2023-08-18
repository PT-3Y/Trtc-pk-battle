import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/auth/screens/sign_in_screen.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/post/screens/single_post_screen.dart';

import '../utils/app_constants.dart';

class SplashScreen extends StatefulWidget {
  final int? activityId;

  const SplashScreen({this.activityId});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    super.initState();
    init();
  }

  Future<void> init() async {
    getGeneralSettings();

    afterBuildCreated(() {
      appStore.setLanguage(getStringAsync(SharePreferencesKey.LANGUAGE, defaultValue: Constants.defaultLanguage));

      int themeModeIndex = getIntAsync(SharePreferencesKey.APP_THEME, defaultValue: AppThemeMode.ThemeModeSystem);
      if (themeModeIndex == AppThemeMode.ThemeModeSystem) {
        appStore.toggleDarkMode(value: MediaQuery.of(context).platformBrightness != Brightness.light, isFromMain: true);
      }
    });

    if (await isAndroid12Above()) {
      await 500.milliseconds.delay;
    } else {
      await 2.seconds.delay;
    }

    if (widget.activityId != null) {
      if (appStore.isLoggedIn) {
        SinglePostScreen(postId: widget.activityId.validate()).launch(context, isNewTask: true);
      } else {
        SignInScreen(activityId: widget.activityId.validate()).launch(context, isNewTask: true);
      }
    } else if (appStore.isLoggedIn && !isTokenExpire) {
      DashboardScreen().launch(context, isNewTask: true);
    } else {
      SignInScreen().launch(context, isNewTask: true);
    }
  }

  Future<void> getGeneralSettings() async {
    await generalSettings().then((value) {
      appStore.setAuthVerificationEnable(value.isAccountVerificationRequire == 1);
    }).catchError(onError);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColorBasedOnTheme();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(SPLASH_SCREEN_IMAGE, height: context.height(), width: context.width(), fit: BoxFit.cover),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(APP_ICON, height: 50, width: 52, fit: BoxFit.cover, color: Colors.white),
              8.width,
              Text(APP_NAME, style: boldTextStyle(color: Colors.white, size: 40)),
            ],
          ),
        ],
      ),
    );
  }
}
