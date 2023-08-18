import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class SearchCardComponent extends StatefulWidget {
  final int id;
  final String name;
  final String image;
  final String? subTitle;
  final bool? isMember;
  final bool isRecent;
  final bool isVerified;
  final VoidCallback? callback;
  final bool isActive;

  SearchCardComponent({
    required this.name,
    required this.image,
    this.subTitle,
    required this.id,
    this.isMember,
    this.callback,
    required this.isRecent,
    this.isVerified = false,
    this.isActive = false,
  });

  @override
  State<SearchCardComponent> createState() => _SearchCardComponentState();
}

class _SearchCardComponentState extends State<SearchCardComponent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            cachedImage(widget.image, height: 56, width: 56, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
            20.width,
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.name,
                      style: boldTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).flexible(flex: 1),
                    if (widget.isMember.validate() && widget.isVerified) Image.asset(ic_tick_filled, width: 18, height: 18, color: blueTickColor).paddingSymmetric(horizontal: 4),
                  ],
                ),
                6.height,
                Text(widget.subTitle.validate(), style: secondaryTextStyle(), overflow: TextOverflow.ellipsis, maxLines: 1),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ).expand(),
          ],
        ).expand(),
        IconButton(
          onPressed: () async {
            if (widget.isMember.validate()) {
              appStore.recentMemberSearchList.removeWhere((element) => element.id == widget.id);
              await setValue(SharePreferencesKey.RECENT_SEARCH_MEMBERS, jsonEncode(appStore.recentMemberSearchList));
            } else {
              appStore.recentGroupsSearchList.removeWhere((element) => element.id == widget.id);
              await setValue(SharePreferencesKey.RECENT_SEARCH_GROUPS, jsonEncode(appStore.recentGroupsSearchList));
            }
            widget.callback!.call();
          },
          icon: Image.asset(
            ic_close_square,
            height: 20,
            width: 20,
            fit: BoxFit.cover,
            color: context.iconColor,
          ),
        ).visible(widget.isRecent),
      ],
    );
  }
}
