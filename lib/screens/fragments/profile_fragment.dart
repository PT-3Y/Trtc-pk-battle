import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/member_detail_model.dart';
import 'package:socialv/models/story/highlight_category_list_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/groups/screens/group_screen.dart';
import 'package:socialv/screens/post/components/post_component.dart';
import 'package:socialv/screens/profile/components/profile_header_component.dart';
import 'package:socialv/screens/profile/screens/profile_friends_screen.dart';
import 'package:socialv/screens/stories/component/story_highlights_component.dart';

import '../../models/posts/post_model.dart';
import '../../utils/app_constants.dart';
import '../gallery/screens/gallery_screen.dart';
import '../profile/screens/personal_info_screen.dart';

class ProfileFragment extends StatefulWidget {
  final ScrollController? controller;

  const ProfileFragment({this.controller});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  MemberDetailModel _memberDetails = MemberDetailModel();
  List<PostModel> _userPostList = [];
  late Future<List<PostModel>> future;

  List<HighlightCategoryListModel> categoryList = [];

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;
  bool isLoading = false;
  bool isFavorites = false;

  @override
  void initState() {
    future = getUserPostList();

    setStatusBarColor(Colors.transparent);
    super.initState();
    widget.controller?.addListener(() {
      if (selectedIndex == 4) {
        if (widget.controller?.position.pixels == widget.controller?.position.maxScrollExtent) {
          if (!mIsLastPage) {
            mPage++;
            future = getUserPostList();
          }
        }
      }
    });
    getCategoryList();
    getMemberDetails();
    LiveStream().on(OnAddPostProfile, (p0) {
      getMemberDetails();
      getCategoryList();

      _userPostList.clear();
      mPage = 1;
      future = getUserPostList();
    });
  }

