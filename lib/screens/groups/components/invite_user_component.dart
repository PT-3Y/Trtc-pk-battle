import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/groups/group_request_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/groups/screens/create_group_screen.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class InviteUserComponent extends StatefulWidget {
  final int? groupId;

  InviteUserComponent({this.groupId});

  @override
  State<InviteUserComponent> createState() => _InviteUserComponentState();
}

class _InviteUserComponentState extends State<InviteUserComponent> {
  List<GroupInviteModel> invites = [];
  late Future<List<GroupInviteModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = getInvites();
    super.initState();
  }

  Future<List<GroupInviteModel>> getInvites() async {
    appStore.setLoading(true);

    await getGroupInviteList(page: mPage, groupId: widget.groupId ?? groupId).then((value) {
      if (mPage == 1) invites.clear();

      mIsLastPage = value.length != PER_PAGE;
      invites.addAll(value);
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return invites;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    setState(() {});

    future = getInvites();
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
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          FutureBuilder<List<GroupInviteModel>>(
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
                    physics: AlwaysScrollableScrollPhysics(),
                    slideConfiguration: SlideConfiguration(
                      delay: 80.milliseconds,
                      verticalOffset: 300,
                    ),
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                    itemCount: invites.length,
                    itemBuilder: (context, index) {
                      GroupInviteModel member = invites[index];

                      if (member.userId.validate().toString() != appStore.loginUserId) {
                        return Row(
                          children: [
                            cachedImage(
                              member.userImage.validate(),
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ).cornerRadiusWithClipRRect(100),
                            8.width,
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: '${member.userName.validate()}  ', style: primaryTextStyle(fontFamily: fontFamily)),
                                  if (member.isUserVerified.validate()) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ).expand(),
                            member.isInvited.validate()
                                ? TextButton(
                                    onPressed: () async {
                                      if (!appStore.isLoading)
                                        ifNotTester(() async {
                                          mPage = 1;

                                          appStore.setLoading(true);

                                          await invite(
                                            groupId: widget.groupId ?? groupId,
                                            userId: member.userId.validate(),
                                            isInviting: 0,
                                          ).then((value) async {
                                            mPage = 1;
                                            setState(() {});

                                            future = getInvites();
                                          }).catchError((e) {
                                            appStore.setLoading(false);

                                            toast(e.toString());
                                          });
                                        });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check, color: context.primaryColor, size: 18),
                                        4.width,
                                        Text(language.invited, style: primaryTextStyle(size: 14, color: context.primaryColor)),
                                      ],
                                    ),
                                  )
                                : TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(defaultRadius),
                                          side: BorderSide(color: context.primaryColor),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (!appStore.isLoading)
                                        ifNotTester(() async {
                                          mPage = 1;
                                          appStore.setLoading(true);

                                          await invite(groupId: widget.groupId ?? groupId, userId: member.userId.validate(), isInviting: 1).then((value) async {
                                            mPage = 1;
                                            setState(() {});

                                            future = getInvites();
                                          }).catchError((e) {
                                            appStore.setLoading(false);
                                            toast(e.toString(), print: true);
                                          });
                                        });
                                    },
                                    child: Text(language.invite, style: primaryTextStyle(size: 14, color: context.primaryColor)),
                                  )
                          ],
                        ).onTap(() async {
                          MemberProfileScreen(memberId: member.userId.validate()).launch(context);
                        }, splashColor: Colors.transparent, highlightColor: Colors.transparent).paddingSymmetric(vertical: 8);
                      } else {
                        return Offstage();
                      }
                    },
                    onNextPage: () {
                      if (!mIsLastPage) {
                        mPage++;
                        setState(() {});
                        future = getInvites();
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
            child: Observer(builder: (_) => LoadingWidget(isBlurBackground: mPage == 1 ? true : false).visible(appStore.isLoading)),
          ),
        ],
      ),
    );
  }
}
