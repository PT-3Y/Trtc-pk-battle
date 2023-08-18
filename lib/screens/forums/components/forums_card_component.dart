import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/forums/common_models.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class ForumsCardComponent extends StatelessWidget {
  final String? title;
  final String? description;
  final String? topicCount;
  final String? postCount;
  final List<FreshnessModel>? freshness;

  const ForumsCardComponent({this.title, this.description, this.topicCount, this.postCount, this.freshness});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      width: context.width(),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: context.cardColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.validate(), style: boldTextStyle(size: 18)),
          8.height,
          Text(description.validate(), style: secondaryTextStyle()),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  Text(language.topics, style: boldTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                  8.height,
                  Text(topicCount.validate(), style: primaryTextStyle()),
                ],
              ),
              Column(
                children: [
                  Text(language.posts, style: boldTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                  8.height,
                  Text(postCount.validate(), style: primaryTextStyle()),
                ],
              ),
              Column(
                children: [
                  Text(language.freshness, style: boldTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                  8.height,
                  Stack(
                    children: freshness.validate().take(3).map((e) {
                      return Container(
                        width: 28,
                        height: 28,
                        margin: EdgeInsets.only(left: 18 * freshness.validate().indexOf(e).toDouble()),
                        child: cachedImage(
                          freshness.validate()[freshness.validate().indexOf(e)].userProfileImage.validate(),
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
