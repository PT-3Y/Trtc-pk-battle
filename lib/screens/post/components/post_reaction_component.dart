import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/reactions/reactions_count_model.dart';

import '../../../main.dart';
import '../../../utils/cached_network_image.dart';
import '../../../utils/constants.dart';
import '../screens/reaction_screen.dart';

class ThreeReactionComponent extends StatefulWidget {
  final int postReactionCount;
  final List<Reactions> postReactionList;
  final int id;
  final bool isComments;

  /// id = comment Id if comment reaction or postId
  const ThreeReactionComponent({required this.postReactionCount, required this.postReactionList, required this.id, required this.isComments});

  @override
  State<ThreeReactionComponent> createState() => _ThreeReactionComponentState();
}

class _ThreeReactionComponentState extends State<ThreeReactionComponent> {
  @override
  Widget build(BuildContext context) {
    return (widget.postReactionList.isNotEmpty)
        ? Row(
            children: [
              Stack(
                children: widget.postReactionList.take(3).map(
                  (reaction) {
                    return Container(
                      width: 24,
                      height: 24,
                      margin: EdgeInsets.only(left: 14 * widget.postReactionList.indexOf(reaction).toDouble()),
                      child: cachedImage(reaction.icon.validate(), fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
                    );
                  },
                ).toList(),
              ),
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: language.reactedBy,
                  style: secondaryTextStyle(size: 12, fontFamily: fontFamily),
                  children: <TextSpan>[
                    TextSpan(
                      text: widget.postReactionList.first.user!.displayName.validate() == appStore.loginUserId ? ' ${language.you} ' : ' ${widget.postReactionList.first.user!.displayName}',
                      style: boldTextStyle(size: 12, fontFamily: fontFamily),
                    ),
                    if (widget.postReactionList.length > 1) TextSpan(text: ' ${language.and} ', style: secondaryTextStyle(size: 12, fontFamily: fontFamily)),
                    if (widget.postReactionList.length > 1) TextSpan(text: '${widget.postReactionCount - 1} ${language.others}', style: boldTextStyle(size: 12, fontFamily: fontFamily)),
                  ],
                ),
              ).paddingAll(8).onTap(() {
                ReactionScreen(
                  postId: widget.id.validate(),
                  isCommentScreen: widget.isComments,
                ).launch(context);
              }, highlightColor: Colors.transparent, splashColor: Colors.transparent).expand(),
            ],
          )
        : Offstage();
  }
}
