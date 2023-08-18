import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/member_detail_model.dart';
import 'package:socialv/models/posts/post_model.dart';
import 'package:socialv/models/story/highlight_category_list_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/blockReport/components/block_member_dialog.dart';
import 'package:socialv/screens/blockReport/components/show_report_dialog.dart';
import 'package:socialv/screens/groups/screens/group_screen.dart';
import 'package:socialv/screens/post/components/post_component.dart';
import 'package:socialv/screens/profile/components/profile_header_component.dart';
import 'package:socialv/screens/profile/components/request_follow_widget.dart';
import 'package:socialv/screens/profile/screens/member_friends_screen.dart';
import 'package:socialv/screens/profile/screens/personal_info_screen.dart';
import 'package:socialv/screens/settings/screens/settings_screen.dart';
import 'package:socialv/screens/stories/component/story_highlights_component.dart';

import '../../../utils/app_constants.dart';
import '../../gallery/screens/gallery_screen.dart';

class MemberProfileScreen extends StatefulWidget {
  final int memberId;

  MemberProfileScreen({required this.memberId});

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  MemberDetailModel member = MemberDetailModel();

  bool isCallback = false;
  bool showDetails = false;

  List<PostModel> postList = [];
  late Future<List<PostModel>> future;

  List<HighlightCategoryListModel> categoryList = [];

  ScrollController _scrollController = ScrollController();

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;
  bool isPostError = false;
  bool hasInfo = false;
  bool isLoading = true;
  bool isFetched = false;
  bool showNoData = false;
  bool isFavorites = false;

