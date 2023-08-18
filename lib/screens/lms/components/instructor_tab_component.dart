import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/lms_common_models/instrustor_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../models/common_models/avatar_urls.dart';

class InstructorTabComponent extends StatelessWidget {
  final Instructor? instructor;

  const InstructorTabComponent({this.instructor});

  @override
  Widget build(BuildContext context) {
    if (instructor != null) {
      return GestureDetector(
        onTap: () {
          MemberProfileScreen(memberId: instructor!.id.validate()).launch(context);
        },
        child: Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SnapHelperWidget(
                future: getMemberAvatarImage(memberId: instructor!.id.validate()),
                onSuccess: (List<AvatarUrls> snap) {
                  return cachedImage(
                    snap.first.full.validate(),
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(commonRadius);
                },
                loadingWidget: cachedImage(
                  '',
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRect(commonRadius),
                errorWidget: Offstage(),
              ),
              16.width,
              Column(
                children: [
                  Text(instructor!.name.validate(), style: boldTextStyle()),
                  8.height,
                  if (instructor!.social != null)
                    Wrap(
                      spacing: 4,
                      children: [
                        if (instructor!.social!.facebook.validate().isNotEmpty)
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              openWebPage(context, url: instructor!.social!.facebook.validate());
                            },
                            child: Image.asset(ic_facebook, height: 22, width: 22, fit: BoxFit.fill),
                          ),
                        if (instructor!.social!.twitter.validate().isNotEmpty)
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              openWebPage(context, url: instructor!.social!.twitter.validate());
                            },
                            child: Image.asset(ic_twitter, height: 22, width: 22, fit: BoxFit.fill),
                          ),
                        if (instructor!.social!.youtube.validate().isNotEmpty)
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              openWebPage(context, url: instructor!.social!.youtube.validate());
                            },
                            child: Image.asset(ic_youtube, height: 22, width: 22, fit: BoxFit.fill).cornerRadiusWithClipRRect(4),
                          ),
                        if (instructor!.social!.linkedin.validate().isNotEmpty)
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              openWebPage(context, url: instructor!.social!.linkedin.validate());
                            },
                            child: Image.asset(ic_linkedIn, height: 22, width: 22, fit: BoxFit.fill),
                          ),
                      ],
                    ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return NoDataWidget(
        imageWidget: NoDataLottieWidget(),
        title: language.noDataFound,
      ).center();
    }
  }
}
