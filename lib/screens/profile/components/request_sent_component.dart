import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/friend_request_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class RequestSentComponent extends StatefulWidget {
  RequestSentComponent();

  @override
  State<RequestSentComponent> createState() => _RequestSentComponentState();
}

class _RequestSentComponentState extends State<RequestSentComponent> with AutomaticKeepAliveClientMixin {
  List<FriendRequestModel> list = [];
  late Future<List<FriendRequestModel>> future;

  ScrollController _scrollController = ScrollController();

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = requestSentList();
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
          future = requestSentList();
        }
      }
    });

    afterBuildCreated(() async {
      appStore.setLoading(true);
    });
  }

  Future<List<FriendRequestModel>> requestSentList() async {
    appStore.setLoading(true);

    await getFriendRequestSent(page: mPage).then((value) {
      if (mPage == 1) list.clear();

      mIsLastPage = value.length != 20;
      list.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      setState(() {});
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return list;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      width: context.width(),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
      ),
      child: Stack(
        alignment: isError || list.isEmpty ? Alignment.center : Alignment.topCenter,
        children: [
          SingleChildScrollView(
            physics: PageScrollPhysics(),
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (list.isNotEmpty) Text('${language.requestsSent} ( ${list.length} )', style: boldTextStyle()).paddingAll(16),
                FutureBuilder<List<FriendRequestModel>>(
                  future: future,
                  builder: (ctx, snap) {
                    if (snap.hasError) {
                      return NoDataWidget(
                        imageWidget: NoDataLottieWidget(),
                        title: isError ? language.somethingWentWrong : language.noDataFound,
                        onRetry: () {
                          isError = false;
                          mPage = 1;
                          future = requestSentList();
                        },
                        retryText: '   ${language.clickToRefresh}   ',
                      ).center();
                    }

                    if (snap.hasData) {
                      if (snap.data.validate().isEmpty) {
                        return NoDataWidget(
                          imageWidget: NoDataLottieWidget(),
                          title: isError ? language.somethingWentWrong : language.noDataFound,
                          onRetry: () {
                            isError = false;
                            mPage = 1;
                            future = requestSentList();
                          },
                          retryText: '   ${language.clickToRefresh}   ',
                        ).center();
                      } else {
                        return AnimatedListView(
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            FriendRequestModel friend = list[index];

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cachedImage(
                                  friend.userImage.validate(),
                                  height: 42,
                                  width: 42,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(100),
                                12.width,
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(text: '${friend.userName.validate()} ', style: boldTextStyle(fontFamily: fontFamily)),
                                          if (friend.isUserVerified.validate()) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                                        ],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                    ),
                                    4.height,
                                    Text(friend.userMentionName.validate(), style: secondaryTextStyle()),
                                  ],
                                ).expand(),
                                8.width,
                                IconButton(
                                  onPressed: () {
                                    if (!appStore.isLoading)
                                      ifNotTester(() {
                                        appStore.setLoading(true);
                                        removeExistingFriendConnection(friendId: friend.userId.validate().toString(), passRequest: false).then((value) {
                                          if (value.deleted.validate()) {
                                            mPage = 1;
                                            appStore.setLoading(true);
                                            future = requestSentList();
                                          }
                                        }).catchError((e) {
                                          appStore.setLoading(false);
                                          toast(e.toString(), print: true);
                                        });
                                      });
                                  },
                                  icon: Image.asset(
                                    ic_close_square,
                                    color: appStore.isDarkMode ? bodyDark : bodyWhite,
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ).onTap(() async {
                              MemberProfileScreen(memberId: friend.userId.validate()).launch(context).then((value) {
                                if (value ?? false) {
                                  mPage = 1;
                                  appStore.setLoading(true);
                                  future = requestSentList();
                                }
                              });
                            }).paddingSymmetric(vertical: 8);
                          },
                        );
                      }
                    }
                    return Offstage();
                  },
                ),
              ],
            ),
          ),
          Observer(
            builder: (_) => Positioned(
              bottom: mPage != 1 ? 10 : null,
              child: LoadingWidget(isBlurBackground: true).visible(appStore.isLoading),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
