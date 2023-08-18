import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/story/story_views_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class StoryViewsScreen extends StatefulWidget {
  final int storyId;
  final int viewCount;

  const StoryViewsScreen({required this.storyId, required this.viewCount});

  @override
  State<StoryViewsScreen> createState() => _StoryViewsScreenState();
}

class _StoryViewsScreenState extends State<StoryViewsScreen> {
  List<StoryViewsModel> memberList = [];
  late Future<List<StoryViewsModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = getViews();
    super.initState();
  }

  Future<List<StoryViewsModel>> getViews() async {
    appStore.setLoading(true);

    await getStoryViews(storyId: widget.storyId).then((value) {
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
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        FutureBuilder<List<StoryViewsModel>>(
          future: future,
          builder: (ctx, snap) {
            if (snap.hasError) {
              return NoDataWidget(
                imageWidget: NoDataLottieWidget(),
                title: isError ? language.somethingWentWrong : language.noDataFound,
              ).center();
            }
            if (snap.hasData) {
              if (snap.data.validate().isEmpty) {
                return NoDataWidget(
                  imageWidget: NoDataLottieWidget(),
                  title: isError ? language.somethingWentWrong : language.noDataFound,
                ).center();
              } else {
                return AnimatedListView(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  slideConfiguration: SlideConfiguration(
                    delay: 120.milliseconds,
                  ),
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 50, top: 60),
                  itemCount: memberList.length,
                  itemBuilder: (context, index) {
                    StoryViewsModel member = memberList[index];
                    return GestureDetector(
                      onTap: () {
                        MemberProfileScreen(memberId: memberList[index].userId.validate()).launch(context);
                      },
                      child: Row(
                        children: [
                          cachedImage(
                            member.userAvatar.validate(),
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
                              Text(member.mentionName.validate(), style: secondaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ).expand(),
                          Text(convertToAgo(member.seenTime.validate().toString()), style: secondaryTextStyle()),
                        ],
                      ).paddingSymmetric(vertical: 8),
                    );
                  },
                  onNextPage: () {
                    if (!mIsLastPage) {
                      mPage++;
                      getViews();
                    }
                  },
                );
              }
            }

            return Offstage();
          },
        ),
        Container(
          width: context.width(),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            color: context.primaryColor,
          ),
          child: Text('${language.viewedBy} ${widget.viewCount}', style: primaryTextStyle(color: Colors.white)),
        ),
        Observer(builder: (_) {
          return Positioned(
            bottom: mPage != 1 ? 10 : null,
            child: LoadingWidget(isBlurBackground: mPage == 1 ? true : false),
          ).visible(appStore.isLoading);
        }),
      ],
    );
  }
}
