import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/like_button_widget.dart';
import 'package:socialv/models/posts/post_model.dart';
import 'package:socialv/screens/post/components/post_content_component.dart';
import 'package:socialv/screens/post/components/post_component.dart';
import 'package:socialv/screens/post/components/post_media_component.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../main.dart';
import '../screens/dashboard_screen.dart';
import '../screens/post/components/reaction_button_widget.dart';

class QuickViewPostWidget extends StatefulWidget {
  final PostModel postModel;
  final bool isPostLiked;
  final Function()? onPostLike;
  final Function(int)? onPostReacted;
  final Function()? onReactionRemoved;
  final int? pageIndex;
  final bool isPostReacted;

  QuickViewPostWidget({this.pageIndex, required this.postModel, this.isPostLiked = false, this.onPostLike, this.onPostReacted, required this.isPostReacted, this.onReactionRemoved});

  @override
  State<QuickViewPostWidget> createState() => _QuickViewPostWidgetState();
}

class _QuickViewPostWidgetState extends State<QuickViewPostWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String postContent = '';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200), reverseDuration: const Duration(milliseconds: 700));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuad);
    _animationController.forward();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3, tileMode: TileMode.repeated),
        child: Container(
          child: ScaleTransition(
            scale: _animation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: appStore.isDarkMode ? Colors.white12 : Colors.transparent),
              ),
              backgroundColor: context.cardColor,
              insetPadding: EdgeInsets.only(left: 12, top: 24, right: 12, bottom: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        cachedImage(
                          widget.postModel.userImage.validate(),
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ).cornerRadiusWithClipRRect(100),
                        12.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.postModel.userName.validate(), style: boldTextStyle()),
                            4.height,
                            Text(convertToAgo(widget.postModel.dateRecorded.validate()), style: secondaryTextStyle()),
                          ],
                        ),
                      ],
                    ).paddingOnly(left: 8, top: 8, right: 8),
                    Divider(),
                    PostContentComponent(
                      blogId: widget.postModel.blogId,
                      postType: widget.postModel.type,
                      hasMentions: widget.postModel.hasMentions == 1,
                      postContent: widget.postModel.content,
                    ),
                    PostMediaComponent(
                      mediaTitle: widget.postModel.userName.validate(),
                      mediaType: widget.postModel.mediaType.validate(),
                      mediaList: widget.postModel.medias.validate(),
                      isFromPostDetail: true,
                      initialPageIndex: widget.pageIndex.validate(),
                    ).paddingSymmetric(horizontal: 8),
                    if (widget.postModel.childPost != null)
                      PostComponent(
                        post: widget.postModel.childPost!,
                        color: context.scaffoldBackgroundColor,
                        childPost: true,
                      ),
                    Row(
                      children: [
                        if (appStore.isReactionEnable == 1)
                          if (reactions.validate().isNotEmpty)
                            ReactionButton(
                              isComments: false,
                              currentUserReaction: widget.postModel.curUserReaction,
                              onReacted: (id) {
                                widget.onPostReacted?.call(id);
                              },
                              onReactionRemoved: () {
                                widget.onReactionRemoved?.call();
                              },
                            )
                          else
                            Offstage()
                        else
                          LikeButtonWidget(
                            onPostLike: () {
                              widget.onPostLike?.call();
                            },
                            isPostLiked: widget.isPostLiked,
                          ),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            ic_chat,
                            height: 22,
                            width: 22,
                            fit: BoxFit.cover,
                            color: context.iconColor,
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
