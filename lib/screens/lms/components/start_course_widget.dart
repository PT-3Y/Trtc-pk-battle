import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/app_constants.dart';

class StartCourseWidget extends StatelessWidget {
  final VoidCallback? callback;

  const StartCourseWidget({this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius()),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/demo/images/party_popper.png', width: 70, height: 70, fit: BoxFit.cover),
          16.height,
          Text(
            language.congratulationsYouHavSuccessfully,
            style: secondaryTextStyle(),
            textAlign: TextAlign.center,
          ),
          8.height,
          Text(language.enjoyLearning, style: primaryTextStyle(color: context.primaryColor)),
          20.height,
          InkWell(
            onTap: () {
              finish(context);
              callback!.call();
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(color: context.primaryColor, borderRadius: radius(commonRadius)),
              child: Text(language.start, style: boldTextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
