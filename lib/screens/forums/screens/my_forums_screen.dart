import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/forums/components/favourite_topics_component.dart';
import 'package:socialv/screens/forums/components/forum_replies_component.dart';
import 'package:socialv/screens/forums/components/forum_subscription_component.dart';
import 'package:socialv/screens/forums/components/user_topic_component.dart';
import 'package:socialv/screens/forums/components/forums_engagement_component.dart';

import '../../../utils/app_constants.dart';

class MyForumsScreen extends StatefulWidget {
  const MyForumsScreen({Key? key}) : super(key: key);

  @override
  State<MyForumsScreen> createState() => _MyForumsScreenState();
}

class _MyForumsScreenState extends State<MyForumsScreen> {
  List<String> tabList = [language.topics, language.replies, language.engagement, language.favourite, language.subscriptions];

  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget getTabContainer() {
    if (selectedTab == 0) {
      return UserTopicComponent();
    } else if (selectedTab == 1) {
      return ForumRepliesComponent();
    } else if (selectedTab == 2) {
      return ForumsEngagementComponent();
    } else if (selectedTab == 3) {
      return FavouriteTopicComponent();
    } else {
      return ForumSubscriptionComponent();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(language.forums, style: boldTextStyle(size: 20)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Column(
        children: [
          HorizontalList(
            spacing: 0,
            padding: EdgeInsets.all(16),
            itemCount: tabList.length,
            itemBuilder: (context, index) {
              return AppButton(
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(commonRadius)),
                text: tabList[index],
                textStyle: boldTextStyle(
                  color: selectedTab == index
                      ? Colors.white
                      : appStore.isDarkMode
                          ? bodyDark
                          : bodyWhite,
                  size: 14,
                ),
                onTap: () {
                  selectedTab = index;
                  setState(() {});
                },
                elevation: 0,
                color: selectedTab == index ? context.primaryColor : context.scaffoldBackgroundColor,
              );
            },
          ),
          getTabContainer().expand(),
        ],
      ),
    );
  }
}
