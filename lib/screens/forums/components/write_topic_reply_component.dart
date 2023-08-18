import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/forums/common_models.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';

class WriteTopicReplyComponent extends StatefulWidget {
  final int topicId;
  final int? replyId;
  final String topicName;
  final Function(String)? newReply;
  final TopicReplyModel? reply;
  final List<TagsModel>? tags;

  const WriteTopicReplyComponent({required this.topicName, required this.topicId, this.replyId, this.newReply, this.reply, this.tags});

  @override
  State<WriteTopicReplyComponent> createState() => _WriteTopicReplyComponentState();
}

class _WriteTopicReplyComponentState extends State<WriteTopicReplyComponent> {
  final replyFormKey = GlobalKey<FormState>();

  TextEditingController content = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController tags = TextEditingController();

  bool doNotify = false;

  @override
  void initState() {
    super.initState();

    if (widget.reply != null) {
      content.text = widget.reply!.content.validate();
      widget.tags.validate().map((e) {
        tags.text = tags.text + '${e.name.validate()}';
      });
    }
  }

  Future<void> editReply() async {
    if (replyFormKey.currentState!.validate()) {
      replyFormKey.currentState!.save();
      hideKeyboard(context);

      ifNotTester(() async {
        Map request = {
          "id": widget.reply!.id,
          "is_topic": widget.topicId == widget.reply!.id ? 1 : 0,
          "topic_title": widget.topicName,
          "content": content.text,
          "tags": tags.text.split(','),
          "notify_me": doNotify,
          "image": image.text,
        };
        appStore.setLoading(true);

        await editTopicReply(request: request).then((value) async {
          toast(value.message);
          appStore.setLoading(false);
          widget.newReply?.call(content.text);
          finish(context, true);
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString());
        });
      });
    } else {
      appStore.setLoading(false);
    }
  }

  Future<void> reply() async {
    if (replyFormKey.currentState!.validate()) {
      replyFormKey.currentState!.save();
      hideKeyboard(context);

      ifNotTester(() async {
        Map request = {
          "topic_id": widget.topicId,
          "reply_id": widget.replyId != widget.topicId ? widget.replyId : null,
          "is_reply_topic": widget.replyId != widget.topicId ? 0 : 1,
          "content": content.text,
          "tags": tags.text.split(','),
          "notify_me": doNotify,
          "image": image.text,
        };
        appStore.setLoading(true);

        await replyTopic(request: request).then((value) async {
          toast(value.message);
          appStore.setLoading(false);
          widget.newReply?.call(content.text);
          finish(context, true);
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString());
        });
      });
    } else {
      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height() * 0.8,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
              ),
              8.height,
              Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, right: 16, left: 16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: replyFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        30.height,
                        Text('${language.replyTo}: ${widget.topicName}', style: boldTextStyle()),
                        16.height,
                        AppTextField(
                          controller: content,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          textFieldType: TextFieldType.MULTILINE,
                          textStyle: boldTextStyle(),
                          decoration: inputDecorationFilled(context, fillColor: context.scaffoldBackgroundColor, label: language.writeAReply),
                          minLines: 5,
                          onFieldSubmitted: (text) {
                            //addReview();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return language.pleaseEnterDescription;
                            }
                            return null;
                          },
                        ),
                        16.height,
                        TextField(
                          controller: image,
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          style: boldTextStyle(),
                          decoration: inputDecorationFilled(context, fillColor: context.scaffoldBackgroundColor, label: language.imageLink),
                        ),
                        16.height,
                        AppTextField(
                          controller: tags,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          textFieldType: TextFieldType.MULTILINE,
                          textStyle: boldTextStyle(),
                          minLines: 1,
                          maxLines: 5,
                          isValidationRequired: false,
                          decoration: inputDecorationFilled(context, fillColor: context.scaffoldBackgroundColor, label: language.topicTags),
                          onFieldSubmitted: (text) {
                            //addReview();
                          },
                        ),
                        Text(language.notePleaseAddComma, style: secondaryTextStyle()),
                        16.height,
                        Row(
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(borderRadius: radius(2)),
                              activeColor: context.primaryColor,
                              value: doNotify,
                              onChanged: (val) {
                                doNotify = !doNotify;
                                setState(() {});
                              },
                            ),
                            Text(language.notifyMeText, style: secondaryTextStyle()).onTap(() {
                              doNotify = !doNotify;
                              setState(() {});
                            }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                          ],
                        ),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            appButton(
                              color: context.cardColor,
                              shapeBorder: RoundedRectangleBorder(
                                borderRadius: radius(defaultAppButtonRadius),
                                side: BorderSide(color: context.dividerColor),
                              ),
                              width: context.width() / 2 - 20,
                              context: context,
                              text: language.cancel.capitalizeFirstLetter(),
                              textStyle: boldTextStyle(),
                              onTap: () {
                                finish(context);
                              },
                            ),
                            appButton(
                              width: context.width() / 2 - 20,
                              context: context,
                              text: language.submit.capitalizeFirstLetter(),
                              onTap: () {
                                ifNotTester(() {
                                  if (!appStore.isLoading) {
                                    if (widget.reply != null) {
                                      editReply();
                                    } else {
                                      reply();
                                    }
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        50.height,
                      ],
                    ),
                  ),
                ),
              ).expand(flex: 1),
            ],
          ),
          Observer(builder: (_) => LoadingWidget().center().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
