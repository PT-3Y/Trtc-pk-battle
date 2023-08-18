import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/posts/get_post_likes_model.dart';
import 'package:socialv/screens/post/screens/post_likes_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class PostLikesComponent extends StatelessWidget {
  final List<GetPostLikesModel> postLikeList;
  final int postLikeCount;
  final int postId;

  PostLikesComponent({required this.postLikeList, required this.postLikeCount, required this.postId});

  @override
  Widget build(BuildContext context) {
    if (postLikeList.isNotEmpty) {
      return Row(
        children: [
          Stack(
            children: postLikeList.validate().take(3).map(
              (e) {
                return Container(
                  width: 32,
                  height: 32,
                  margin: EdgeInsets.only(left: 18 * postLikeList.validate().indexOf(e).toDouble()),
                  child: cachedImage(
                    postLikeList.validate()[postLikeList.validate().indexOf(e)].userAvatar.validate(),
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(100),
                );
              },
            ).toList(),
          ),
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: language.likedBy,
              style: secondaryTextStyle(size: 12, fontFamily: fontFamily),
              children: <TextSpan>[
                TextSpan(
                  text: postLikeList.first.userId.validate() == appStore.loginUserId ? ' ${language.you} ' : ' ${postLikeList.first.userName.validate()}',
                  style: boldTextStyle(size: 12, fontFamily: fontFamily),
                ),
                if (postLikeList.length > 1) TextSpan(text: ' ${language.and} ', style: secondaryTextStyle(size: 12, fontFamily: fontFamily)),
                if (postLikeList.length > 1) TextSpan(text: '${postLikeCount - 1} ${language.others}', style: boldTextStyle(size: 12, fontFamily: fontFamily)),
              ],
            ),
          ).paddingAll(8).onTap(() {
            PostLikesScreen(postId: postId).launch(context);
          }, highlightColor: Colors.transparent, splashColor: Colors.transparent).expand(),
        ],
      ).paddingOnly(left: 8, right: 8, bottom: 8);
    } else {
      return Offstage();
    }
  }
}
