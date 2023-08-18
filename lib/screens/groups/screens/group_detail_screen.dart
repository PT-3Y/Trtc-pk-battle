import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/groups/group_model.dart';
import 'package:socialv/models/posts/post_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/blockReport/components/show_report_dialog.dart';
import 'package:socialv/screens/groups/components/join_group_widget.dart';
import 'package:socialv/screens/groups/screens/edit_group_screen.dart';
import 'package:socialv/screens/groups/screens/group_member_request_screen.dart';
import 'package:socialv/screens/groups/screens/group_member_screen.dart';
import 'package:socialv/screens/groups/screens/invite_user_screen.dart';
import 'package:socialv/screens/post/components/post_component.dart';
import 'package:socialv/screens/post/screens/add_post_screen.dart';
import 'package:socialv/screens/profile/components/profile_header_component.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';
import '../../gallery/screens/gallery_screen.dart';

class GroupDetailScreen extends StatefulWidget {
  final int? groupId;
  final String? groupAvatarImage;
  final String? groupCoverImage;

  GroupDetailScreen({this.groupId, this.groupAvatarImage, this.groupCoverImage});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  bool fetchGp = false;
  GroupModel group = GroupModel();

  List<PostModel> postList = [];
  late Future<List<PostModel>> future;

  ScrollController _scrollController = ScrollController();

  int mPage = 1;
  bool mIsLastPage = false;
  bool isLoading = false;

  bool isUpdate = false;
  bool isError = false;

