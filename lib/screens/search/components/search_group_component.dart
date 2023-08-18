import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/groups/group_response.dart';
import 'package:socialv/screens/groups/components/group_suggestions_component.dart';
import 'package:socialv/screens/groups/screens/group_detail_screen.dart';
import 'package:socialv/screens/search/components/search_card_component.dart';
import 'package:socialv/utils/app_constants.dart';

class SearchGroupComponent extends StatelessWidget {
  final bool showRecent;
  final List<GroupResponse> groupList;
  final VoidCallback? callback;

  const SearchGroupComponent({required this.showRecent, this.callback, required this.groupList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showRecent)
          GroupSuggestionsComponent(),
        if (groupList.isNotEmpty && showRecent) Text(language.recent, style: boldTextStyle()).paddingOnly(left: 16, right: 16, top: 8),
        if (groupList.isNotEmpty)
          AnimatedListView(
            slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 60),
            itemCount: groupList.length,
            itemBuilder: (context, index) {
              GroupResponse group = groupList[index];
              return SearchCardComponent(
                isRecent: showRecent,
                id: group.id.validate(),
                isMember: false,
                name: group.name.validate(),
                image: group.avatarUrls != null ? group.avatarUrls!.full.validate() : AppImages.defaultAvatarUrl,
                subTitle: parseHtmlString(group.description!.rendered.validate()),
                callback: () {
                  callback?.call();
                },
              ).paddingSymmetric(vertical: 8).onTap(() async {
                if (!appStore.recentGroupsSearchList.any((element) => element.id.validate() == groupList[index].id)) {
                  appStore.recentGroupsSearchList.add(groupList[index]);
                  await setValue(SharePreferencesKey.RECENT_SEARCH_GROUPS, jsonEncode(appStore.recentGroupsSearchList));
                }
                hideKeyboard(context);
                GroupDetailScreen(groupId: groupList[index].id.validate()).launch(context);
              }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
            },
          ),

      ],
    );
  }
}
