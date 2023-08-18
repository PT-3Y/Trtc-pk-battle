import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/posts/get_post_likes_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class PostLikesScreen extends StatefulWidget {
  final int postId;

  const PostLikesScreen({required this.postId});

  @override
  State<PostLikesScreen> createState() => _PostLikesScreenState();
}

class _PostLikesScreenState extends State<PostLikesScreen> {
  List<GetPostLikesModel> list = [];
  late Future<List<GetPostLikesModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    future = likesList();
    super.initState();
  }

  Future<List<GetPostLikesModel>> likesList() async {
    appStore.setLoading(true);

    await getPostLikes(id: widget.postId, page: mPage).then((value) {
      if (mPage == 1) list.clear();

      mIsLastPage = value.length != PER_PAGE;
      list.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      setState(() {});
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return list;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    future = likesList();
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(language.likes, style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.iconColor),
            onPressed: () {
              finish(context);
            },
          ),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            FutureBuilder<List<GetPostLikesModel>>(
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
                      slideConfiguration: SlideConfiguration(
                        delay: 80.milliseconds,
                        verticalOffset: 300,
                      ),
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        GetPostLikesModel user = list[index];

                        return Row(
                          children: [
                            cachedImage(
                              user.userAvatar.validate(),
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ).cornerRadiusWithClipRRect(100),
                            20.width,
                            Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(text: user.userName.validate(), style: boldTextStyle(size: 14, fontFamily: fontFamily)),
                                      if (user.isUserVerified.validate()) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                                if (user.userMentionName.validate().isNotEmpty) Text(user.userMentionName.validate(), style: secondaryTextStyle()),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ).expand(),
                          ],
                        ).onTap(() async {
                          MemberProfileScreen(memberId: list[index].userId.validate().toInt()).launch(context);
                        }, splashColor: Colors.transparent, highlightColor: Colors.transparent).paddingSymmetric(vertical: 8);
                      },
                      onNextPage: () {
                        if (!mIsLastPage) {
                          mPage++;
                          future = likesList();
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
    );
  }
}
