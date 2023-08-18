import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/post/screens/single_post_screen.dart';
import 'package:socialv/utils/app_constants.dart';

class CompleteProfileScreen extends StatefulWidget {
  final int? activityId;
  final String contact;

  const CompleteProfileScreen({this.activityId, required this.contact});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final completeProfileFormKey = GlobalKey<FormState>();

  TextEditingController userNameCont = TextEditingController();
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  FocusNode userName = FocusNode();
  FocusNode firstName = FocusNode();
  FocusNode lastName = FocusNode();
  FocusNode password = FocusNode();
  FocusNode email = FocusNode();
  FocusNode confirmPassword = FocusNode();

  @override
  void initState() {
    super.initState();

    passwordCont.text = widget.contact;
    confirmPasswordCont.text = widget.contact;
  }

  void login() async {
    if (completeProfileFormKey.currentState!.validate()) {
      completeProfileFormKey.currentState!.save();
      hideKeyboard(context);

      appStore.setLoading(true);

      if (passwordCont.text == confirmPasswordCont.text) {
        Map request = {
          "user_login": userNameCont.text,
          "first_name": firstNameCont.text,
          "last_name": lastNameCont.text,
          "email": emailCont.text,
          "password": passwordCont.text,
        };

        updateProfile(request: request).then((value) {
          getMemberById();
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString());
        });
      } else {
        appStore.setLoading(false);
        toast(language.confirmPasswordError);
      }
    }
  }

  Future<void> getMemberById() async {
    await getLoginMember().then((value) {
      appStore.setLoginUserId(value.id.toString());
      appStore.setLoginAvatarUrl(value.avatarUrls!.full.validate());

      appStore.setLoginName(value.userLogin.validate());
      appStore.setLoginFullName(value.name.validate());
      appStore.setLoginEmail(emailCont.text);
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

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.completeProfile,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: completeProfileFormKey,
          child: Observer(
            builder: (_) => Column(
              children: [
                Text(language.completeYourProfileText, style: secondaryTextStyle(size: 16)),
                16.height,
                AppTextField(
                  enabled: !appStore.isLoading,
                  controller: userNameCont,
                  nextFocus: firstName,
                  focus: userName,
                  textFieldType: TextFieldType.USERNAME,
                  textStyle: boldTextStyle(),
                  decoration: inputDecoration(
                    context,
                    label: language.username,
                    labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                  ),
                ),
                8.height,
                AppTextField(
                  enabled: !appStore.isLoading,
                  controller: firstNameCont,
                  nextFocus: lastName,
                  focus: firstName,
                  textFieldType: TextFieldType.NAME,
                  textStyle: boldTextStyle(),
                  decoration: inputDecoration(
                    context,
                    label: language.firstName,
                    labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                  ),
                ),
                AppTextField(
                  enabled: !appStore.isLoading,
                  controller: lastNameCont,
                  nextFocus: email,
                  focus: lastName,
                  textFieldType: TextFieldType.NAME,
                  textStyle: boldTextStyle(),
                  decoration: inputDecoration(
                    context,
                    label: language.lastName,
                    labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                  ),
                ),
                8.height,
                AppTextField(
                  enabled: !appStore.isLoading,
                  controller: emailCont,
                  nextFocus: password,
                  focus: email,
                  textFieldType: TextFieldType.EMAIL,
                  textStyle: boldTextStyle(),
                  decoration: inputDecoration(
                    context,
                    label: language.yourEmail,
                    labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                  ),
                ),
                16.height,
                AppTextField(
                  enabled: !appStore.isLoading,
                  controller: passwordCont,
                  nextFocus: confirmPassword,
                  focus: password,
                  textInputAction: TextInputAction.next,
                  textFieldType: TextFieldType.PASSWORD,
                  textStyle: boldTextStyle(),
                  suffixIconColor: appStore.isDarkMode ? bodyDark : bodyWhite,
                  decoration: inputDecoration(
                    context,
                    label: language.password,
                    contentPadding: EdgeInsets.all(0),
                    labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                  ),
                  isPassword: true,
                  onFieldSubmitted: (x) {
                    login();
                  },
                ),
                16.height,
                AppTextField(
                  enabled: !appStore.isLoading,
                  controller: confirmPasswordCont,
                  focus: confirmPassword,
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
                    login();
                  },
                ),
                30.height,
                appButton(
                  context: context,
                  text: language.submit.capitalizeFirstLetter(),
                  onTap: () {
                    if (!appStore.isLoading) login();
                  },
                ),
                50.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
