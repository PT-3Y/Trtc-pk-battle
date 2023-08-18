import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/groups/group_request_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class RequestComponent extends StatefulWidget {
  final int groupId;
  final Function(int)? onRequestAccept;

  RequestComponent({required this.groupId, this.onRequestAccept});

  @override
  State<RequestComponent> createState() => _RequestComponentState();
}

class _RequestComponentState extends State<RequestComponent> with AutomaticKeepAliveClientMixin {
  List<GroupRequestModel> requestList = [];
  late Future<List<GroupRequestModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = getRequests();

    super.initState();

    afterBuildCreated(() async {
      await 1.seconds.delay;
      appStore.setLoading(true);
    });
  }

  Future<List<GroupRequestModel>> getRequests() async {
    await getGroupMembershipRequest(groupId: widget.groupId.validate(), page: mPage).then((value) {
      if (mPage == 1) requestList.clear();

      mIsLastPage = value.length != 20;
      requestList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString());
    });

    return requestList;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    future = getRequests();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Observer(
      builder: (_) => Container(
        padding: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            FutureBuilder<List<GroupRequestModel>>(
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
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                      itemCount: requestList.length,
                      slideConfiguration: SlideConfiguration(
                        delay: 80.milliseconds,
                        verticalOffset: 300,
                      ),
                      itemBuilder: (ctx, index) {
                        GroupRequestModel member = requestList[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                                    Text(member.userName.validate(), style: boldTextStyle()),
                                    6.height,
                                    Text(member.userMentionName.validate(), style: secondaryTextStyle()),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (!appStore.isLoading)
                                      ifNotTester(() async {
                                        appStore.setLoading(true);

                                        await acceptGroupMembershipRequest(requestId: member.requestId.validate()).then((value) {
                                          mPage = 1;
                                          appStore.setLoading(true);
                                          future = getRequests();
                                          LiveStream().emit(OnGroupRequestAccept);
                                          widget.onRequestAccept?.call(member.requestId.validate());
                                        }).catchError((e) {
                                          appStore.setLoading(false);

                                          toast(e.toString(), print: true);
                                        });
                                      });
                                  },
                                  child: Image.asset(
                                    ic_tick_square,
                                    height: 22,
                                    width: 22,
                                    fit: BoxFit.cover,
                                    color: appColorPrimary,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    if (!appStore.isLoading)
                                      ifNotTester(() async {
                                        appStore.setLoading(true);

                                        await rejectGroupMembershipRequest(requestId: member.requestId.validate()).then((value) {
                                          mPage = 1;
                                          appStore.setLoading(true);
                                          future = getRequests();
                                        }).catchError((e) {
                                          appStore.setLoading(false);

                                          toast(e.toString(), print: true);
                                        });
                                      });
                                  },
                                  icon: Image.asset(
                                    ic_close_square,
                                    height: 22,
                                    width: 22,
                                    fit: BoxFit.cover,
                                    color: context.iconColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ).onTap(() async {
                          MemberProfileScreen(memberId: member.userId.validate()).launch(context);
                        }).paddingSymmetric(vertical: 8);
                      },
                      onNextPage: () {
                        if (!mIsLastPage) {
                          mPage++;
                          appStore.setLoading(true);
                          getRequests();
                        }
                      },
                    );
                  }
                }

                return Offstage();
              },
            ),
            Positioned(
              bottom: mPage != 1 ? 10 : null,
              child: LoadingWidget(isBlurBackground: mPage == 1 ? true : false),
            ).visible(appStore.isLoading),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