  @override
  void initState() {
    future = getPostList();
    super.initState();

    if (postList.isNotEmpty) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          if (!mIsLastPage) {
            mPage++;
            future = getPostList();
          }
        }
      });
    }

    groupDetail();
  }

  Future<void> groupDetail() async {
    appStore.setLoading(true);

    getGroupDetail(groupId: widget.groupId.validate(), userId: appStore.loginUserId).then((value) async {
      group = value.first;
      fetchGp = true;
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      setState(() {});
      toast(e.toString(), print: true);
    });
  }

  Future<List<PostModel>> getPostList() async {
    isLoading = true;
    if (mPage == 1) postList.clear();

    await getPost(type: PostRequestType.group, page: mPage, groupId: widget.groupId, userId: appStore.loginUserId.toInt()).then((value) {
      mIsLastPage = value.length != PER_PAGE;

      postList.addAll(value);
      isLoading = false;
      setState(() {});
    }).catchError((e) {
      isLoading = false;
      toast(e.toString(), print: true);
    });

    return postList;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    groupDetail();
    future = getPostList();
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
    return WillPopScope(
      onWillPop: () {
        appStore.setLoading(false);
        finish(context, isUpdate);
        return Future.value(true);
      },
      child: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        color: context.primaryColor,
        child: Scaffold(
          appBar: AppBar(
            title: Text(parseHtmlString(group.name.validate()), style: boldTextStyle(size: 20)),
            elevation: 0,
            centerTitle: true,
            actions: [
              if (group.isGroupAdmin.validate())
                IconButton(
                  onPressed: () {
                    EditGroupScreen(groupId: widget.groupId.validate()).launch(context).then((value) {
                      if (value ?? false) {
                        isUpdate = value;
                        groupDetail();
                      }
                    });
                  },
                  icon: Image.asset(
                    ic_edit,
                    height: 18,
                    width: 18,
                    fit: BoxFit.cover,
                    color: context.primaryColor,
                  ),
                )
              else
                Theme(
                  data: Theme.of(context).copyWith(useMaterial3: false),
                  child: PopupMenuButton(
                    position: PopupMenuPosition.under,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
                    onSelected: (val) async {
                      if (val == 1) {
                        showConfirmDialogCustom(
                          context,
                          onAccept: (c) async {
                            ifNotTester(() async {
                              appStore.setLoading(true);
                              await leaveGroup(groupId: group.id.validate().toInt()).then((value) {
                                isUpdate = true;
                                groupDetail();
                              }).catchError((e) {
                                appStore.setLoading(false);
                                toast(e.toString());
                              });
                            });
                          },
                          dialogType: DialogType.CONFIRMATION,
                          title: language.leaveGroupConfirmation,
                          positiveText: language.remove,
                        );
                      } else {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.80,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 45,
                                    height: 5,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                                  ),
                                  8.height,
                                  Container(
                                    decoration: BoxDecoration(
                                      color: context.cardColor,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                    ),
                                    child: ShowReportDialog(
                                      isPostReport: false,
                                      isGroupReport: true,
                                      groupId: widget.groupId.validate(),
                                    ),
                                  ).expand(),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    icon: Icon(Icons.more_horiz),
                    itemBuilder: (context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        value: 1,
                        child: Text(language.leaveGroup),
                        textStyle: primaryTextStyle(),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(language.report),
                        textStyle: primaryTextStyle(),
                      ),
                    ],
                  ),
                ),
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.iconColor),
              onPressed: () {
                finish(context, isUpdate);
              },
            ),
          ),
          body: Observer(
            builder: (_) {
              return appStore.isLoading
                  ? LoadingWidget().center()
                  : isError
                      ? NoDataWidget(
                          imageWidget: NoDataLottieWidget(),
                          title: isError ? language.somethingWentWrong : language.noDataFound,
                          onRetry: () {
                            onRefresh();
                          },
                          retryText: '   ${language.clickToRefresh}   ',
                        ).center()
                      : SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              ProfileHeaderComponent(
                                avatarUrl: group.groupAvatarImage.validate(),
                                cover: group.groupCoverImage.validate(),
                              ),
                              16.height,
                              RichText(
                                text: TextSpan(
                                  text: '${parseHtmlString(group.name.validate())}',
                                  style: boldTextStyle(size: 20, fontFamily: fontFamily),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' ${group.isGroupAdmin.validate() ? '(${language.organizer})' : group.isGroupMember.validate() ? '(${language.member})' : ''}',
                                      style: boldTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 14, fontFamily: fontFamily),
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ).paddingSymmetric(horizontal: 8),
                              8.height,
                              if (fetchGp)
                                Text(
                                  parseHtmlString(group.description.validate()),
                                  style: secondaryTextStyle(),
                                  textAlign: TextAlign.center,
                                ).paddingSymmetric(horizontal: 16),
                              16.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    ic_globe_antarctic,
                                    height: 16,
                                    width: 16,
                                    fit: BoxFit.cover,
                                    color: context.iconColor,
                                  ),
                                  4.width,
                                  Text('${group.groupType.validate().capitalizeFirstLetter()} ${language.group}', style: secondaryTextStyle()),
                                  Text(
                                    '•',
                                    style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                                  ).paddingSymmetric(horizontal: 8),
                                  Image.asset(
                                    ic_calendar,
                                    height: 16,
                                    width: 16,
                                    fit: BoxFit.cover,
                                    color: context.iconColor,
                                  ),
                                  4.width,
                                  if (fetchGp) Text('${getFormattedDate(group.dateCreated.validate())}', style: secondaryTextStyle()),
                                ],
                              ).paddingSymmetric(horizontal: 16),
                              16.height,
                              Container(
                                padding: EdgeInsets.all(8),
                                width: context.width(),
                                decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultAppButtonRadius)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            if (group.isGroupAdmin.validate() && group.groupType == AccountType.private) {
                                              GroupMemberRequestScreen(
                                                creatorId: group.groupCreatedById.validate(),
                                                groupId: widget.groupId.validate(),
                                                isAdmin: group.isGroupAdmin.validate(),
                                              ).launch(context).then((value) {
                                                if (value) {
                                                  isUpdate = true;
                                                  groupDetail();
                                                }
                                              });
                                            } else if (group.groupType == AccountType.public || group.isGroupMember.validate()) {
                                              GroupMemberScreen(
                                                creatorId: group.groupCreatedById.validate(),
                                                groupId: widget.groupId.validate(),
                                                isAdmin: group.isGroupAdmin.validate(),
                                              ).launch(context).then((value) {
                                                if (value ?? false) {
                                                  isUpdate = true;
                                                  groupDetail();
                                                }
                                              });
                                            } else {
                                              toast(language.cShowGroupMembers);
                                            }
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (group.memberList.validate().isNotEmpty)
                                                Stack(
                                                  children: group.memberList.validate().take(3).map((e) {
                                                    return Container(
                                                      width: 32,
                                                      height: 32,
                                                      margin: EdgeInsets.only(left: 18 * group.memberList.validate().indexOf(e).toDouble()),
                                                      child: cachedImage(
                                                        group.memberList.validate()[group.memberList.validate().indexOf(e)].userAvatar.validate(),
                                                        fit: BoxFit.cover,
                                                      ).cornerRadiusWithClipRRect(100),
                                                    );
                                                  }).toList(),
                                                ),
                                              6.width,
                                              Text(
                                                '${group.memberCount.validate().toInt()} ${language.members}',
                                                style: boldTextStyle(color: context.primaryColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (group.canInvite.validate())
                                          Theme(
                                            data: Theme.of(context).copyWith(
                                              highlightColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                InviteUserScreen(groupId: widget.groupId.validate()).launch(context);
                                              },
                                              icon: Image.asset(
                                                ic_add_user,
                                                color: context.primaryColor,
                                                height: 20,
                                                width: 20,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      ],
                                      mainAxisAlignment: group.isGroupMember.validate() ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                                    ),
                                    if (!group.isGroupMember.validate() && group.isBanned == 0)
                                      JoinGroupWidget(
                                        hasInvite: group.hasInvite.validate(),
                                        isRequestSent: group.isRequestSent.validate(),
                                        groupId: widget.groupId.validate(),
                                        isGroupMember: group.isGroupMember.validate(),
                                        isPublicGroup: group.groupType.validate() == AccountType.public ? true : false,
                                        callback: () {
                                          isUpdate = true;
                                          groupDetail();
                                          future = getPostList();
                                        },
                                      ),
                                  ],
                                ),
                              ).paddingSymmetric(horizontal: 16),
                              8.height,
                              if (group.isGalleryEnabled == 1)
                                if (group.groupType == AccountType.public || group.isGroupMember.validate())
                                  TextIcon(
                                    onTap: () {
                                      GalleryScreen(groupId: group.id, canEdit: group.isGroupMember.validate()).launch(context);
                                    },
                                    text: language.viewGallery,
                                    textStyle: primaryTextStyle(color: appColorPrimary),
                                    prefix: Image.asset(ic_image, width: 18, height: 18, color: appColorPrimary),
                                  ),
                              8.height,
                              if (!appStore.isLoading)
                                group.groupType == AccountType.public || group.isGroupMember.validate()
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (postList.isNotEmpty)
                                            Text(
                                              (appStore.displayPostCount == 1) ? '${language.post} (${group.postCount})' : language.post,
                                              style: boldTextStyle(color: context.primaryColor),
                                            ).paddingSymmetric(horizontal: 16),
                                          FutureBuilder<List<PostModel>>(
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
                                                if (snap.data.validate().isEmpty && !fetchGp) {
                                                  return NoDataWidget(
                                                    imageWidget: NoDataLottieWidget(),
                                                    title: isError ? language.somethingWentWrong : language.noDataFound,
                                                    onRetry: () {
                                                      onRefresh();
                                                    },
                                                    retryText: '   ${language.clickToRefresh}   ',
                                                  ).center();
                                                } else {
                                                  return Stack(
                                                    children: [
                                                      AnimatedListView(
                                                        padding: EdgeInsets.all(8),
                                                        itemCount: postList.length,
                                                        slideConfiguration: SlideConfiguration(
                                                          delay: 80.milliseconds,
                                                          verticalOffset: 300,
                                                        ),
                                                        itemBuilder: (context, index) {
                                                          return PostComponent(
                                                            post: postList[index],
                                                            callback: () {
                                                              mPage = 1;
                                                              groupDetail();
                                                              future = getPostList();
                                                            },
                                                            commentCallback: () {
                                                              mPage = 1;
                                                              future = getPostList();
                                                            },
                                                            fromGroup: true,
                                                            groupId: widget.groupId,
                                                          );
                                                        },
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                      ),
                                                      if (mPage != 1 && isLoading)
                                                        Positioned(
                                                          bottom: 0,
                                                          right: 0,
                                                          left: 0,
                                                          child: ThreeBounceLoadingWidget(),
                                                        )
                                                    ],
                                                  );
                                                }
                                              }

                                              return ThreeBounceLoadingWidget().paddingTop(16);
                                            },
                                          ),
                                        ],
                                      )
                                    : Offstage(),
                              70.height,
                            ],
                          ),
                        );
            },
          ),
          floatingActionButton: group.isGroupAdmin.validate() || group.isGroupMember.validate()
              ? FloatingActionButton(
                  backgroundColor: appColorPrimary,
                  onPressed: () {
                    AddPostScreen(
                      component: Component.groups,
                      groupId: widget.groupId,
                      groupName: group.name.validate(),
                    ).launch(context).then((value) {
                      if (value ?? false) {
                        groupDetail();
                        mPage = 1;
                        future = getPostList();
                      }
                    });
                  },
                  child: Icon(Icons.add, color: Colors.white),
                )
              : Offstage(),
        ),
      ),
    );
  }
}
