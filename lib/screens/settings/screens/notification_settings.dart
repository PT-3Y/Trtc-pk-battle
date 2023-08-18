import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/notifications/notification_settings_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  List<NotificationSettingsModel> list = [];
  late Future<List<NotificationSettingsModel>> future;

  bool isError = false;
  bool isChange = false;

  @override
  void initState() {
    future = getNotificationSettings();
    super.initState();
  }

  Future<List<NotificationSettingsModel>> getNotificationSettings() async {
    appStore.setLoading(true);

    await notificationsSettings().then((value) {
      list.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      setState(() {});
      appStore.setLoading(false);

      toast(e.toString());
    });
    return list;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(
            '${language.notifications.capitalizeFirstLetter()} ${language.settings.capitalizeFirstLetter()}',
            style: boldTextStyle(size: 20),
          ),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.iconColor),
            onPressed: () {
              finish(context);
            },
          ),
        ),
        body: Stack(
          children: [
            FutureBuilder<List<NotificationSettingsModel>>(
              future: future,
              builder: (ctx, snap) {
                if (snap.hasError) {
                  return NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: isError ? language.somethingWentWrong : language.noDataFound,
                  ).center();
                }

                if (snap.hasData) {
                  if (snap.data.validate().isEmpty) {
                    return NoDataWidget(
                      imageWidget: NoDataLottieWidget(),
                      title: isError ? language.somethingWentWrong : language.noDataFound,
                    ).center();
                  } else {
                    return AnimatedListView(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                      itemCount: list.length,
                      slideConfiguration: SlideConfiguration(
                        delay: 80.milliseconds,
                        verticalOffset: 300,
                      ),
                      itemBuilder: (context, index) {
                        return SettingItemWidget(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          title: list[index].name.validate(),
                          titleTextStyle: boldTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 14),
                          trailing: Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              activeColor: context.primaryColor,
                              value: list[index].value.validate(),
                              onChanged: (val) {
                                isChange = true;
                                list[index].value = val;
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                    );
                  }
                }
                return Offstage();
              },
            ),
            LoadingWidget().visible(appStore.isLoading),
          ],
        ),
        bottomNavigationBar: list.isEmpty
            ? Offstage()
            : appButton(
                context: context,
                text: language.submit.capitalizeFirstLetter(),
                onTap: () async {
                  if (isChange) {
                    ifNotTester(() async {
                      if (list.isNotEmpty) {
                        appStore.setLoading(true);
                        await saveNotificationsSettings(requestList: list).then((value) {
                          appStore.setLoading(false);
                          toast(value.message);
                          finish(context);
                        }).catchError((e) {
                          appStore.setLoading(false);
                          toast(e.toString());
                        });
                      }
                    });
                  } else {
                    finish(context);
                  }
                },
              ).paddingAll(16),
      ),
    );
  }
}
