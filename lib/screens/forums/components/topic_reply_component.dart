import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/forums/common_models.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/forums/components/write_topic_reply_component.dart';
import 'package:socialv/screens/forums/screens/topic_reply_screen.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';
import 'package:socialv/utils/html_widget.dart';

import '../../../utils/app_constants.dart';

class TopicReplyComponent extends StatefulWidget {
  final TopicReplyModel reply;
  final VoidCallback? callback;
  final bool showReply;
  final bool isParent;
  final bool isFromReplyScreen;
  final Function(String)? newReply;
  final int? topicId;

  const TopicReplyComponent({required this.reply, this.callback, this.showReply = true, required this.isParent, this.isFromReplyScreen = false, this.newReply, this.topicId});

  @override
  State<TopicReplyComponent> createState() => _TopicReplyComponentState();
}

class _TopicReplyComponentState extends State<TopicReplyComponent> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.reply.createdAtDate.validate(), style: secondaryTextStyle()),
              Text('#${widget.reply.id.validate().toString()}', style: secondaryTextStyle(color: context.primaryColor)),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ).visible(widget.reply.createdAtDate!.isNotEmpty && widget.reply.id != null),
          10.height,
          Row(
            children: [
              cachedImage(widget.reply.profileImage.validate(), height: 30, width: 30, fit: BoxFit.cover).cornerRadiusWithClipRRect(15),
              10.width,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: widget.reply.createdByName.validate().capitalizeFirstLetter(), style: primaryTextStyle(fontFamily: fontFamily)),
                    if (widget.reply.isUserVerified.validate()) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ).expand(),
              6.width,
              Container(
                decoration: BoxDecoration(color: context.primaryColor.withAlpha(40), borderRadius: radius()),
                child: Text(widget.reply.key.validate(), style: secondaryTextStyle(color: context.primaryColor, size: 12)),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ],
          ).onTap(() {
            MemberProfileScreen(memberId: widget.reply.createdById.validate().toInt()).launch(context);
          }, highlightColor: Colors.transparent, splashColor: Colors.transparent),
          10.height,
          HtmlWidget(
            postContent: widget.reply.content.validate(),
            fontSize: 14,
            color: context.iconColor,
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                child: TextIcon(
                  prefix: Image.asset(
                    ic_edit,
                    height: 16,
                    width: 16,
                    fit: BoxFit.cover,
                    color: context.primaryColor,
                  ),
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      elevation: 0,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return WriteTopicReplyComponent(
                          reply: widget.reply,
                          topicName: widget.reply.topicName.validate(),
                          topicId: widget.topicId.validate(),
                          replyId: widget.reply.id.validate(),
                          newReply: (x) {
                            widget.newReply?.call(x);
                          },

                        );
                      },
                    ).then((value) {
                      if (value ?? false) {
                        widget.callback?.call();
                      }
                    });
                  },
                ),
                alignment: Alignment.bottomRight,
              ).visible(widget.reply.createdById.toString() == appStore.loginUserId),
              Align(
                child: TextIcon(
                  prefix: Image.asset(
                    ic_reply,
                    height: 16,
                    width: 16,
                    fit: BoxFit.cover,
                    color: context.primaryColor,
                  ),
                  onTap: () async {
                    if (widget.isParent) {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return WriteTopicReplyComponent(
                            topicName: widget.reply.topicName.validate(),
                            topicId: widget.topicId.validate(),
                            replyId: widget.reply.id.validate(),
                            newReply: (x) {
                              widget.newReply?.call(x);
                            },
                          );
                        },
                      ).then((value) {
                        if (value ?? false) {
                          widget.callback?.call();
                        }
                      });
                    } else {
                      if (widget.isFromReplyScreen.validate()) finish(context);

                      TopicReplyScreen(reply: widget.reply, topicId: widget.topicId).launch(context);
                    }
                  },
                ),
                alignment: Alignment.bottomRight,
              ).visible(widget.showReply)
            ],
          ),
        ],
      ),
    );
  }
}
