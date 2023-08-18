import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/member_detail_model.dart';
import 'package:socialv/utils/app_constants.dart';

class PersonalInfoScreen extends StatelessWidget {
  final List<ProfileInfo>? profileInfo;
  final bool hasUserInfo;

  PersonalInfoScreen({this.profileInfo, this.hasUserInfo = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.personalInfo, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: hasUserInfo
          ? ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: profileInfo.validate().length,
              itemBuilder: (ctx, index) {
                if (profileInfo![index].fields.validate().any((element) => element.value!.isNotEmpty)) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: context.width(),
                        color: context.cardColor,
                        padding: EdgeInsets.all(16),
                        child: Text(profileInfo![index].name.validate(), style: boldTextStyle(color: context.primaryColor)),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: profileInfo![index].fields.validate().length,
                        itemBuilder: (ctx, i) {
                          if (profileInfo![index].fields![i].value.validate().isNotEmpty) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  profileInfo![index].fields![i].name.validate(),
                                  style: boldTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 14),
                                ).expand(),
                                Text(
                                  profileInfo![index].fields![i].name == ProfileFields.birthDate
                                      ? parseHtmlString(profileInfo![index].fields![i].value.validate().substring(0, 10))
                                      : parseHtmlString(profileInfo![index].fields![i].value.validate()),
                                  style: secondaryTextStyle(),
                                ).expand(),
                              ],
                            ).paddingSymmetric(vertical: 4);
                          } else {
                            return Offstage();
                          }
                        },
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      )
                    ],
                  );
                }
                return Offstage();
              },
            )
          : NoDataWidget(imageWidget: NoDataLottieWidget(), title: language.noDataFound),
    );
  }
}
