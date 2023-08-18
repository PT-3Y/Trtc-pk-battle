import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/messages/message_users.dart';
import 'package:socialv/models/messages/messages_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/messages/screens/message_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

class ReactionBottomSheet extends StatefulWidget {
  final List<MessagesUsers> users;
  final MessageMeta? meta;

  const ReactionBottomSheet({required this.users, this.meta});

  @override
  State<ReactionBottomSheet> createState() => _ReactionBottomSheetState();
}

class _ReactionBottomSheetState extends State<ReactionBottomSheet> {
  final parser = EmojiParser();

  String getReactionCount() {
    int count = 0;

    if (widget.meta != null && widget.meta!.reactions != null) {
      widget.meta!.reactions.validate().forEach((element) {
        count = count + element.users.validate().length;
      });
    }

    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.height,
        if (widget.meta != null && widget.meta!.reactions != null)
          Wrap(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(language.all, style: primaryTextStyle()),
                  4.width,
                  Text('(${getReactionCount()})', style: primaryTextStyle()),
                ],
              ),
              6.width,
              ...widget.meta!.reactions.validate().map((a) {
                int iconIndex = emojiList.indexWhere((e) => e.skins.validate().first.unified.validate() == a.reaction.validate());
                String x = emojiList[iconIndex].skins.validate().first.native.validate();

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(parser.emojify(x), style: TextStyle(fontSize: 16)),
                    4.width,
                    Text(a.users.validate().length.toString(), style: primaryTextStyle()),
                  ],
                ).paddingSymmetric(horizontal: 8);
              }).toList(),
            ],
          ),
        Divider(),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.meta!.reactions!.map((e) {
            int iconIndex = emojiList.indexWhere((x) => x.skins.validate().first.unified.validate() == e.reaction.validate());
            String reaction = emojiList[iconIndex].skins.validate().first.native.validate();

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: e.users.validate().map((element) {
                MessagesUsers user = widget.users.firstWhere((user) => user.userId == element.validate());

                return Row(
                  children: [
                    cachedImage(
                      user.avatar.validate(),
                      height: 40,
                      width: 40,
                      fit: BoxFit.fill,
                    ).cornerRadiusWithClipRRect(20),
                    16.width,
                    Text(user.name.validate(), style: primaryTextStyle()).expand(),
                    Text(parser.emojify(reaction), style: TextStyle(fontSize: 20)),
                  ],
                ).paddingSymmetric(vertical: 4);
              }).toList(),
            );
          }).toList(),
        ),
      ],
    ).paddingAll(16);
  }
}
