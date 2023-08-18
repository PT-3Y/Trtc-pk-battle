import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/groups/components/private_group_members_component.dart';
import 'package:socialv/screens/groups/components/request_component.dart';

import '../../../utils/app_constants.dart';

class GroupMemberRequestScreen extends StatefulWidget {
  final int groupId;
  final bool isAdmin;
  final int creatorId;

  GroupMemberRequestScreen({required this.groupId, required this.isAdmin, required this.creatorId});

  @override
  State<GroupMemberRequestScreen> createState() => _GroupMemberRequestScreenState();
}

class _GroupMemberRequestScreenState extends State<GroupMemberRequestScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  int valueKeyId = 0;

  bool isCallback = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(language.groupMembers, style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.iconColor),
            onPressed: () {
              finish(context, isCallback);
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: appColorPrimary,
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
                  Text(language.members).paddingSymmetric(vertical: 12),
                  Text(language.requests).paddingSymmetric(vertical: 12),
                ],
              ),
            ),
            Container(
              key: ValueKey(valueKeyId),
              color: appColorPrimary,
              child: TabBarView(
                controller: tabController,
                children: [
                  PrivateGroupMembersComponent(
                    creatorId: widget.creatorId,
                    isAdmin: widget.isAdmin,
                    groupId: widget.groupId,
                    callback: () {
                      isCallback = true;
                    },
                  ),
                  RequestComponent(
                    groupId: widget.groupId,
                    onRequestAccept: (int id) {
                      valueKeyId = id;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ).expand(),
          ],
        ),
      ),
    );
  }
}
