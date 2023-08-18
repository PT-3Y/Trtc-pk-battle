import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/profile/components/friends_component.dart';
import 'package:socialv/screens/profile/components/request_sent_component.dart';
import 'package:socialv/screens/profile/components/requests_received_component.dart';

import '../../../utils/app_constants.dart';

class ProfileFriendsScreen extends StatefulWidget {
  @override
  State<ProfileFriendsScreen> createState() => _ProfileFriendsScreenState();
}

class _ProfileFriendsScreenState extends State<ProfileFriendsScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  bool isCallback = false;

  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(true);
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        appStore.setLoading(false);

        finish(context, isCallback);
        return Future.value(true);
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(language.friends, style: boldTextStyle(size: 20)),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.iconColor),
              onPressed: () {
                finish(context);
              },
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
                ),
                padding: EdgeInsets.fromLTRB(22, 12, 22, 0),
                child: TabBar(
                  unselectedLabelColor: Colors.white54,
                  labelColor: Colors.white,
                  labelStyle: boldTextStyle(),
                  unselectedLabelStyle: primaryTextStyle(),
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: TabIndicator(),
                  tabs: [
                    Text(language.friends, maxLines: 1, overflow: TextOverflow.ellipsis).paddingSymmetric(vertical: 12),
                    Text(language.sent, maxLines: 1, overflow: TextOverflow.ellipsis).paddingSymmetric(vertical: 12),
                    Text(language.requests, maxLines: 1, overflow: TextOverflow.ellipsis).paddingSymmetric(vertical: 12),
                  ],
                ),
              ),
              Container(
                color: context.primaryColor,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    FriendsComponent(
                      callback: () {
                        isCallback = true;
                      },
                    ),
                    RequestSentComponent(),
                    RequestsReceivedComponent(),
                  ],
                ),
              ).expand(),
            ],
          ),
        ),
      ),
    );
  }
}
