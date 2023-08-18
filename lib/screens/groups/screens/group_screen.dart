import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/groups/group_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/groups/components/group_card_component.dart';
import 'package:socialv/screens/groups/components/initial_no_group_component.dart';
import 'package:socialv/screens/groups/screens/create_group_screen.dart';
import 'package:socialv/screens/groups/screens/group_detail_screen.dart';

import '../../../components/loading_widget.dart';
import '../../../utils/app_constants.dart';

class GroupScreen extends StatefulWidget {
  final int? userId;

  const GroupScreen({this.userId});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<GroupModel> groupList = [];
  late Future<List<GroupModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;

  bool isChange = false;
  bool isError = false;

  @override
  void initState() {
    future = getGroups();
    super.initState();
  }

  Future<List<GroupModel>> getGroups() async {
    appStore.setLoading(true);

    await getGroupList(userId: widget.userId, groupType: GroupRequestType.myGroup, page: mPage).then((value) {
      if (mPage == 1) groupList.clear();
      mIsLastPage = value.length != PER_PAGE;
      groupList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return groupList;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    future = getGroups();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        appStore.setLoading(false);
        finish(context, isChange);
        return Future.value(true);
      },
      child: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        color: appColorPrimary,
        child: Scaffold(
          appBar: AppBar(
            title: Text(language.groups, style: boldTextStyle(size: 20)),
            elevation: 0,
            centerTitle: true,
            actions: [
              if (widget.userId == null)
                IconButton(
                  onPressed: () {
                    CreateGroupScreen().launch(context).then((value) {
                      if (value) {
                        isChange = value;
                        mPage = 1;
                        future = getGroups();
                      }
                    });
                  },
                  icon: Image.asset(
                    ic_plus,
                    color: appColorPrimary,
                    height: 22,
                    width: 22,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.iconColor),
              onPressed: () {
                finish(context, isChange);
              },
            ),
          ),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              FutureBuilder<List<GroupModel>>(
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
                      return InitialNoGroupComponent(callback: onRefresh).center();
                    } else {
                      return AnimatedListView(
                        slideConfiguration: SlideConfiguration(
                          delay: 80.milliseconds,
                          verticalOffset: 300,
                        ),
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                        itemCount: groupList.length,
                        itemBuilder: (context, index) {
                          GroupModel data = groupList[index];
                          return GroupCardComponent(
                            data: groupList[index],
                            callback: () {
                              isChange = true;
                              mPage = 1;
                              future = getGroups();
                            },
                          ).paddingSymmetric(vertical: 8).onTap(() {
                            GroupDetailScreen(
                              groupId: data.id.validate(),
                              groupAvatarImage: data.groupAvatarImage,
                              groupCoverImage: data.groupCoverImage,
                            ).launch(context).then((value) {
                              if (value ?? false) {
                                isChange = value;
                                mPage = 1;
                                future = getGroups();
                              }
                            });
                          }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
                        },
                        onNextPage: () {
                          if (!mIsLastPage) {
                            mPage++;
                            future = getGroups();
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
      ),
    );
  }
}
