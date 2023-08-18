import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/reactions/reactions_count_model.dart';
import '../../../utils/cached_network_image.dart';
import '../../profile/screens/member_profile_screen.dart';
import '../../../utils/app_constants.dart';

class ReactionListComponent extends StatefulWidget {
  final Reactions reaction;
  final int index;

  ReactionListComponent({required this.reaction, required this.index});

  @override
  State<ReactionListComponent> createState() => _ReactionListComponentState();
}

class _ReactionListComponentState extends State<ReactionListComponent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        cachedImage(
          widget.reaction.user!.avatar.validate(),
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ).cornerRadiusWithClipRRect(100),
        20.width,
        Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: widget.reaction.user!.displayName.validate() + ' ', style: boldTextStyle(size: 14, fontFamily: fontFamily)),
                  if (widget.reaction.user!.isVerified.validate()) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
            Text(widget.reaction.user!.userName.validate(), style: secondaryTextStyle(size: 12, fontFamily: fontFamily))
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ).expand(),
        cachedImage(widget.reaction.icon.validate(), height: 26, width: 26).withTooltip(msg: widget.reaction.reaction.toString())
      ],
    ).onTap(() async {
      MemberProfileScreen(memberId: widget.reaction.user!.id.validate().toInt()).launch(context);
    }, splashColor: Colors.transparent, highlightColor: Colors.transparent).paddingSymmetric(vertical: 8);
  }
}
