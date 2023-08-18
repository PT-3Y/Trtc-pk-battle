import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:socialv/components/like_button_widget.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/posts/comment_model.dart';
import 'package:socialv/models/posts/get_post_likes_model.dart';
import 'package:socialv/models/posts/post_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/post/components/comment_component.dart';
import 'package:socialv/screens/post/components/post_component.dart';
import 'package:socialv/screens/post/components/post_media_component.dart';
import 'package:socialv/screens/post/components/reaction_button_widget.dart';
import 'package:socialv/screens/post/components/update_comment_component.dart';
import 'package:socialv/screens/post/screens/comment_screen.dart';
import 'package:socialv/screens/post/screens/post_likes_screen.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../models/reactions/reactions_count_model.dart';
import '../../dashboard_screen.dart';
import '../components/post_content_component.dart';
import '../components/post_reaction_component.dart';

class SinglePostScreen extends StatefulWidget {
  final int postId;

  const SinglePostScreen({required this.postId});

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  PostModel post = PostModel();
  late Future<PostModel> future;

  PageController pageController = PageController();

  List<GetPostLikesModel> likeList = [];
  List<Reactions> postReactionList = [];
  bool? isReacted;
  int postReactionCount = 0;

  bool isLike = false;
  int likeCount = 0;

  bool isError = false;
  bool fetchPost = false;
  bool isChange = false;

  @override
  void initState() {
    future = postDetail();
    super.initState();
  }

  Future<PostModel> postDetail() async {
    isError = false;
    appStore.setLoading(true);

    getSinglePost(postId: widget.postId.validate()).then((value) {
      post = value;
      likeCount = value.likeCount.validate();
      likeList = value.usersWhoLiked.validate();
      isLike = value.isLiked.validate() == 1;
      fetchPost = true;
      postReactionList = value.reactions.validate();
      isReacted = value.curUserReaction != null;
      postReactionCount = value.reactionCount.validate();
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
      setState(() {});
    });

    return post;
  }

  Future<void> postReaction({bool addReaction = false, int? reactionID}) async {
    ifNotTester(() async {
      if (addReaction) {
        if (postReactionList.length < 3 && isReacted.validate()) {
          if (postReactionList.any((element) => element.user!.id.validate().toString() == appStore.loginUserId)) {
            int index = postReactionList.indexWhere((element) => element.user!.id.validate().toString() == appStore.loginUserId);
            postReactionList[index].id = reactionID.validate().toString();
            postReactionList[index].icon = reactions.firstWhere((element) => element.id == reactionID.validate().toString().validate()).imageUrl.validate();
            postReactionList[index].reaction = reactions.firstWhere((element) => element.id == reactionID.validate().toString().validate()).name.validate();
          } else {
            postReactionList.add(
              Reactions(
                id: reactionID.validate().toString(),
                icon: reactions.firstWhere((element) => element.id == reactionID.validate().toString().validate()).imageUrl.validate(),
                reaction: reactions.firstWhere((element) => element.id == reactionID.validate().toString().validate()).name.validate(),
                user: ReactedUser(
                  id: appStore.loginUserId.validate().toInt(),
                  displayName: appStore.loginFullName,
                ),
              ),
            );
            postReactionCount++;
          }
        }
        setState(() {});

        await addPostReaction(id: post.activityId.validate(), reactionId: reactionID.validate(), isComments: false).then((value) {
          //
        }).catchError((e) {
          log('Error: ${e.toString()}');
        });
      } else {
        postReactionList.removeWhere((element) => element.user!.id.validate().toString() == appStore.loginUserId);

        postReactionCount--;
        setState(() {});
        await deletePostReaction(id: post.activityId.validate(), isComments: false).then((value) {
          //
        }).catchError((e) {
          log('Error: ${e.toString()}');
        });
      }
    });
  }

