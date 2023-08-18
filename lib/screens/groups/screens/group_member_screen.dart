import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/member_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/groups/components/members_component.dart';

import '../../../utils/app_constants.dart';

class GroupMemberScreen extends StatefulWidget {
  final int groupId;
  final bool isAdmin;
  final int creatorId;

  GroupMemberScreen({required this.groupId, required this.isAdmin, required this.creatorId});

  @override
  State<GroupMemberScreen> createState() => _GroupMemberScreenState();
}

class _GroupMemberScreenState extends State<GroupMemberScreen> {
  List<MemberModel> memberList = [];
  late Future<List<MemberModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isCallback = false;
  bool isError = false;

  @override
  void initState() {
    future = getMemberList();
    super.initState();
  }

  Future<List<MemberModel>> getMemberList() async {
    if (isCallback) memberList.clear();
    appStore.setLoading(true);

    await getGroupMembersList(groupId: widget.groupId, page: mPage).then((value) {
      if (mPage == 1) memberList.clear();

      mIsLastPage = value.length != 20;
      memberList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return memberList;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    future = getMemberList();
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
      color: appColorPrimary,
      child: Scaffold(
        appBar: AppBar(
          title: Text(language.groupMembers, style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: context.iconColor),
            onPressed: () {
              finish(context, isCallback);
            },
          ),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            FutureBuilder<List<MemberModel>>(
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
                        delay: 120.milliseconds,
                      ),
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                      itemCount: memberList.length,
                      itemBuilder: (context, index) {
                        MemberModel member = memberList[index];
                        return MembersComponent(
                          creatorId: widget.creatorId,
                          member: member,
                          groupId: widget.groupId,
                          callback: () {
                            isCallback = true;
                            getMemberList();
                          },
                          isAdmin: widget.isAdmin,
                        ).paddingSymmetric(vertical: 8);
                      },
                      onNextPage: () {
                        if (!mIsLastPage) {
                          mPage++;
                          getMemberList();
                        }
                      },
                    );
                  }
                }

                return Offstage();
              },
            ),
            Observer(builder: (_) {
              return Positioned(
                bottom: mPage != 1 ? 10 : null,
                child: LoadingWidget(isBlurBackground: mPage == 1 ? true : false),
              ).visible(appStore.isLoading);
            }),
          ],
        ),
      ),
    );
  }
}
