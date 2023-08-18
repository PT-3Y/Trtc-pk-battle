import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/messages/bm_blocked_users.dart';
import 'package:socialv/models/messages/bm_notifications.dart';
import 'package:socialv/models/messages/user_settings_model.dart';
import 'package:socialv/network/messages_repository.dart';
import 'package:socialv/screens/messages/screens/set_chat_wallpaper_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.settings, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                SetChatWallpaperScreen(isGeneralSetting: true, wallpaperUrl: messageStore.globalChatBackground).launch(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.wallpaper, style: boldTextStyle(size: 20)),
                  Icon(Icons.arrow_forward_ios, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 16),
                ],
              ).paddingAll(16),
            ),
            SnapHelperWidget<UserSettingsModel>(
              future: userSettings(),
              onSuccess: (snap) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.notifications, style: boldTextStyle(size: 20)).paddingSymmetric(horizontal: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(right: 16),
                      itemCount: snap.notifications!.options.validate().length,
                      itemBuilder: (ctx, index) {
                        Options option = snap.notifications!.options![index];
                        return InkWell(
                          onTap: () async {
                            option.checked = !option.checked.validate();

                            await saveUserSettings(option: option.id.validate(), value: option.checked.validate()).then((value) {
                              toast(value.message);
                            });
                            setState(() {});
                          },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(borderRadius: radius(2)),
                                activeColor: context.primaryColor,
                                value: option.checked,
                                onChanged: (val) async {
                                  option.checked = !option.checked.validate();

                                  await saveUserSettings(option: option.id.validate(), value: option.checked.validate()).then((value) {
                                    toast(value.message);
                                  });
                                  setState(() {});
                                },
                              ),
                              Column(
                                children: [
                                  Text(option.label.validate(), style: primaryTextStyle()),
                                  Text(option.desc.validate(), style: secondaryTextStyle()),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ).expand(),
                            ],
                          ).paddingSymmetric(vertical: 8),
                        );
                      },
                    ),
                    16.height,
                    Text(language.blockedAccounts, style: boldTextStyle(size: 20)).paddingSymmetric(horizontal: 16),
                    8.height,
                    Text(
                      language.listOfUsersBlocked,
                      style: secondaryTextStyle(),
                    ).paddingSymmetric(horizontal: 16),
                    if (snap.bmBlockedUsers == null || snap.bmBlockedUsers!.user.validate().isEmpty)
                      NoDataWidget(
                        imageWidget: NoDataLottieWidget(),
                        title: language.youHaventBlockedText,
                      )
                    else
                      ListView.builder(
                        padding: EdgeInsets.all(16),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snap.bmBlockedUsers != null ? snap.bmBlockedUsers!.user.validate().length : 0,
                        itemBuilder: (ctx, index) {
                          UserObject user = snap.bmBlockedUsers!.user![index];
                          return Row(
                            children: [
                              cachedImage(user.memberAvtarImage, height: 40, width: 40).cornerRadiusWithClipRRect(20),
                              16.width,
                              Column(
                                children: [
                                  Text(user.name.validate(), style: primaryTextStyle(size: 14)),
                                  4.height,
                                  Text(user.mentionName.validate(), style: secondaryTextStyle(size: 12)).paddingOnly(right: 8),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ).expand(),
                              AppButton(
                                enabled: true,
                                shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                                text: language.unblock,
                                textStyle: primaryTextStyle(color: Colors.white, size: 12),
                                onTap: () async {
                                  await unblockUser(userId: user.id.validate()).then((value) {
                                    setState(() {});
                                  });
                                },
                                color: context.primaryColor,
                                width: 60,
                                padding: EdgeInsets.all(0),
                                elevation: 0,
                              )
                            ],
                          );
                        },
                      ),
                  ],
                );
              },
              loadingWidget: ThreeBounceLoadingWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
