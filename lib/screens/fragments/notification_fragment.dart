import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/notifications/notification_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/notification/components/notification_widget.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../utils/app_constants.dart';

class NotificationFragment extends StatefulWidget {
  final ScrollController controller;

  const NotificationFragment({required this.controller});

  @override
  State<NotificationFragment> createState() => _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
  List<NotificationModel> notificationList = [];
  late Future<List<NotificationModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = getList();
    super.initState();
    init();

    widget.controller.addListener(() {
      /// pagination
      if (selectedIndex == 3) {
        if (widget.controller.position.pixels == widget.controller.position.maxScrollExtent) {
          if (!mIsLastPage) {
            mPage++;
            setState(() {});

            future = getList();
          }
        }
      }
    });

    LiveStream().on(RefreshNotifications, (p0) {
      notificationList.clear();
      mPage = 1;
      future = getList();
    });
  }

  Future<void> init() async {
    appStore.setLoading(true);
    appStore.setNotificationCount(0);
  }

  Future<List<NotificationModel>> getList() async {
    appStore.setLoading(true);
    await notificationsList(page: mPage).then((value) {
      if (mPage == 1) notificationList.clear();
      mIsLastPage = value.length != 10;
      notificationList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return notificationList;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(RefreshNotifications);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Stack(
        alignment: Alignment.topCenter,
        children: [
          FutureBuilder<List<NotificationModel>>(
            future: future,
            builder: (ctx, snap) {
              if (snap.hasError) {
                return SizedBox(
                  height: context.height() * 0.8,
                  child: NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: isError ? language.somethingWentWrong : language.noDataFound,
                    onRetry: () {
                      isError = false;
                      LiveStream().emit(RefreshNotifications);
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center(),
                );
              }

              if (snap.hasData) {
                if (snap.data.validate().isEmpty && !appStore.isLoading) {
                  return SizedBox(
                    height: context.height() * 0.8,
                    child: NoDataWidget(
                      imageWidget: NoDataLottieWidget(),
                      title: isError ? language.somethingWentWrong : language.noDataFound,
                      onRetry: () {
                        isError = false;
                        LiveStream().emit(RefreshNotifications);
                      },
                      retryText: '   ${language.clickToRefresh}   ',
                    ).center(),
                  );
                } else {
                  return AnimatedListView(
                    padding: EdgeInsets.only(bottom: 60, top: notificationList.isNotEmpty ? 52 : 8),
                    shrinkWrap: true,
                    slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
                    itemCount: notificationList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: notificationList[index].isNew == 1 ? context.cardColor : context.scaffoldBackgroundColor,
                        child: NotificationWidget(
                          notificationModel: notificationList[index],
                          callback: () {
                            mPage = 1;
                            future = getList();
                          },
                        ),
                      );
                    },
                  );
                }
              }
              return LoadingWidget().visible(!appStore.isLoading);
            },
          ),
          if (notificationList.isNotEmpty)
            Positioned(
              top: 16,
              right: 16,
              child: TextIcon(
                prefix: cachedImage(ic_delete, color: Colors.red, width: 20, height: 20, fit: BoxFit.cover),
                text: language.clearAll,
                textStyle: primaryTextStyle(color: Colors.red),
                onTap: () async {
                  appStore.setLoading(true);
                  await clearNotification().then((value) {
                    mPage = 1;
                    future = getList();
                  }).catchError((error) {
                    toast(error.toString());
                    appStore.setLoading(false);
                  });
                },
              ),
            ),
          if (appStore.isLoading)
            Positioned(
              bottom: mPage != 1 ? 10 : null,
              child: LoadingWidget(isBlurBackground: false).paddingTop(mPage == 1 ? context.height() * 0.3 : 0),
            )
        ],
      ),
    );
  }
}
