import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models/post_mdeia_model.dart';
import 'package:socialv/models/posts/comment_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/post/components/comment_component.dart';
import 'package:socialv/screens/post/components/update_comment_component.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class CommentReplyScreen extends StatefulWidget {
  final CommentModel comment;
  final int postId;
  final VoidCallback? callback;

  CommentReplyScreen({required this.comment, required this.postId, this.callback});

  @override
  State<CommentReplyScreen> createState() => _CommentReplyScreenState();
}

class _CommentReplyScreenState extends State<CommentReplyScreen> {
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();

  int commentParentId = -1;
  List<CommentModel> commentList = [];

  bool isChange = false;
  GiphyGif? gif;

  @override
  void initState() {
    commentParentId = widget.comment.id.validate().toInt();
    commentList = widget.comment.children.validate();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void deleteComment({required int commentId, bool isParent = false}) async {
    ifNotTester(() async {
      appStore.setLoading(true);
      await deletePostComment(postId: widget.postId, commentId: commentId).then((value) {
        commentList.removeWhere((element) => element.id == commentId.toString());
        isChange = true;
        widget.callback?.call();
        setState(() {});

        appStore.setLoading(false);

        if (isParent) {
          finish(context, true);
        }
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    });
  }

  void postComment(String commentContent, {int? parentId}) async {
    ifNotTester(() async {
      appStore.setLoading(true);

      await savePostComment(
        postId: widget.postId,
        content: commentContent,
        parentId: parentId,
        gifId: gif != null ? gif!.id.validate() : "",
        gifUrl: gif != null ? gif!.images!.original!.url.validate() : "",
      ).then((value) {
        var comment = CommentModel(
          content: commentContent,
          userImage: appStore.loginAvatarUrl,
          dateRecorded: DateFormat(DATE_FORMAT_1).format(DateTime.now()),
          userName: appStore.loginFullName,
          userId: appStore.loginUserId,
          id: value.commentId.validate().toString(),
          medias: gif != null ? [PostMediaModel(url: gif!.images!.original!.url.validate())] : [],
        );
        commentList.add(comment);
        isChange = true;
        gif = null;

        setState(() {});
        appStore.setLoading(false);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        finish(context, isChange);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: context.cardColor,
        appBar: AppBar(
          backgroundColor: context.cardColor,
          title: Text(language.comments, style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.iconColor),
            onPressed: () {
              finish(context);
            },
          ),
        ),
        body: SizedBox(
          height: context.height(),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 90),
                child: Column(
                  children: [
                    CommentComponent(
                      fromReplyScreen: true,
                      isParent: true,
                      comment: widget.comment,
                      onDelete: () {
                        showConfirmDialogCustom(
                          context,
                          dialogType: DialogType.DELETE,
                          onAccept: (c) {
                            deleteComment(commentId: widget.comment.id.validate().toInt(), isParent: true);
                          },
                        );
                      },
                      onReply: () async {
                        FocusScope.of(context).requestFocus(commentFocus);
                        commentParentId = widget.comment.id.validate().toInt();
                      },
                      onEdit: () {
                        showInDialog(
                          context,
                          contentPadding: EdgeInsets.zero,
                          builder: (p0) {
                            return UpdateCommentComponent(
                              id: widget.comment.id.validate().toInt(),
                              activityId: widget.comment.itemId.validate().toInt(),
                              comment: widget.comment.content,
                              parentId: widget.comment.secondaryItemId.validate().toInt(),
                              medias: widget.comment.medias.validate(),
                              callback: (text) {
                                isChange = true;
                                widget.comment.content = text;
                                setState(() {});
                                widget.callback?.call();
                              },
                            );
                          },
                        );
                      },
                      postId: widget.postId,
                    ),
                    if (commentList.isNotEmpty)
                      ListView.separated(
                        itemBuilder: (context, i) {
                          CommentModel childComment = commentList[i];

                          return CommentComponent(
                            fromReplyScreen: true,
                            postId: widget.postId,
                            isParent: false,
                            comment: childComment,
                            onDelete: () {
                              deleteComment(commentId: childComment.id.toInt());
                            },
                            callback: () {
                              widget.callback?.call();
                            },
                            onReply: () async {
                              finish(context, isChange);
                              CommentReplyScreen(
                                postId: widget.postId,
                                comment: childComment,
                              ).launch(context).then((value) {
                                if (value ?? false) widget.callback?.call();
                              });
                            },
                            onEdit: () {
                              showInDialog(
                                context,
                                contentPadding: EdgeInsets.zero,
                                builder: (p0) {
                                  return UpdateCommentComponent(
                                    id: childComment.id.validate().toInt(),
                                    activityId: childComment.itemId.validate().toInt(),
                                    comment: childComment.content,
                                    parentId: childComment.secondaryItemId.validate().toInt(),
                                    medias: childComment.medias.validate(),
                                    callback: (text) {
                                      isChange = true;
                                      commentList[i].content = text;
                                      setState(() {});
                                      widget.callback?.call();
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                        itemCount: commentList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 16, top: 8),
                        separatorBuilder: (c, i) => Divider(height: 0),
                      ),
                    Divider(),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: context.width(),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: context.scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          cachedImage(appStore.loginAvatarUrl, height: 36, width: 36, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
                          10.width,
                          AppTextField(
                            focus: commentFocus,
                            controller: commentController,
                            textFieldType: TextFieldType.OTHER,
                            decoration: InputDecoration(
                              hintText: language.writeAComment,
                              hintStyle: secondaryTextStyle(size: 16),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                            onTap: () {
                              commentParentId = widget.comment.id.validate().toInt();
                            },
                          ).expand(),
                          if (appStore.showGif)
                            IconButton(
                              onPressed: () {
                                selectGif(context: context).then((value) {
                                  if (value != null) {
                                    gif = value;
                                    setState(() {});
                                    log('Gif Url: ${gif!.images!.original!.url.validate()}');
                                  }
                                });
                              },
                              icon: cachedImage(ic_gif, color: appStore.isDarkMode ? bodyDark : bodyWhite, width: 30, height: 24, fit: BoxFit.contain),
                            ),
                          InkWell(
                            onTap: () {
                              if (commentController.text.isNotEmpty || gif != null) {
                                hideKeyboard(context);

                                String content = commentController.text.trim();
                                commentController.clear();

                                postComment(content, parentId: commentParentId == -1 ? null : commentParentId);
                              } else {
                                toast(language.writeComment);
                              }
                            },
                            child: cachedImage(ic_send, color: appStore.isDarkMode ? bodyDark : bodyWhite, width: 24, height: 24, fit: BoxFit.cover),
                          ),
                        ],
                      ),
                      if (gif != null)
                        Stack(
                          children: [
                            LoadingWidget(isBlurBackground: false).paddingSymmetric(vertical: 16),
                            cachedImage(gif!.images!.original!.url.validate(), height: 200).cornerRadiusWithClipRRect(defaultAppButtonRadius).paddingSymmetric(vertical: 8),
                          ],
                        )
                    ],
                  ),
                ),
              ),
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