  @override
  void initState() {
    future = getPostList();
    setStatusBarColor(Colors.transparent);
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!mIsLastPage && postList.isNotEmpty) {
          mPage++;
          future = getPostList();
        }
      }
    });

    afterBuildCreated(() async {
      appStore.setLoading(true);
      getMember();
    });
  }

  Future<void> getCategoryList() async {
    appStore.setLoading(true);
    await getHighlightList().then((value) {
      categoryList = value;
      appStore.setLoading(false);
    }).catchError((e) {
      log(e.toString());
      appStore.setLoading(false);
    });
  }

  Future<List<PostModel>> getPostList() async {
    if (mPage == 1) postList.clear();
    isLoading = true;
    setState(() {});

    await getPost(type: isFavorites ? PostRequestType.favorites : PostRequestType.timeline, page: mPage, userId: widget.memberId).then((value) {
      mIsLastPage = value.length != PER_PAGE;
      postList.addAll(value);
      isLoading = false;
      setState(() {});
    }).catchError((e) {
      isPostError = true;
      isLoading = false;
      setState(() {});
      if (e.toString() != 'Private account.') toast(e.toString(), print: true);
    });

    return postList;
  }

  Future<void> getMember() async {
    await getMemberDetail(userId: widget.memberId).then((value) {
      member = value.first;
      isFetched = true;
      for (var i in member.profileInfo.validate()) {
        for (var j in i.fields.validate()) {
          if (j.value.validate().isNotEmpty) {
            hasInfo = true;
            break;
          }
        }
      }

      if (member.accountType.validate() == AccountType.private) {
        if (member.blockedByMe.validate() || member.blockedBy.validate()) {
          showDetails = false;
        } else {
          if (member.friendshipStatus.validate() == Friendship.isFriend || member.friendshipStatus.validate() == Friendship.currentUser) {
            showDetails = true;
          } else {
            showDetails = false;
          }
        }
      } else {
        if (member.blockedByMe.validate() || member.blockedBy.validate()) {
          showDetails = false;
        } else {
          showDetails = true;
        }
      }

      if (member.id.validate() == appStore.loginUserId) {
        getCategoryList();
      }

      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      showNoData = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> onRefresh() async {
    isPostError = false;
    showNoData = false;
    appStore.setLoading(true);
    mPage = 1;
    future = getPostList();
    getMember();
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

        finish(context, isCallback);
        return Future.value(true);
      },
      child: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        color: appColorPrimary,
        child: Observer(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text(language.profile, style: boldTextStyle(size: 20)),
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: context.iconColor),
                onPressed: () {
                  finish(context);
                },
              ),
              actions: [
                if (!appStore.isLoading && showDetails && widget.memberId.toString() != appStore.loginUserId)
                  Theme(
                    data: Theme.of(context).copyWith(useMaterial3: false),
                    child: PopupMenuButton(
                      enabled: !appStore.isLoading,
                      position: PopupMenuPosition.under,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
                      onSelected: (val) async {
                        if (val == 1) {
                          PersonalInfoScreen(profileInfo: member.profileInfo.validate(), hasUserInfo: hasInfo).launch(context);
                        } else if (val == 2) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BlockMemberDialog(
                                mentionName: member.mentionName.validate(),
                                id: member.id.validate().toInt(),
                                callback: () {
                                  appStore.setLoading(true);
                                  getMember();
                                },
                              );
                            },
                          ).then((value) {});
                        } else {
                          await showModalBottomSheet(
                            context: context,
                            elevation: 0,
                            isScrollControlled: true,
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
                                      child: ShowReportDialog(isPostReport: false, userId: widget.memberId),
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
                          child: Row(
                            children: [
                              Icon(Icons.info_outline_rounded, color: context.iconColor, size: 20),
                              8.width,
                              Text(language.about, style: primaryTextStyle()),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: [
                              Icon(Icons.block, color: context.iconColor, size: 20),
                              8.width,
                              Text(language.block, style: primaryTextStyle()),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 3,
                          child: Row(
                            children: [
                              Icon(Icons.report_gmailerrorred, color: context.iconColor, size: 20),
                              8.width,
                              Text(language.report, style: primaryTextStyle()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                IconButton(
                  onPressed: () {
                    SettingsScreen().launch(context).then((value) {
                      if (value ?? false) getMember();
                    });
                  },
                  icon: Image.asset(
                    ic_setting,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                    color: context.primaryColor,
                  ),
                ).visible(widget.memberId.toString() == appStore.loginUserId),
              ],
            ),
            body: Stack(
              children: [
                if (isFetched)
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        ProfileHeaderComponent(
                          avatarUrl: member.blockedBy.validate() ? AppImages.defaultAvatarUrl : member.memberAvatarImage.validate(),
                          cover: member.blockedBy.validate() ? null : member.memberCoverImage.validate(),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  member.blockedBy.validate() ? language.userNotFound : member.name.validate(),
                                  style: boldTextStyle(size: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ).flexible(flex: 1),
                                if (member.isUserVerified.validate() && !member.blockedBy.validate())
                                  Image.asset(ic_tick_filled, width: 18, height: 18, color: blueTickColor).paddingSymmetric(horizontal: 4),
                              ],
                            ),
                            4.height,
                            if (!member.blockedBy.validate()) Text(member.mentionName.validate(), style: secondaryTextStyle()),
                          ],
                        ).paddingAll(16),
                        if (!appStore.isLoading && !member.blockedBy.validate() && widget.memberId.toString() != appStore.loginUserId)
                          RequestFollowWidget(
                            userMentionName: member.mentionName.validate(),
                            userName: member.name.validate(),
                            memberId: member.id.validate().toInt(),
                            friendshipStatus: member.friendshipStatus.validate(),
                            callback: () {
                              isCallback = true;
                              future = getPostList();
                              getMember();
                            },
                            isBlockedByMe: member.blockedByMe.validate(),
                          ),
                        16.height,
                        if (appStore.showStoryHighlight == 1 && showDetails)
                          StoryHighlightsComponent(
                            categoryList: categoryList,
                            showAddOption: member.id.validate() == appStore.loginUserId,
                            avatarImage: member.memberAvatarImage.validate(),
                            highlightsList: member.highlightStory.validate(),
                            callback: () {
                              onRefresh();
                            },
                          ),
                        8.height,
                        Row(
                          children: [
                            if (appStore.displayPostCount == 1)
                              Column(
                                children: [
                                  Text(member.postCount.validate().toString(), style: boldTextStyle(size: 18)),
                                  4.height,
                                  Text(language.posts, style: secondaryTextStyle(size: 12)),
                                ],
                              ).onTap(() {
                                _scrollController.animateTo(context.height() * 0.35, duration: const Duration(milliseconds: 500), curve: Curves.linear);
                              }, splashColor: Colors.transparent, highlightColor: Colors.transparent).expand(),
                            Column(
                              children: [
                                Text(member.friendsCount.validate().toString(), style: boldTextStyle(size: 18)),
                                4.height,
                                Text(language.friends, style: secondaryTextStyle(size: 12)),
                              ],
                            ).onTap(() {
                              if (member.friendsCount.validate() != 0 && showDetails) {
                                MemberFriendsScreen(memberId: member.id.validate().toInt()).launch(context);
                              } else {
                                toast(language.canNotViewFriends);
                              }
                            }, splashColor: Colors.transparent, highlightColor: Colors.transparent).expand(),
                            Column(
                              children: [
                                Text(member.groupsCount.validate().toString(), style: boldTextStyle(size: 18)),
                                4.height,
                                Text(language.groups, style: secondaryTextStyle(size: 12)),
                              ],
                            ).onTap(() {
                              if (member.groupsCount.validate() != 0 && showDetails) {
                                GroupScreen(userId: member.id.validate().toInt()).launch(context);
                              } else {
                                toast(language.canNotViewGroups);
                              }
                            }, splashColor: Colors.transparent, highlightColor: Colors.transparent).expand(),
                          ],
                        ),
                        8.height,
                        if (showDetails)
                          TextIcon(
                            onTap: () {
                              GalleryScreen(userId: member.id.toInt(), canEdit: false).launch(context);
                            },
                            text: language.viewGallery,
                            textStyle: primaryTextStyle(color: appColorPrimary),
                            prefix: Image.asset(ic_image, width: 18, height: 18, color: appColorPrimary),
                          ),
                        8.height,
                        if (!appStore.isLoading && showDetails)
                          FutureBuilder<List<PostModel>>(
                            future: future,
                            builder: (ctx, snap) {
                              if (snap.hasError) {
                                return NoDataWidget(
                                  imageWidget: NoDataLottieWidget(),
                                  title: language.somethingWentWrong,
                                ).center();
                              }

                              if (snap.hasData) {
                                return Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(language.posts, style: boldTextStyle(color: appColorPrimary)).paddingSymmetric(horizontal: 16),
                                            TextIcon(
                                              onTap: () {
                                                isFavorites = !isFavorites;
                                                mPage = 1;
                                                setState(() {});
                                                getPostList();
                                              },
                                              prefix: Icon(isFavorites ? Icons.check_circle : Icons.circle_outlined, color: appColorPrimary, size: 18),
                                              text: language.favorites,
                                              textStyle: secondaryTextStyle(color: isFavorites ? context.primaryColor : null),
                                            ).paddingSymmetric(horizontal: 8),
                                          ],
                                        ).visible(member.postCount.validate() != 0),
                                        if (snap.data.validate().isEmpty && !isLoading)
                                          Offstage()
                                        else
                                          AnimatedListView(
                                            padding: EdgeInsets.only(left: 8, right: 8, bottom: 50),
                                            itemCount: postList.length,
                                            slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
                                            itemBuilder: (context, index) {
                                              return PostComponent(
                                                fromProfile: true,
                                                post: postList[index],
                                                callback: () {
                                                  appStore.setLoading(true);
                                                  mPage = 1;
                                                  future = getPostList();
                                                  getMember();
                                                },
                                                commentCallback: () {
                                                  mPage = 1;
                                                  future = getPostList();
                                                },
                                              );
                                            },
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                          ),
                                      ],
                                    ),
                                    if (isLoading)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        left: 0,
                                        child: ThreeBounceLoadingWidget(),
                                      )
                                  ],
                                );
                              }
                              return ThreeBounceLoadingWidget().paddingTop(16);
                            },
                          ),
                        16.height,
                        if (member.accountType == AccountType.private && !showDetails)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(border: Border.all(), shape: BoxShape.circle),
                                padding: EdgeInsets.all(8),
                                child: Image.asset(ic_lock, height: 24, width: 24, color: context.iconColor),
                              ),
                              16.height,
                              Text(language.thisAccountIsPrivate, style: boldTextStyle()),
                              Text(
                                language.followThisAccountText,
                                style: secondaryTextStyle(),
                                textAlign: TextAlign.center,
                              ).paddingSymmetric(horizontal: 16),
                            ],
                          ),
                      ],
                    ),
                  ),
                if (appStore.isLoading) LoadingWidget().center(),
                if (!appStore.isLoading && showNoData)
                  NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: isError ? language.somethingWentWrong : language.noDataFound,
                    onRetry: () {
                      onRefresh();
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
