import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/notifications/notification_model.dart';
import 'package:socialv/screens/forums/screens/topic_detail_screen.dart';
import 'package:socialv/screens/groups/screens/group_detail_screen.dart';
import 'package:socialv/screens/notification/components/member_verified_notification.dart';
import 'package:socialv/screens/notification/components/reaction_notification_component.dart';
import 'package:socialv/screens/notification/components/request_notification_component.dart';
import 'package:socialv/screens/notification/components/comment_reply_notification_component.dart';
import 'package:socialv/screens/notification/components/group_invite_notification_component.dart';
import 'package:socialv/screens/notification/components/group_membership_request_notification.dart';
import 'package:socialv/screens/notification/components/membership_request_rejected_component.dart';
import 'package:socialv/screens/notification/components/mention_notification_component.dart';
import 'package:socialv/screens/notification/components/promoted_to_admin_notification.dart';
import 'package:socialv/screens/notification/components/request_accepted_notification_component.dart';
import 'package:socialv/screens/notification/components/topic_reply_notification_component.dart';
import 'package:socialv/screens/notification/components/share_post_notification_component.dart';
import 'package:socialv/screens/post/screens/comment_screen.dart';
import 'package:socialv/screens/post/screens/single_post_screen.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notificationModel;
  final VoidCallback callback;

  const NotificationWidget({required this.notificationModel, required this.callback});

  @override
  Widget build(BuildContext context) {
    if (notificationModel.action == NotificationAction.friendshipAccepted || notificationModel.action == NotificationAction.membershipRequestAccepted) {
      return RequestAcceptedNotificationComponent(
        element: notificationModel,
        callback: () {
          callback.call();
        },
      ).onTap(() async {
        if (notificationModel.action == NotificationAction.friendshipAccepted) {
          MemberProfileScreen(memberId: notificationModel.itemId.validate()).launch(context);
        } else {
          GroupDetailScreen(groupId: notificationModel.itemId.validate()).launch(context);
        }
      });
    } else if (notificationModel.action == NotificationAction.membershipRequestRejected) {
      return MembershipRequestRejectedComponent(
        element: notificationModel,
        callback: () {
          callback.call();
        },
      ).onTap(() async {
        GroupDetailScreen(groupId: notificationModel.itemId.validate()).launch(context);
      });
    } else if (notificationModel.action == NotificationAction.commentReply ||
        notificationModel.action == NotificationAction.updateReply ||
        notificationModel.action == NotificationAction.actionActivityLiked) {
      return CommentReplyNotificationComponent(
        element: notificationModel,
        callback: () {
          callback.call();
        },
      ).onTap(() async {
        SinglePostScreen(postId: notificationModel.itemId.validate()).launch(context);
      });
    } else if (notificationModel.action == NotificationAction.newAtMention) {
      return MentionNotificationComponent(
        element: notificationModel,
        callback: () {
          callback.call();
        },
      ).onTap(() async {
        SinglePostScreen(postId: notificationModel.itemId.validate()).launch(context);
      });
    } else if (notificationModel.action == NotificationAction.friendshipRequest) {
      return RequestNotificationComponent(
          element: notificationModel,
          callback: () {
            callback.call();
          }).onTap(() async {
        MemberProfileScreen(memberId: notificationModel.itemId.validate()).launch(context).then((value) {
          if (value ?? false) callback.call();
        });
      });
    } else if (notificationModel.action == NotificationAction.newMembershipRequest) {
      return GroupMembershipRequestNotification(
        element: notificationModel,
        callback: () {
          callback.call();
        },
      ).onTap(() async {
        await GroupDetailScreen(groupId: notificationModel.itemId.validate()).launch(context);
      });
    } else if (notificationModel.action == NotificationAction.groupInvite) {
      return GroupInviteNotificationComponent(
        element: notificationModel,
        callback: () {
          callback.call();
        },
      ).onTap(() async {
        await GroupDetailScreen(groupId: notificationModel.itemId.validate()).launch(context).then((value) {
          if (value ?? false) callback.call();
        });
      });
    } else if (notificationModel.action == NotificationAction.memberPromotedToAdmin) {
      return PromotedToAdminNotification(
        element: notificationModel,
        callback: () {
          callback.call();
        },
      ).onTap(() async {
        await GroupDetailScreen(groupId: notificationModel.itemId.validate()).launch(context);
      });
    } else if (notificationModel.component == Component.verifiedMember) {
      return MemberVerifiedNotification(
        element: notificationModel,
        callback: () {
          callback.call();
        },
      );
    } else if (notificationModel.component == Component.forums) {
      return TopicReplyNotificationComponent(
        element: notificationModel,
        callback: () {
          callback.call();
        },
      ).onTap(() {
        TopicDetailScreen(topicId: notificationModel.itemId.validate()).launch(context);
      });
    } else if (notificationModel.action == NotificationAction.socialVSharePost) {
      return SharePostNotificationComponent(
        element: notificationModel,
        callback: () {
          callback.call();
        },
      ).onTap(() async {
        SinglePostScreen(postId: notificationModel.itemId.validate()).launch(context);
      });
    } else if (notificationModel.action == NotificationAction.socialVSharePost) {
      return SharePostNotificationComponent(
        element: notificationModel,
        callback: () {
          callback.call();
        },
      ).onTap(() async {
        SinglePostScreen(postId: notificationModel.itemId.validate()).launch(context);
      });
    } else if (notificationModel.action == NotificationAction.actionActivityReacted || notificationModel.action == NotificationAction.actionCommentActivityReacted) {
      return ReactionNotificationComponent(
        element: notificationModel,
        callback: () {
          callback.call();
        },
      ).onTap(() async {
        if (notificationModel.action == NotificationAction.actionActivityReacted) {
          SinglePostScreen(postId: notificationModel.itemId.validate()).launch(context);
        } else {
          CommentScreen(postId: notificationModel.itemId.validate()).launch(context);
        }
      });
    } else {
      return Offstage();
    }
  }
}
