import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/member_response.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class MemberListComponent extends StatefulWidget {
  const MemberListComponent({Key? key}) : super(key: key);

  @override
  State<MemberListComponent> createState() => _MemberListComponentState();
}

class _MemberListComponentState extends State<MemberListComponent> {
  Future<List<MemberResponse>>? future;
  List<MemberResponse> memberList = [];

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    future = getMembersList();
  }

  Future<List<MemberResponse>> getMembersList() async {
    appStore.setLoading(true);

    await getAllMembers(page: mPage).then((value) {
      mIsLastPage = value.length != 20;
      if (mPage == 1) memberList.clear();
      memberList.addAll(value);
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString());
    });
    return memberList;
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
        FutureBuilder<List<MemberResponse>>(
          future: future,
          builder: (ctx, snap) {
            if (snap.hasError) {
              return NoDataWidget(
                imageWidget: NoDataLottieWidget(),
                title: isError ? language.somethingWentWrong : language.noDataFound,
                onRetry: () {
                  future = getMembersList();
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
                    future = getMembersList();
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
                  itemCount: memberList.length,
                  itemBuilder: (context, index) {
                    MemberResponse member = memberList[index];
                    if (member.id.validate().toString() != appStore.loginUserId)
                      return InkWell(
                        onTap: () {
                          MemberProfileScreen(memberId: member.id.validate()).launch(context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            cachedImage(
                              member.avatarUrls!.full.validate(),
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
                                      member.name.validate(),
                                      style: boldTextStyle(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ).flexible(flex: 1),
                                    if (member.isUserVerified.validate()) Image.asset(ic_tick_filled, width: 18, height: 18, color: blueTickColor).paddingSymmetric(horizontal: 4),
                                  ],
                                ),
                                6.height,
                                Text(
                                  member.mentionName.validate(),
                                  style: secondaryTextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ).expand(),
                          ],
                        ).paddingSymmetric(vertical: 8),
                      );
                    else
                      return Offstage();
                  },
                  onNextPage: () {
                    if (!mIsLastPage) {
                      mPage++;
                      setState(() {});
                      future = getMembersList();
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
