import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/home/screens/group_list_screen.dart';
import 'package:socialv/screens/home/screens/members_list_screen.dart';
import 'package:socialv/utils/app_constants.dart';

class InitialHomeComponent extends StatefulWidget {
  const InitialHomeComponent({Key? key}) : super(key: key);

  @override
  State<InitialHomeComponent> createState() => _InitialHomeComponentState();
}

class _InitialHomeComponentState extends State<InitialHomeComponent> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EmptyPostLottieWidget(),
          Text(
            language.initialHomeText,
            style: secondaryTextStyle(size: 16, letterSpacing: 1.2),
            textAlign: TextAlign.center,
          ).paddingSymmetric(horizontal: 8),
          16.height,
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
              side: MaterialStateProperty.all(BorderSide(color: appColorPrimary.withOpacity(0.5))),
            ),
            onPressed: () {
              MembersListScreen().launch(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(ic_add_user, width: 20, height: 20, fit: BoxFit.cover, color: appColorPrimary),
                4.width,
                Text(language.addFriends, style: primaryTextStyle(size: 14)),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 0.3,
                width: 80,
                color: Colors.grey.shade500,
              ),
              12.width,
              Text(language.or, style: secondaryTextStyle()),
              12.width,
              Container(
                height: 0.3,
                width: 80,
                color: Colors.grey.shade500,
              ),
            ],
          ),
          TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                side: MaterialStateProperty.all(BorderSide(color: appColorPrimary.withOpacity(0.5)))),
            onPressed: () {
              GroupListScreen().launch(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(ic_three_user, width: 20, height: 20, fit: BoxFit.cover),
                4.width,
                Text(language.joinGroup, style: primaryTextStyle(size: 14)),
              ],
            ),
          ),
        ],
      ).paddingAll(16),
    );
  }
}
