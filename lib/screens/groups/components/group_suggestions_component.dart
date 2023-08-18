import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/dashboard_api_response.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/groups/screens/group_detail_screen.dart';
import 'package:socialv/screens/home/screens/group_list_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class GroupSuggestionsComponent extends StatefulWidget {
  const GroupSuggestionsComponent({Key? key}) : super(key: key);

  @override
  State<GroupSuggestionsComponent> createState() => _GroupSuggestionsComponentState();
}

class _GroupSuggestionsComponentState extends State<GroupSuggestionsComponent> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> getDetails() async {
    await getDashboardDetails().then((value) {
      appStore.setNotificationCount(value.notificationCount.validate());
      appStore.setVerificationStatus(value.verificationStatus.validate());
      visibilities = value.visibilities.validate();
      accountPrivacyVisibility = value.accountPrivacyVisibility.validate();
      reportTypes = value.reportTypes.validate();

      appStore.setShowStoryHighlight(value.isHighlightStoryEnable.validate());
      appStore.suggestedUserList = value.suggestedUser.validate();
    }).catchError(onError);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (appStore.suggestedGroupsList.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.suggestedGroups, style: boldTextStyle()),
                  if (appStore.suggestedUserList.length == 5)
                    TextButton(
                      onPressed: () {
                        GroupListScreen(isSuggested: true).launch(context);
                      },
                      child: Text(
                        language.viewAll,
                        style: primaryTextStyle(color: context.primaryColor),
                      ),
                    ),
                ],
              ).paddingSymmetric(horizontal: 8),
              16.height,
              if (appStore.suggestedGroupsList.length != 5) 16.height,
              HorizontalList(
                crossAxisAlignment: WrapCrossAlignment.start,
                wrapAlignment: WrapAlignment.start,
                padding: EdgeInsets.symmetric(horizontal: 8),
                spacing: 12,
                itemCount: appStore.suggestedGroupsList.length,
                itemBuilder: (ctx, index) {
                  SuggestedGroup group = appStore.suggestedGroupsList[index];

                  return InkWell(
                    onTap: () {
                      GroupDetailScreen(groupId: group.id.validate()).launch(context);
                    },
                    radius: commonRadius,
                    child: Container(
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                      padding: EdgeInsets.all(8),
                      width: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [
                              10.height,
                              cachedImage(group.groupAvtarImage.validate(), height: 70, width: 70).cornerRadiusWithClipRRect(50),
                              16.height,
                              Marquee(
                                child: Text(group.name.validate(), style: primaryTextStyle()),
                              ),
                              8.height,
                            ],
                          ).paddingSymmetric(horizontal: 8),
                          Positioned(
                            child: InkWell(
                              onTap: () {
                                ifNotTester(() async {
                                  appStore.suggestedGroupsList.removeAt(index);
                                  setState(() {});
                                  await removeSuggestedGroup(groupId: group.id.validate()).then((value) {
                                    getDetails();
                                  }).catchError(onError);
                                });
                              },
                              child: Icon(Icons.cancel_outlined, color: context.primaryColor),
                            ),
                            right: 0,
                            top: 0,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ).paddingSymmetric(vertical: 8);
        } else {
          return Offstage();
        }
      },
    );
  }
}
