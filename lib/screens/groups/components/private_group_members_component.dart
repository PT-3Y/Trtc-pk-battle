import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/member_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/groups/components/members_component.dart';
import 'package:socialv/utils/app_constants.dart';

class PrivateGroupMembersComponent extends StatefulWidget {
  final int groupId;
  final bool isAdmin;
  final int creatorId;
  final VoidCallback? callback;

  const PrivateGroupMembersComponent({required this.groupId, required this.isAdmin, required this.creatorId, this.callback});

  @override
  State<PrivateGroupMembersComponent> createState() => _PrivateGroupMembersComponentState();
}

class _PrivateGroupMembersComponentState extends State<PrivateGroupMembersComponent> with AutomaticKeepAliveClientMixin {
  List<MemberModel> memberList = [];
  late Future<List<MemberModel>> future;

  Future<List<MemberModel>>? futureList;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = getList();

    LiveStream().on(OnGroupRequestAccept, (p0) {
      memberList.clear();
      future = getList();
    });
    super.initState();
  }

  Future<List<MemberModel>> getList() async {
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
    memberList.clear();
    future = getList();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(OnGroupRequestAccept);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
      ),
      child: Stack(
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
                      delay: 80.milliseconds,
                      verticalOffset: 300,
                    ),
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                    itemCount: memberList.validate().length,
                    itemBuilder: (context, index) {
                      MemberModel member = memberList.validate()[index];
                      return MembersComponent(
                        creatorId: widget.creatorId,
                        groupId: widget.groupId,
                        member: member,
                        isAdmin: widget.isAdmin,
                        callback: () {
                          mPage = 1;
                          future = getList();
                          widget.callback?.call();
                        },
                      ).paddingSymmetric(vertical: 8);
                    },
                    onNextPage: () {
                      if (!mIsLastPage) {
                        mPage++;
                        future = getList();
                      }
                    },
                  );
                }
              }
              return Offstage();
            },
          ),
          Observer(builder: (_) {
            if (appStore.isLoading) {
              return Positioned(
                bottom: mPage != 1 ? 10 : null,
                child: LoadingWidget(isBlurBackground: mPage == 1 ? true : false),
              );
            } else {
              return Offstage();
            }
          }),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
