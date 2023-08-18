import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models/post_mdeia_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

// ignore: must_be_immutable
class UpdateCommentComponent extends StatefulWidget {
  final int? id;
  final int? activityId;
  final String? comment;
  final int? parentId;
  final Function(String)? callback;
  List<PostMediaModel>? medias;

  UpdateCommentComponent({this.id, this.activityId, this.comment, this.parentId, this.callback, this.medias});

  @override
  State<UpdateCommentComponent> createState() => _UpdateCommentComponentState();
}

class _UpdateCommentComponentState extends State<UpdateCommentComponent> {
  double selectedRating = 3;

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.comment != null) {
      textController.text = parseHtmlString(widget.comment.validate());
    }
  }

  void updateComment() {
    if (textController.text.isNotEmpty) {
      ifNotTester(() async {
        appStore.setLoading(true);
        finish(context);
        await savePostComment(postId: widget.activityId.validate(), id: widget.id, content: textController.text, parentId: widget.parentId).then((value) async {
          widget.callback?.call(textController.text);
          toast(language.commentUpdatedSuccessfully);
          appStore.setLoading(false);
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        });
      });
    } else {
      toast(language.writeComment);
    }
  }

  /// todo: remove media from component and refresh

  void deletePostMedia(PostMediaModel media) {
    ifNotTester(() {
      deleteMedia(id: media.id.validate().toInt(), type: MediaTypes.gif).then((value) {
        log(value);
      }).catchError((e) {
        toast(e.toString(), print: true);

        widget.callback?.call(textController.text);

        finish(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(language.editComment, style: boldTextStyle(color: context.primaryColor, size: 20)),
            16.height,
            AppTextField(
              controller: textController,
              textFieldType: TextFieldType.OTHER,
              minLines: 5,
              maxLines: 10,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
                labelText: language.comment,
                labelStyle: secondaryTextStyle(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: radius(),
                  borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: radius(),
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: radius(),
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
                errorMaxLines: 2,
                errorStyle: primaryTextStyle(color: Colors.red, size: 12),
                focusedBorder: OutlineInputBorder(borderRadius: radius(), borderSide: BorderSide(color: context.scaffoldBackgroundColor, width: 0.0)),
                filled: true,
                fillColor: context.scaffoldBackgroundColor,
              ),
              onFieldSubmitted: (x) {
                updateComment();
              },
            ),
            if (widget.medias.validate().isNotEmpty)
              HorizontalList(
                itemCount: widget.medias.validate().length,
                itemBuilder: (ctx, index) {
                  PostMediaModel media = widget.medias.validate()[index];

                  return Stack(
                    children: [
                      cachedImage(media.url.validate(), height: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(commonRadius),
                      Positioned(
                        child: Icon(Icons.cancel_outlined, color: context.primaryColor, size: 18).onTap(() async {
                          deletePostMedia(media);
                        }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                        right: 4,
                        top: 4,
                      ),
                    ],
                  );
                },
              ),
            32.height,
            Row(
              children: [
                AppButton(
                  text: language.cancel,
                  textColor: textPrimaryColorGlobal,
                  color: context.cardColor,
                  elevation: 0,
                  onTap: () {
                    finish(context);
                  },
                ).expand(),
                16.width,
                AppButton(
                  textColor: Colors.white,
                  text: language.submit,
                  elevation: 0,
                  color: context.primaryColor,
                  onTap: () {
                    updateComment();
                  },
                ).expand(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
