import 'package:flutter/material.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/forums/forum_model.dart';
import 'package:socialv/models/forums/topic_model.dart';
import 'package:socialv/screens/forums/components/forums_card_component.dart';
import 'package:socialv/screens/forums/components/topic_card_component.dart';
import 'package:socialv/screens/forums/screens/forum_detail_screen.dart';
import 'package:socialv/screens/forums/screens/topic_detail_screen.dart';
import 'package:socialv/utils/constants.dart';

// ignore: must_be_immutable
class ForumDetailComponent extends StatefulWidget {
  final bool showOptions;
  int selectedIndex;
  final String type;
  final VoidCallback? callback;
  final List<TopicModel> topicList;
  final List<ForumModel> forumList;

  ForumDetailComponent({required this.showOptions, required this.selectedIndex, required this.type, this.callback, required this.topicList, required this.forumList});

  @override
  State<ForumDetailComponent> createState() => _ForumDetailComponentState();
}

class _ForumDetailComponentState extends State<ForumDetailComponent> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: widget.showOptions ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.start,
          children: [
            Text(
              language.topics,
              style: boldTextStyle(size: widget.showOptions ? 16 : 18, color: widget.showOptions && widget.selectedIndex == 0 ? context.primaryColor : context.iconColor),
            ).paddingSymmetric(horizontal: 16).visible(widget.topicList.validate().isNotEmpty).onTap(() {
              widget.selectedIndex = 0;
              setState(() {});
            }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
            Text(
              language.forums,
              style: boldTextStyle(size: widget.showOptions ? 16 : 18, color: widget.showOptions && widget.selectedIndex == 1 ? context.primaryColor : context.iconColor),
            ).paddingSymmetric(horizontal: 16).visible(widget.forumList.validate().isNotEmpty).onTap(() {
              widget.selectedIndex = 1;
              setState(() {});
            }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
          ],
        ),
        Divider().visible(widget.showOptions),
        if (widget.topicList.validate().isEmpty && widget.forumList.validate().isEmpty)
          NoDataWidget(
            imageWidget: NoDataLottieWidget(),
            title: widget.type == ForumTypes.category ? language.noForumsFound : language.noTopicsFound,
          ),
        ListView.builder(
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.topicList.validate().length,
          itemBuilder: (ctx, index) {
            return InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                TopicDetailScreen(topicId: widget.topicList.validate()[index].id.validate()).launch(context).then((value) {
                  if (value ?? false) {
                    widget.callback?.call();
                  }
                });
              },
              child: TopicCardComponent(topic: widget.topicList.validate()[index], isFavTab: false, showForums: false),
            );
          },
        ).visible(widget.topicList.validate().isNotEmpty && widget.selectedIndex == 0),
        ListView.builder(
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.forumList.validate().length,
          itemBuilder: (ctx, index) {
            return InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                ForumDetailScreen(
                  type: widget.forumList[index].type.validate(),
                  forumId: widget.forumList[index].id.validate(),
                ).launch(context).then((value) {
                  widget.callback?.call();
                });
              },
              child: ForumsCardComponent(
                title: widget.forumList.validate()[index].title,
                topicCount: widget.forumList.validate()[index].topicCount,
                postCount: widget.forumList.validate()[index].postCount,
                freshness: widget.forumList.validate()[index].freshness,
                description: widget.forumList.validate()[index].description,
              ),
            );
          },
        ).visible(widget.forumList.validate().isNotEmpty && widget.selectedIndex == 1),
      ],
    );
  }
}
