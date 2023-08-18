import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/groups/components/create_group_step_one.dart';
import 'package:socialv/screens/groups/components/create_group_step_second.dart';
import 'package:socialv/screens/groups/components/create_group_step_third.dart';
import 'package:socialv/screens/groups/components/create_group_step_four.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

int groupId = -1;

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  PageController _pageController = PageController(initialPage: 0);
  List<Widget> createGroupItemWidgets = [];

  @override
  void initState() {
    super.initState();
    createGroupItemWidgets.addAll(
      [
        CreateGroupStepOne(
          onNextPage: (int nextPageIndex) {
            _pageController.animateToPage(nextPageIndex, duration: const Duration(milliseconds: 250), curve: Curves.linear);
          },
        ),
        CreateGroupStepSecond(
          onNextPage: (int nextPageIndex) {
            _pageController.animateToPage(nextPageIndex, duration: const Duration(milliseconds: 250), curve: Curves.linear);
          },
        ),
        CreateGroupStepThird(
          onNextPage: (int nextPageIndex) {
            _pageController.animateToPage(nextPageIndex, duration: const Duration(milliseconds: 250), curve: Curves.linear);
          },
        ),
        CreateGroupStepFour(onFinish: () => finish(context, true)),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.createGroup, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context, groupId != -1 ? true : false);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
        ),
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: createGroupItemWidgets,
        ),
      ),
    );
  }
}
