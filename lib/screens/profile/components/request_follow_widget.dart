import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/blockReport/components/unblock_member_dialog.dart';
import 'package:socialv/utils/app_constants.dart';

class RequestFollowWidget extends StatefulWidget {
  final int memberId;
  final String friendshipStatus;
  final VoidCallback? callback;
  final bool isBlockedByMe;
  final String userName;
  final String userMentionName;

  const RequestFollowWidget({required this.memberId, required this.friendshipStatus, this.callback, required this.isBlockedByMe, required this.userName, required this.userMentionName});

  @override
  State<RequestFollowWidget> createState() => _RequestFollowWidgetState();
}

class _RequestFollowWidgetState extends State<RequestFollowWidget> {
  late String friendshipStatus;

  @override
  void initState() {
    super.initState();
    friendshipStatus = widget.friendshipStatus;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBlockedByMe) {
      return AppButton(
        shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
        text: language.unblock,
        textStyle: boldTextStyle(color: Colors.white),
        onTap: () async {
          if (!appStore.isLoading) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return UnblockMemberDialog(
                  name: widget.userName.validate(),
                  mentionName: widget.userMentionName.validate(),
                  id: widget.memberId.validate().toInt(),
                  callback: () {
                    friendshipStatus = Friendship.notFriends;
                    appStore.setLoading(true);
                    widget.callback?.call();
                  },
                );
              },
            );
          }
        },
        color: context.primaryColor,
        elevation: 0,
      );
    } else if (friendshipStatus == Friendship.notFriends && appStore.displayFriendRequestBtn == 1) {
      return AppButton(
        shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
        text: Friendship.follow,
        textStyle: boldTextStyle(color: Colors.white),
        onTap: () async {
          ifNotTester(() async {
            friendshipStatus = Friendship.pending;
            setState(() {});

            Map request = {"initiator_id": appStore.loginUserId, "friend_id": widget.memberId.toString().validate()};
            await requestNewFriend(request).then((value) async {
              widget.callback?.call();
            }).catchError((e) {
              friendshipStatus = Friendship.notFriends;

              toast(e.toString(), print: true);
            });
          });
        },
        color: context.primaryColor,
        elevation: 0,
      );
    } else if (friendshipStatus == Friendship.pending) {
      return AppButton(
        shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
        text: Friendship.requested,
        textStyle: boldTextStyle(color: Colors.white),
        onTap: () async {
          ifNotTester(() async {
            friendshipStatus = Friendship.notFriends;
            setState(() {});

            await removeExistingFriendConnection(friendId: widget.memberId.toString(), passRequest: true).then((value) {
              widget.callback?.call();
            }).catchError((e) {
              friendshipStatus = Friendship.pending;

              toast(e.toString(), print: true);
            });
          });
        },
        elevation: 0,
        color: context.primaryColor,
      );
    } else if (friendshipStatus == Friendship.awaitingResponse) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppButton(
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
            text: language.confirm,
            textStyle: secondaryTextStyle(color: Colors.white, size: 14),
            onTap: () async {
              ifNotTester(() async {
                friendshipStatus = Friendship.isFriend;
                setState(() {});

                await acceptFriendRequest(id: widget.memberId.validate()).then((value) {
                  widget.callback?.call();
                }).catchError((e) {
                  friendshipStatus = Friendship.awaitingResponse;
                  toast(e.toString(), print: true);
                });
              });
            },
            elevation: 0,
            color: context.primaryColor,
            height: 32,
          ),
          16.width,
          AppButton(
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
            text: language.delete,
            textStyle: secondaryTextStyle(color: context.primaryColor, size: 14),
            onTap: () async {
              ifNotTester(() async {
                friendshipStatus = Friendship.notFriends;
                setState(() {});

                await removeExistingFriendConnection(friendId: widget.memberId.toString().validate(), passRequest: false).then((value) {
                  widget.callback?.call();
                }).catchError((e) {
                  friendshipStatus = Friendship.awaitingResponse;

                  toast(e.toString(), print: true);
                });
              });
            },
            elevation: 0,
            color: context.cardColor,
            height: 32,
          ),
        ],
      );
    } else if (friendshipStatus == Friendship.isFriend) {
      return AppButton(
        shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
        text: Friendship.following,
        textStyle: boldTextStyle(color: context.primaryColor),
        onTap: () async {
          setState(() {});
          await Future.delayed(Duration.zero);
          showConfirmDialogCustom(
            context,
            onAccept: (c) async {
              ifNotTester(() async {
                friendshipStatus = Friendship.notFriends;
                appStore.setLoading(true);
                await removeExistingFriendConnection(friendId: widget.memberId.toString(), passRequest: true).then((value) {
                  widget.callback?.call();
                }).catchError((e) {
                  appStore.setLoading(false);
                  friendshipStatus = Friendship.isFriend;

                  toast(e.toString(), print: true);
                });
              });
            },
            dialogType: DialogType.CONFIRMATION,
            title: language.unfriendConfirmation,
            positiveText: language.remove,
          );
        },
        elevation: 0,
        color: context.cardColor,
      );
    } else {
      return Offstage();
    }
  }
}
