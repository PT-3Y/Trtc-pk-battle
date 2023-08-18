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

class MemberSuggestionListComponent extends StatefulWidget {
  const MemberSuggestionListComponent({Key? key}) : super(key: key);

  @override
  State<MemberSuggestionListComponent> createState() => _MemberSuggestionListComponentState();
}

class _MemberSuggestionListComponentState extends State<MemberSuggestionListComponent> {
  List<FriendRequestModel> suggestedMemberList = [];

  Future<List<FriendRequestModel>>? futureSuggestedList;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    futureSuggestedList = getSuggestedList();
  }

  Future<List<FriendRequestModel>> getSuggestedList() async {
    appStore.setLoading(true);

    await getSuggestedUserList(page: mPage).then((value) {
      mIsLastPage = value.length != 20;
      if (mPage == 1) suggestedMemberList.clear();
      suggestedMemberList.addAll(value);
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString());
    });
    return suggestedMemberList;
  }

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
    return Stack(
      fit: StackFit.expand,
      children: [
        FutureBuilder<List<FriendRequestModel>>(
          future: futureSuggestedList,
          builder: (ctx, snap) {
            if (snap.hasError) {
              return NoDataWidget(
                imageWidget: NoDataLottieWidget(),
                title: isError ? language.somethingWentWrong : language.noDataFound,
                onRetry: () {
                  futureSuggestedList = getSuggestedList();
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
                    futureSuggestedList = getSuggestedList();
                  },
                  retryText: '   ${language.clickToRefresh}   ',
                ).center();
              } else {
                return AnimatedListView(
                  shrinkWrap: true,
                  disposeScrollController: false,
                  physics: AlwaysScrollableScrollPhysics(),
                  slideConfiguration: SlideConfiguration(delay: 120.milliseconds),
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                  itemCount: suggestedMemberList.length,
                  itemBuilder: (context, index) {
                    FriendRequestModel member = suggestedMemberList[index];
                    return GestureDetector(
                      onTap: () {
                        MemberProfileScreen(memberId: member.userId.validate()).launch(context);
                      },
                      child: Row(
                        children: [
                          cachedImage(
                            member.userImage.validate(),
                            height: 56,
                            width: 56,
                            fit: BoxFit.cover,
                          ).cornerRadiusWithClipRRect(100),
                          20.width,
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    member.userName.validate(),
                                    style: boldTextStyle(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ).flexible(flex: 1),
                                  if (member.isUserVerified.validate()) Image.asset(ic_tick_filled, width: 18, height: 18, color: blueTickColor).paddingSymmetric(horizontal: 4),
                                ],
                              ),
                              6.height,
                              Text(
                                member.userMentionName.validate(),
                                style: secondaryTextStyle(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ).expand(),
                          Row(
                            children: [
                              InkWell(
                                child: cachedImage(member.isRequested.validate() ? ic_tick_square : ic_plus, height: 26, width: 26, color: context.primaryColor, fit: BoxFit.cover),
                                onTap: () {
                                  member.isRequested = !member.isRequested.validate();
                                  setState(() {});

                                  ifNotTester(() async {
                                    if (!member.isRequested.validate()) {
                                      await removeExistingFriendConnection(friendId: member.userId.validate().toString(), passRequest: true).then((value) {
                                        //
                                      }).catchError((e) {
                                        member.isRequested = !member.isRequested.validate();
                                        setState(() {});
                                      });
                                    } else {
                                      Map request = {"initiator_id": appStore.loginUserId, "friend_id": member.userId.validate()};
                                      await requestNewFriend(request).then((value) async {
                                        //
                                      }).catchError((e) {
                                        member.isRequested = !member.isRequested.validate();
                                        setState(() {});
                                      });
                                    }
                                  });
                                },
                              ),
                              4.width,
                              InkWell(
                                child: cachedImage(ic_close_square, height: 28, width: 28, color: Colors.red, fit: BoxFit.cover),
                                onTap: () {
                                  ifNotTester(() async {
                                    suggestedMemberList.removeAt(index);
                                    setState(() {});
                                    await removeSuggestedUser(userId: member.userId.validate()).then((value) {
                                      //
                                    }).catchError(onError);
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ).paddingSymmetric(vertical: 8),
                    );
                  },
                  onNextPage: () {
                    if (!mIsLastPage) {
                      mPage++;
                      setState(() {});
                      futureSuggestedList = getSuggestedList();
                    }
                  },
                );
              }
            }

            return Offstage();
          },
        ),
        Positioned(
          bottom: mPage != 1 ? 8 : null,
          width: context.width(),
          child: Observer(builder: (_) => LoadingWidget(isBlurBackground: mPage == 1 ? true : false).visible(appStore.isLoading)),
        ),
      ],
    );
  }
}