  Future<void> getMemberDetails({bool showLoader = true}) async {
    if (showLoader) appStore.setLoading(true);
    await getMemberDetail(userId: appStore.loginUserId.toInt()).then((value) async {
      _memberDetails = value.first;
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<List<PostModel>> getUserPostList({bool showLoader = true}) async {
    if (mPage == 1) _userPostList.clear();
    if (showLoader) appStore.setLoading(true);

    isLoading = true;
    setState(() {});
    await getPost(type: isFavorites ? PostRequestType.favorites : PostRequestType.timeline, page: mPage).then((value) {
      mIsLastPage = value.length != PER_PAGE;
      isLoading = false;
      appStore.setLoading(false);
      _userPostList.addAll(value);
      setState(() {});
    }).catchError((e) {
      isLoading = false;
      appStore.setLoading(false);
      isError = true;
      setState(() {});
      toast(e.toString(), print: true);
    });
    setState(() {});
    return _userPostList;
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

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(OnAddPostProfile);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Observer(builder: (_) => ProfileHeaderComponent(avatarUrl: appStore.loginAvatarUrl, cover: _memberDetails.memberCoverImage.validate())),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Observer(builder: (context) {
                  return RichText(
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: appStore.loginFullName,
                      style: boldTextStyle(size: 20),
                      children: [
                        if (_memberDetails.isUserVerified.validate())
                          WidgetSpan(
                            child: Image.asset(ic_tick_filled, width: 20, height: 20, color: blueTickColor).paddingSymmetric(horizontal: 4),
                          ),
                      ],
                    ),
                  );
                }),
                4.height,
                TextIcon(
                  edgeInsets: EdgeInsets.zero,
                  spacing: 0,
                  onTap: () {
                    PersonalInfoScreen(profileInfo: _memberDetails.profileInfo.validate(), hasUserInfo: true).launch(context);
                  },
                  text: appStore.loginName,
                  textStyle: secondaryTextStyle(),
                  suffix: SizedBox(
                    height: 26,
                    width: 26,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        PersonalInfoScreen(profileInfo: _memberDetails.profileInfo.validate(), hasUserInfo: true).launch(context);
                      },
                      icon: Icon(Icons.info_outline_rounded),
                      iconSize: 18,
                      splashRadius: 1,
                    ),
                  ),
                ),
              ],
            ).paddingAll(16),
            Observer(builder: (context) {
              return Row(
                children: [
                  if (appStore.displayPostCount == 1)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_memberDetails.postCount.validate().toString(), style: boldTextStyle(size: 18)),
                        4.height,
                        Text(language.posts, style: secondaryTextStyle(size: 12)),
                      ],
                    ).paddingSymmetric(vertical: 8).onTap(() {
                      widget.controller?.animateTo(context.height() * 0.35, duration: const Duration(milliseconds: 500), curve: Curves.linear);
                    }, splashColor: Colors.transparent, highlightColor: Colors.transparent).expand(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_memberDetails.friendsCount.validate().toString(), style: boldTextStyle(size: 18)),
                      4.height,
                      Text(language.friends, style: secondaryTextStyle(size: 12)),
                    ],
                  ).paddingSymmetric(vertical: 8).onTap(() {
                    ProfileFriendsScreen().launch(context).then((value) {
                      if (value ?? false) getMemberDetails();
                    });
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent).expand(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_memberDetails.groupsCount.validate().toString(), style: boldTextStyle(size: 18)),
                      4.height,
                      Text(language.groups, style: secondaryTextStyle(size: 12)),
                    ],
                  ).paddingSymmetric(vertical: 8).onTap(() {
                    GroupScreen().launch(context).then((value) {
                      if (value) getMemberDetails();
                    });
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent).expand(),
                ],
              );
            }),
            TextIcon(
              onTap: () {
                GalleryScreen(userId: appStore.loginUserId.toInt(), canEdit: true).launch(context);
              },
              text: language.viewGallery,
              textStyle: primaryTextStyle(color: appColorPrimary),
              prefix: Image.asset(ic_image, width: 18, height: 18, color: appColorPrimary),
            ),
            if (appStore.showStoryHighlight == 1)
              StoryHighlightsComponent(
                categoryList: categoryList,
                avatarImage: _memberDetails.memberAvatarImage.validate(),
                highlightsList: _memberDetails.highlightStory.validate(),
              ),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language.posts, style: boldTextStyle(color: context.primaryColor, size: 20)),
                TextIcon(
                  onTap: () {
                    isFavorites = !isFavorites;
                    mPage = 1;
                    setState(() {});
                    getUserPostList();
                  },
                  prefix: Icon(isFavorites ? Icons.check_circle : Icons.circle_outlined, color: appColorPrimary, size: 18),
                  text: language.favorites,
                  textStyle: secondaryTextStyle(color: isFavorites ? context.primaryColor : null),
                ),
              ],
            ).paddingSymmetric(horizontal: 8),
            FutureBuilder<List<PostModel>>(
              future: future,
              builder: (ctx, snap) {
                if (snap.hasError) {
                  return NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: isError ? language.somethingWentWrong : language.noDataFound,
                    onRetry: () {
                      isError = false;
                      LiveStream().emit(OnAddPostProfile);
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center().paddingBottom(20);
                }

                if (snap.hasData) {
                  if (snap.data.validate().isEmpty && !isLoading) {
                    return appStore.isLoading
                        ? Offstage()
                        : NoDataWidget(
                            imageWidget: NoDataLottieWidget(),
                            title: language.noDataFound,
                            retryText: '   ${language.clickToRefresh}   ',
                          ).center().paddingBottom(20);
                  } else {
                    return Stack(
                      children: [
                        AnimatedListView(
                          padding: EdgeInsets.only(left: 8, right: 8, bottom: 50, top: 8),
                          itemCount: _userPostList.length,
                          slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return PostComponent(
                              fromProfile: true,
                              post: _userPostList[index],
                              callback: () {
                                isLoading = true;
                                mPage = 1;
                                getMemberDetails();
                                future = getUserPostList();
                              },
                              commentCallback: () {
                                mPage = 1;
                                future = getUserPostList(showLoader: false);
                              },
                            );
                          },
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
        ),
        Observer(
          builder: (_) => LoadingWidget(isBlurBackground: false).center().paddingTop(context.height() * 0.3).visible(appStore.isLoading),
        ),
      ],
    );
  }
}
