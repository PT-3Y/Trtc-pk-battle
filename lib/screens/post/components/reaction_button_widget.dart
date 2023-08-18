import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';
import 'package:socialv/utils/sv_reactions/sv_reaction.dart';
import 'package:socialv/utils/sv_reactions/sv_reation_button.dart';
import '../../../models/reactions/reactions_count_model.dart';
import '../../../utils/app_constants.dart';

// ignore: must_be_immutable
class ReactionButton extends StatefulWidget {
  bool isComments;
  final Reactions? currentUserReaction;
  final Function(int)? onReacted;
  final VoidCallback? onReactionRemoved;
  bool? isReacted;

  ReactionButton({this.isReacted, required this.isComments, this.currentUserReaction, this.onReacted, this.onReactionRemoved});

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  List<Reaction> reactionList = [];
  String reactionIcon = '';

  @override
  void initState() {
    super.initState();
    reactionList.addAll(
      reactions.map(
        (e) => Reaction(
          icon: cachedImage(e.imageUrl.toString(), height: 28, width: 28).cornerRadiusWithClipRRect(12),
          title: Text(e.name.toString()),
          id: e.id.toInt(),
        ),
      ),
    );
    if (widget.currentUserReaction == null) {
      widget.isReacted = false;
    } else {
      widget.isReacted = true;
      reactionIcon = widget.currentUserReaction!.icon.validate();
    }
  }

  double size() {
    return widget.isComments
        ? widget.isReacted.validate()
            ? 22
            : 18
        : widget.isReacted.validate()
            ? 22
            : 20;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return FlutterReactionButton(
          boxColor: context.cardColor,
          boxPadding: EdgeInsets.all(6),
          boxItemsSpacing: 4,
          boxPosition: Position.TOP,
          boxAlignment: Alignment.bottomLeft,
          splashColor: Colors.transparent,
          initialReaction: Reaction(
            icon: cachedImage(
              widget.isReacted.validate()
                  ? reactionIcon
                  : appStore.defaultReaction.defaultImageUrl.validate().isEmpty
                      ? ic_like
                      : appStore.defaultReaction.defaultImageUrl,
              width: size(),
              height: size(),
              color: context.iconColor,
              fit: BoxFit.cover,
            ),
          ),
          reactions: reactionList,
          callback: () {
            if (widget.isReacted.validate()) {
              widget.onReactionRemoved?.call();
            } else {
              reactionIcon = appStore.defaultReaction.imageUrl.validate();
              widget.onReacted?.call(appStore.defaultReaction.id.validate().toInt());
            }
            widget.isReacted = !widget.isReacted.validate();
            setState(() {});
          },
          onReactionChanged: (reaction, index) {
            widget.isReacted = true;
            reactionIcon = reactions[index].imageUrl.validate();
            widget.onReacted?.call(reactionList[index].id.validate());
            setState(() {});
          },
        );
      }
    );
  }
}
