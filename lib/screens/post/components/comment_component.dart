import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models/post_mdeia_model.dart';
import 'package:socialv/models/posts/comment_model.dart';
import 'package:socialv/screens/post/components/post_reaction_component.dart';
import 'package:socialv/screens/post/components/reaction_button_widget.dart';
import 'package:socialv/screens/post/screens/comment_reply_screen.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';
import '../../../models/reactions/reactions_count_model.dart';

import '../../../network/rest_apis.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/html_widget.dart';
import '../../dashboard_screen.dart';

class CommentComponent extends StatefulWidget {
  final CommentModel comment;
  final bool isParent;
  final bool fromReplyScreen;
  final int postId;
  final VoidCallback? onReply;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? callback;

  CommentComponent({
    required this.isParent,
    required this.postId,
    this.onReply,
    this.onDelete,
    this.fromReplyScreen = false,
    this.callback,
    this.onEdit,
    required this.comment,
  });

  @override
  State<CommentComponent> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  bool isChange = false;
  late PageController pageController;
  List<Reactions> commentReactionList = [];
  int commentReactionCount = 0;
  bool? isReacted;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
    init();
  }

  Future<void> init() async {
    commentReactionList = widget.comment.reactions.validate();
    commentReactionCount = widget.comment.reactionCount.validate();
    isReacted = widget.comment.curUserReaction != null;
    setState(() {});
  }

  Future<void> postReaction({bool addReaction = false, int? reactionID}) async {
    ifNotTester(() async {
      if (addReaction) {
        if (commentReactionList.length < 3 && isReacted.validate()) {
          if (commentReactionList.any((element) => element.user!.id.validate().toString() == appStore.loginUserId)) {
            int index = commentReactionList.indexWhere((element) => element.user!.id.validate().toString() == appStore.loginUserId);
            commentReactionList[index].id = reactionID.validate().toString();
            commentReactionList[index].icon = reactions.firstWhere((element) => element.id == reactionID.validate().toString().validate()).imageUrl.validate();
            commentReactionList[index].reaction = reactions.firstWhere((element) => element.id == reactionID.validate().toString().validate()).name.validate();
          } else {
            commentReactionList.add(
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
            commentReactionCount++;
            setState(() {});
          }
        }

        await addPostReaction(id: widget.comment.id.toInt().validate(), reactionId: reactionID.validate(), isComments: true).then((value) {
          //
        }).catchError((e) {
          log('Error: ${e.toString()}');
        });
        setState(() {});
      } else {
        commentReactionList.removeWhere((element) => element.user!.id.validate().toString() == appStore.loginUserId);

        commentReactionCount--;
        setState(() {});
        await deletePostReaction(id: widget.comment.id.toInt().validate(), isComments: true).then((value) {
          //
        }).catchError((e) {
          log('Error: ${e.toString()}');
        });
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Row(
          children: [
            cachedImage(
              widget.comment.userImage.validate(),
              height: 36,
              width: 36,
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRect(100),
            16.width,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: '${widget.comment.userName.validate()} ', style: boldTextStyle(size: 14, fontFamily: fontFamily)),
                      if (widget.comment.isUserVerified.validate()) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
                4.height,
                Text(convertToAgo(widget.comment.dateRecorded.validate()), style: secondaryTextStyle(size: 12)),
              ],
            ).expand(),
          ],
        ).onTap(() {
          MemberProfileScreen(memberId: widget.comment.userId.validate().toInt()).launch(context);
        }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
        8.height,
        (widget.comment.hasMentions == 1 || widget.comment.content.validate().contains('href'))
            ? HtmlWidget(postContent: widget.comment.content.validate())
            : Text(parseHtmlString(widget.comment.content.validate()), style: primaryTextStyle()),
        8.height,
        if (widget.comment.medias.validate().isNotEmpty)
          SizedBox(
            height: 200,
            width: context.width(),
            child: PageView.builder(
              controller: pageController,
              itemCount: widget.comment.medias.validate().length,
              itemBuilder: (ctx, index) {
                PostMediaModel media = widget.comment.medias.validate()[index];
                return cachedImage(media.url, radius: defaultAppButtonRadius);
              },
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (appStore.isReactionEnable==1 && reactions.validate().isNotEmpty && widget.comment.id != null)
                  ReactionButton(
                    isComments: true,
                    isReacted: isReacted,
                    currentUserReaction: widget.comment.curUserReaction,
                    onReacted: (id) {
                      isReacted = true;
                      postReaction(addReaction: true, reactionID: id);
                    },
                    onReactionRemoved: () {
                      isReacted = false;
                      postReaction(addReaction: false);
                    },
                  ).paddingRight(6),
                if (widget.comment.id != null)
                  IconButton(
                    onPressed: () {
                      if (!appStore.isLoading) {
                        isChange = true;
                        widget.onReply?.call();
                      }
                    },
                    icon: cachedImage(ic_reply, color: context.primaryColor, width: 16, height: 16),
                  ),
                if (widget.comment.userId == appStore.loginUserId && widget.comment.id != null)
                  IconButton(
                    onPressed: () {
                      if (!appStore.isLoading) {
                        isChange = true;
                        widget.onDelete?.call();
                      }
                    },
                    icon: cachedImage(ic_delete, color: Colors.red, width: 16, height: 16),
                  ),
                if (widget.comment.userId == appStore.loginUserId && widget.comment.id != null)
                  IconButton(
                    onPressed: () {
                      if (!appStore.isLoading) {
                        isChange = true;
                        widget.onEdit?.call();
                      }
                    },
                    icon: cachedImage(ic_edit, color: context.primaryColor, width: 16, height: 16),
                  ),
              ],
            ),
            if (!widget.isParent && widget.comment.children.validate().isNotEmpty)
              TextButton(
                onPressed: () {
                  if (!appStore.isLoading) {
                    if (widget.fromReplyScreen) {
                      finish(context, isChange);
                    }
                    CommentReplyScreen(
                      callback: () {
                        widget.callback?.call();
                      },
                      postId: widget.postId,
                      comment: widget.comment,
                    ).launch(context).then((value) {
                      if (value ?? false) {
                        widget.callback?.call();
                      }
                    });
                  }
                },
                child: Text(' ${language.replies}(${widget.comment.children.validate().length.validate()})', style: secondaryTextStyle(size: 12)),
              )
          ],
        ),
        ThreeReactionComponent(
          isComments: true,
          id: widget.comment.id.toInt().validate(),
          postReactionCount: commentReactionCount,
          postReactionList: commentReactionList,
        ),
      ],
    );
  }
}
