import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/posts/wp_comments_model.dart';
import 'package:socialv/network/rest_apis.dart';

import '../../../utils/app_constants.dart';

// ignore: must_be_immutable
class EditBlogCommentComponent extends StatefulWidget {
  final int? id;
  final String? comment;
  final Function(WpCommentModel) onUpdate;

  EditBlogCommentComponent({this.id, this.comment, required this.onUpdate});

  @override
  State<EditBlogCommentComponent> createState() => _EditBlogCommentComponentState();
}

class _EditBlogCommentComponentState extends State<EditBlogCommentComponent> {
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
        await updateBlogComment(commentId: widget.id.validate(), content: textController.text).then((value) async {
          widget.onUpdate.call(value);
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
