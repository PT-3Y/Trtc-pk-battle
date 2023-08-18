import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../models/messages/message_users.dart';
import '../../../../models/messages/threads_model.dart';
import '../../../../utils/cached_network_image.dart';
import '../../../../utils/constants.dart';

// ignore: must_be_immutable
class ChatScreenProfileImageComponent extends StatelessWidget {
  final Threads? thread;
  final MessagesUsers? user;
  List<MessagesUsers> users = [];
  final double? imageSizeWhenParticipant;
  final double? imageSize;
  final double? imageSpacing;

  ChatScreenProfileImageComponent({Key? key, this.thread, this.user, required this.users, this.imageSizeWhenParticipant, this.imageSize, this.imageSpacing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (thread!.participantsCount.validate() > 2 && thread!.type != ThreadType.group)
        ? Stack(
            children: users.take(2).map(
              (e) {
                return Container(
                  width: imageSizeWhenParticipant,
                  height: imageSizeWhenParticipant,
                  margin: EdgeInsets.only(top: imageSpacing.validate() * users.indexOf(e).toDouble(), left: users.indexOf(e) == 0 ? 8 : 0),
                  child: cachedImage(e.avatar, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
                );
              },
            ).toList(),
          )
        : cachedImage(
            thread!.type == ThreadType.group ? thread!.image : user!.avatar.validate(),
            height: imageSize,
            width: imageSize,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRect(25);
  }
}
