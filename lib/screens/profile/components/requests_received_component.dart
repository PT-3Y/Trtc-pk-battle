import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/friend_request_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class RequestsReceivedComponent extends StatefulWidget {
  RequestsReceivedComponent();

  @override
  State<RequestsReceivedComponent> createState() => _RequestsReceivedComponentState();
}

class _RequestsReceivedComponentState extends State<RequestsReceivedComponent> with AutomaticKeepAliveClientMixin {
  List<FriendRequestModel> list = [];
  late Future<List<FriendRequestModel>> future;

  ScrollController _scrollController = ScrollController();

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = requestList();
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
          appStore.setLoading(true);
          future = requestList();
        }
      }
    });

    afterBuildCreated(() async {
      appStore.setLoading(true);
    });
  }

  Future<List<FriendRequestModel>> requestList() async {
    appStore.setLoading(true);

    await getFriendRequestList(page: mPage).then((value) {
      if (mPage == 1) list.clear();

      mIsLastPage = value.length != PER_PAGE;
      list.addAll(value);

      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      setState(() {});

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
      decoration: BoxDecoration(color: context.cardColor, borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
      child: Stack(
        alignment: isError || list.isEmpty ? Alignment.center : Alignment.topCenter,
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (list.isNotEmpty) Text('${language.requestsReceived} ( ${list.length} )', style: boldTextStyle()).paddingAll(16),
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
                          future = requestList();
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
                            future = requestList();
                          },
                          retryText: '   ${language.clickToRefresh}   ',
                        ).center();
                      } else {
                        return AnimatedListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          slideConfiguration: SlideConfiguration(
                            delay: 80.milliseconds,
                            verticalOffset: 300,
                          ),
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            FriendRequestModel friend = list[index];

                            return Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      cachedImage(
                                        friend.userImage.validate(),
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ).cornerRadiusWithClipRRect(20),
                                      20.width,
                                      Column(
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
                                          Text(friend.userMentionName.validate(), style: secondaryTextStyle()),
                                        ],
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      ).expand(),
                                    ],
                                  ),
                                  24.height,
                                  Row(
                                    children: [
                                      AppButton(
                                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                                        text: language.confirm,
                                        textStyle: secondaryTextStyle(color: Colors.white, size: 14),
                                        onTap: () async {
                                          if (!appStore.isLoading)
                                            ifNotTester(() async {
                                              appStore.setLoading(true);
                                              await acceptFriendRequest(id: friend.userId.validate()).then((value) async {
                                                mPage = 1;
                                                appStore.setLoading(true);
                                                future = requestList();
                                                LiveStream().emit(OnRequestAccept);
                                              }).catchError((e) {
                                                appStore.setLoading(false);
                                                toast(e.toString(), print: true);
                                              });
                                            });
                                        },
                                        elevation: 0,
                                        color: context.primaryColor,
                                        height: 32,
                                      ).expand(),
                                      16.width,
                                      AppButton(
                                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                                        text: language.decline,
                                        textStyle: secondaryTextStyle(color: context.primaryColor, size: 14),
                                        onTap: () {
                                          if (!appStore.isLoading)
                                            ifNotTester(() {
                                              appStore.setLoading(true);

                                              removeExistingFriendConnection(
                                                friendId: friend.userId.validate().toString(),
                                                passRequest: false,
                                              ).then((value) {
                                                mPage = 1;
                                                appStore.setLoading(true);
                                                future = requestList();
                                              }).catchError((e) {
                                                appStore.setLoading(false);
                                                toast(e.toString(), print: true);
                                              });
                                            });
                                        },
                                        elevation: 0,
                                        color: context.cardColor,
                                        height: 32,
                                      ).expand(),
                                    ],
                                  )
                                ],
                              ),
                            ).onTap(() async {
                              MemberProfileScreen(memberId: friend.userId.validate()).launch(context).then((value) {
                                if (value ?? false) {
                                  mPage = 1;
                                  appStore.setLoading(true);
                                  future = requestList();
                                  LiveStream().emit(OnRequestAccept);
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
            builder: (_) {
              if (appStore.isLoading) {
                return Positioned(
                  bottom: mPage != 1 ? 10 : null,
                  child: LoadingWidget(isBlurBackground: true),
                );
              } else {
                return Offstage();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
