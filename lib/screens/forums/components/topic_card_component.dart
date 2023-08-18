import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/forums/topic_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';
import '../screens/forum_detail_screen.dart';

class TopicCardComponent extends StatefulWidget {
  final TopicModel topic;
  final bool isFavTab;
  final VoidCallback? callback;
  final bool showForums;

  TopicCardComponent({required this.topic, required this.isFavTab, this.callback, this.showForums = true});

  @override
  State<TopicCardComponent> createState() => _TopicCardComponentState();
}

class _TopicCardComponentState extends State<TopicCardComponent> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Row(
                children: [
                  Image.asset(ic_two_user, height: 16, width: 16, fit: BoxFit.cover),
                  8.width,
                  Text(widget.topic.createdByName.validate().capitalizeFirstLetter(), style: secondaryTextStyle()).onTap(() {
                    MemberProfileScreen(memberId: widget.topic.createdById.validate().toInt()).launch(context);
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  20.width,
                  Image.asset(ic_folder, height: 16, width: 16, fit: BoxFit.cover).visible(widget.showForums),
                  8.width.visible(widget.showForums),
                  Text(widget.topic.forumName.validate(), style: secondaryTextStyle()).visible(widget.showForums).onTap(() {
                    ForumDetailScreen(
                      forumId: widget.topic.forumId.validate(),
                      type: ForumTypes.forum,
                    ).launch(context);
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                ],
              ),
              if (widget.isFavTab)
                Image.asset(ic_heart_filled, height: 16, width: 16, fit: BoxFit.fill).onTap(() {
                  ifNotTester(() {
                    widget.callback!.call();
                    favoriteTopic(topicId: widget.topic.id.validate()).then((value) {
                      log('Success');
                    }).catchError(onError);
                  });
                }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
            ],
          ),
          12.height,
          Text(widget.topic.title.validate(), style: boldTextStyle()),
          Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(language.voices, style: boldTextStyle(size: 14)),
                  4.height,
                  Text(widget.topic.voicesCount.validate().toString(), style: secondaryTextStyle()),
                ],
              ),
              Column(
                children: [
                  Text(language.posts, style: boldTextStyle(size: 14)),
                  4.height,
                  Text(widget.topic.postCount.validate().toString(), style: secondaryTextStyle()),
                ],
              ),
              Column(
                children: [
                  Text(language.freshness, style: boldTextStyle(size: 14)),
                  4.height,
                  Stack(
                    children: widget.topic.freshness.validate().take(3).map((e) {
                      return Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(left: 10 * widget.topic.freshness.validate().indexOf(e).toDouble()),
                        child: cachedImage(
                          widget.topic.freshness.validate()[widget.topic.freshness.validate().indexOf(e)].userProfileImage.validate(),
                          fit: BoxFit.cover,
                        ).cornerRadiusWithClipRRect(100),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