  Future<void> postLike() async {
    ifNotTester(() {
      isLike = !isLike;

      likePost(postId: post.activityId.validate()).then((value) {
        isChange = true;
        if (likeList.length < 3 && isLike) {
          likeList.add(GetPostLikesModel(
            userId: appStore.loginUserId,
            userAvatar: appStore.loginAvatarUrl,
            userName: appStore.loginFullName,
          ));
        }
        if (!isLike) {
          if (likeList.length <= 3) {
            likeList.removeWhere((element) => element.userId == appStore.loginUserId);
          }
          likeCount--;
        }

        if (isLike) {
          likeCount++;
        }
        setState(() {});
      }).catchError((e) {
        if (likeList.length < 3) {
          likeList.removeWhere((element) => element.userId == appStore.loginUserId);
        }
        isLike = false;
        setState(() {});
        log(e.toString());
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        appStore.setLoading(false);

        finish(context, isChange);
        return Future.value(true);
      },
      child: RefreshIndicator(
        onRefresh: () async {
          future = postDetail();
        },
        color: context.primaryColor,
        child: Scaffold(
          appBar: AppBar(
            title: Text(language.post, style: boldTextStyle(size: 20)),
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
              FutureBuilder<PostModel>(
                future: future,
                builder: (ctx, snap) {
                  if (snap.hasError) {
                    return NoDataWidget(
                      imageWidget: NoDataLottieWidget(),
                      title: isError ? language.somethingWentWrong : language.noDataFound,
                      onRetry: () {
                        future = postDetail();
                      },
                      retryText: '   ${language.clickToRefresh}   ',
                    ).center();
                  }

                  if (snap.hasData) {
                    if (snap.data == null) {
                      return NoDataWidget(
                        imageWidget: NoDataLottieWidget(),
                        title: isError ? language.somethingWentWrong : language.noDataFound,
                        onRetry: () {
                          future = postDetail();
                        },
                        retryText: '   ${language.clickToRefresh}   ',
                      ).center();
                    } else {
                      return !appStore.isLoading && !isError
                          ? SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      cachedImage(
                                        post.userImage.validate(),
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ).cornerRadiusWithClipRRect(100),
                                      12.width,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                post.userName.validate(),
                                                style: boldTextStyle(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ).flexible(),
                                              if (post.isUserVerified == 1) Image.asset(ic_tick_filled, width: 18, height: 18, color: blueTickColor).paddingSymmetric(horizontal: 4),
                                            ],
                                          ),
                                          Text(post.userEmail.validate(), style: secondaryTextStyle()),
                                        ],
                                      ).expand(),
                                      Text(convertToAgo(post.dateRecorded.validate()), style: secondaryTextStyle()),
                                    ],
                                  ).paddingSymmetric(horizontal: 16).onTap(() {
                                    MemberProfileScreen(memberId: post.userId.validate()).launch(context);
                                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                                  20.height,
                                  Divider(height: 0),
                                  16.height,
                                  PostContentComponent(blogId: post.blogId, postType: post.type, hasMentions: post.hasMentions == 1, postContent: post.content),
                                  PostMediaComponent(
                                    mediaTitle: post.userName.validate(),
                                    mediaType: post.mediaType,
                                    mediaList: post.medias,
                                    isFromPostDetail: true,
                                  ).paddingSymmetric(horizontal: 8),
                                  if (post.childPost != null) PostComponent(post: post.childPost!, childPost: true),
                                  Row(
                                    children: [
                                      if (appStore.isReactionEnable==1)
                                        if (reactions.validate().isNotEmpty)
                                          ReactionButton(
                                            isComments: false,
                                            isReacted: isReacted,
                                            currentUserReaction: post.curUserReaction,
                                            onReacted: (id) {
                                              isReacted = true;
                                              postReaction(addReaction: true, reactionID: id);
                                            },
                                            onReactionRemoved: () {
                                              isReacted = false;
                                              postReaction(addReaction: false);
                                            },
                                          )
                                        else
                                          Offstage()
                                      else
                                        LikeButtonWidget(
                                          key: ValueKey(isLike),
                                          onPostLike: () {
                                            postLike();
                                          },
                                          isPostLiked: isLike,
                                        ),
                                      IconButton(
                                        onPressed: () {
                                          CommentScreen(postId: post.activityId.validate()).launch(context).then((value) {
                                            if (value ?? false) {
                                              isChange = true;
                                              postDetail();
                                            }
                                          });
                                        },
                                        icon: Image.asset(
                                          ic_chat,
                                          height: 22,
                                          width: 22,
                                          fit: BoxFit.cover,
                                          color: context.iconColor,
                                        ),
                                      ),
                                      Image.asset(
                                        ic_send,
                                        height: 22,
                                        width: 22,
                                        fit: BoxFit.cover,
                                        color: context.iconColor,
                                      ).onTap(() {
                                        String saveUrl = "$DOMAIN_URL/${widget.postId.validate()}";
                                        Share.share(saveUrl);
                                      }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                                    ],
                                  ).paddingSymmetric(horizontal: 16),
                                  12.height,
                                  ThreeReactionComponent(
                                    isComments: false,
                                    id: post.activityId.validate(),
                                    postReactionCount: postReactionCount,
                                    postReactionList: postReactionList,
                                  ).paddingSymmetric(horizontal: 16),
                                  if (likeList.isNotEmpty)
                                    Row(
                                      children: [
                                        Stack(
                                          children: likeList.validate().take(3).map((e) {
                                            return Container(
                                              width: 32,
                                              height: 32,
                                              margin: EdgeInsets.only(left: 18 * likeList.validate().indexOf(e).toDouble()),
                                              child: cachedImage(
                                                likeList.validate()[likeList.validate().indexOf(e)].userAvatar.validate(),
                                                fit: BoxFit.cover,
                                              ).cornerRadiusWithClipRRect(100),
                                            );
                                          }).toList(),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: language.likedBy,
                                            style: secondaryTextStyle(size: 12, fontFamily: fontFamily),
                                            children: <TextSpan>[
                                              TextSpan(text: ' ${likeList.first.userName.validate()}', style: boldTextStyle(size: 12, fontFamily: fontFamily)),
                                              if (likeList.length > 1) TextSpan(text: ' And ', style: secondaryTextStyle(size: 12, fontFamily: fontFamily)),
                                              if (likeList.length > 1) TextSpan(text: '${likeCount - 1} others', style: boldTextStyle(size: 12, fontFamily: fontFamily)),
                                            ],
                                          ),
                                        ).paddingAll(8).onTap(() {
                                          PostLikesScreen(postId: post.activityId.validate()).launch(context);
                                        }, splashColor: Colors.transparent, highlightColor: Colors.transparent)
                                      ],
                                    ).paddingSymmetric(horizontal: 16),
                                  if (post.commentCount.validate() > 0)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(
                                        onPressed: () {
                                          CommentScreen(postId: widget.postId).launch(context).then((value) {
                                            if (value ?? false) {
                                              isChange = true;
                                              postDetail();
                                            }
                                          });
                                        },
                                        child: Text(
                                          post.commentCount.validate() > 1 ? '${language.viewAll} ${post.commentCount.validate()} ${language.comments}' : language.comments.capitalizeFirstLetter(),
                                          style: secondaryTextStyle(),
                                        ),
                                      ),
                                    ).paddingSymmetric(horizontal: 16),
                                  if (post.comments.validate().isNotEmpty)
                                    AnimatedListView(
                                      shrinkWrap: true,
                                      slideConfiguration: SlideConfiguration(
                                        delay: 80.milliseconds,
                                        verticalOffset: 300,
                                      ),
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.fromLTRB(16, 16, 16, 76),
                                      itemCount: post.comments.validate().take(3).length,
                                      itemBuilder: (context, index) {
                                        CommentModel comment = post.comments.validate()[index];

                                        return CommentComponent(
                                          onReply: () {
                                            CommentScreen(postId: widget.postId).launch(context).then((value) {
                                              if (value ?? false) {
                                                isChange = true;
                                                postDetail();
                                              }
                                            });
                                          },
                                          onEdit: () {
                                            showInDialog(
                                              context,
                                              contentPadding: EdgeInsets.zero,
                                              builder: (p0) {
                                                return UpdateCommentComponent(
                                                  id: comment.id.validate().toInt(),
                                                  activityId: comment.itemId.validate().toInt(),
                                                  comment: comment.content,
                                                  parentId: comment.secondaryItemId.validate().toInt(),
                                                  medias: comment.medias.validate(),
                                                  callback: (x) {
                                                    isChange = true;
                                                    postDetail();
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          onDelete: () {
                                            CommentScreen(postId: widget.postId).launch(context).then((value) {
                                              if (value ?? false) {
                                                isChange = true;
                                                postDetail();
                                              }
                                            });
                                          },
                                          isParent: true,
                                          comment: post.comments.validate()[index],
                                          postId: widget.postId,
                                        );
                                      },
                                    ),
                                ],
                              ),
                            )
                          : Offstage();
                    }
                  }
                  return Offstage();
                },
              ),
              if (isError)
                NoDataWidget(
                  imageWidget: NoDataLottieWidget(),
                  title: isError ? language.somethingWentWrong : language.noDataFound,
                  onRetry: () {
                    future = postDetail();
                  },
                  retryText: '   ${language.clickToRefresh}   ',
                ).center(),
              Observer(
                builder: (_) {
                  if (appStore.isLoading) {
                    return LoadingWidget().center();
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
