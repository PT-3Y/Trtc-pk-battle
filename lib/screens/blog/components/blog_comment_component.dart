import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/posts/wp_comments_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/blog/components/edit_blog_comment_component.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class BlogCommentComponent extends StatelessWidget {
  final WpCommentModel comment;
  final VoidCallback onDelete;
  final Function(WpCommentModel) onUpdate;

  BlogCommentComponent({required this.comment, required this.onDelete, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.scaffoldBackgroundColor),
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedImage(
                comment.author_avatar_urls!.ninetySix.validate(),
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(25),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comment.author_name.validate(), style: secondaryTextStyle()),
                  4.height,
                  Text(convertToAgo(comment.date.validate()), style: secondaryTextStyle()),
                ],
              ).expand(),
              if (comment.author.toString() == appStore.loginUserId)
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showInDialog(
                          context,
                          contentPadding: EdgeInsets.zero,
                          builder: (p0) {
                            return EditBlogCommentComponent(
                              id: comment.id.validate(),
                              comment: parseHtmlString(comment.content!.rendered.validate()),
                              onUpdate: (value) {
                                onUpdate.call(value);
                              },
                            );
                          },
                        );
                      },
                      child: cachedImage(ic_edit, color: context.primaryColor, height: 18, width: 18, fit: BoxFit.cover),
                    ),
                    8.width,
                    InkWell(
                      onTap: () {
                        showConfirmDialogCustom(
                          context,
                          onAccept: (c) {
                            ifNotTester(() {
                              onDelete.call();
                              deleteBlogComment(commentId: comment.id.validate()).then((value) {
                                //
                              }).catchError((e) {
                                toast(e.toString(), print: true);
                              });
                            });
                          },
                          dialogType: DialogType.DELETE,

                          title: language.deleteCommentConfirmation,
                          positiveText: language.delete,
                        );
                      },
                      child: cachedImage(ic_delete, color: Colors.red, height: 18, width: 18, fit: BoxFit.cover),
                    ),
                  ],
                ),
            ],
          ),
          16.height,
          Text(parseHtmlString(comment.content!.rendered.validate()), style: primaryTextStyle()).paddingSymmetric(horizontal: 16)
        ],
      ),
    );
  }
}
