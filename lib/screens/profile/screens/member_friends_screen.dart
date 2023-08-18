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

class MemberFriendsScreen extends StatefulWidget {
  final int memberId;

  const MemberFriendsScreen({required this.memberId});

  @override
  State<MemberFriendsScreen> createState() => _MemberFriendsScreenState();
}

class _MemberFriendsScreenState extends State<MemberFriendsScreen> {
  List<FriendRequestModel> membersList = [];
  late Future<List<FriendRequestModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = friendsList();

    setStatusBarColor(Colors.transparent);
    super.initState();
  }

  Future<List<FriendRequestModel>> friendsList() async {
    appStore.setLoading(true);

    await getFriendList(page: mPage, userId: widget.memberId).then((value) {
      if (mPage == 1) membersList.clear();

      mIsLastPage = value.length != 20;
      membersList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      setState(() {});
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return membersList;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    future = friendsList();
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
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      color: context.primaryColor,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: context.iconColor),
          title: Text(language.friends, style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            FutureBuilder<List<FriendRequestModel>>(
              future: future,
              builder: (ctx, snap) {
                if (snap.hasError) {
                  return NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: isError ? language.somethingWentWrong : language.noDataFound,
                    onRetry: () {
                      onRefresh();
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
                        onRefresh();
                      },
                      retryText: '   ${language.clickToRefresh}   ',
                    ).center();
                  } else {
                    return AnimatedListView(
                      shrinkWrap: true,
                      slideConfiguration: SlideConfiguration(
                        delay: 80.milliseconds,
                        verticalOffset: 300,
                      ),
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                      itemCount: membersList.length,
                      itemBuilder: (context, index) {
                        FriendRequestModel friend = membersList[index];

                        return Row(
                          children: [
                            cachedImage(
                              friend.userImage.validate(),
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ).cornerRadiusWithClipRRect(100),
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
                        ).onTap(() async {
                          MemberProfileScreen(memberId: friend.userId.validate()).launch(context);
                        }, splashColor: Colors.transparent, highlightColor: Colors.transparent).paddingSymmetric(vertical: 8);
                      },
                      onNextPage: () {
                        if (!mIsLastPage) {
                          mPage++;
                          future = friendsList();
                        }
                      },
                    );
                  }
                }
                return Offstage();
              },
            ),
            Observer(
              builder: (_) {
                if (appStore.isLoading) {
                  return Positioned(
                    bottom: mPage != 1 ? 10 : null,
                    child: LoadingWidget(isBlurBackground: mPage == 1 ? true : false),
                  );
                } else {
                  return Offstage();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
