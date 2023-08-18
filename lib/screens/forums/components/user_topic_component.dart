import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/forums/topic_model.dart';
import 'package:socialv/screens/forums/components/topic_card_component.dart';
import 'package:socialv/screens/forums/screens/topic_detail_screen.dart';
import 'package:socialv/utils/app_constants.dart';

import '../../../network/rest_apis.dart';

class UserTopicComponent extends StatefulWidget {
  @override
  State<UserTopicComponent> createState() => _UserTopicComponentState();
}

class _UserTopicComponentState extends State<UserTopicComponent> {
  List<TopicModel> topicsList = [];

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    getList();
  }

  Future<void> getList() async {
    appStore.setLoading(true);
    if (mPage == 1) topicsList.clear();
    await topicList(isEngagement: false, isUserTopic: true, isFav: false, page: mPage).then((value) {
      mIsLastPage = value.length != PER_PAGE;

      topicsList.addAll(value);

      if (mounted) appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      isError = true;
      setState(() {});
      toast(e.toString());

      if (mounted) appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height() * 0.8,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          AnimatedListView(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 50, top: 16),
            itemBuilder: (context, index) {
              TopicModel topic = topicsList[index];
              return InkWell(
                onTap: () {
                  TopicDetailScreen(topicId: topic.id.validate()).launch(context);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: TopicCardComponent(topic: topic, isFavTab: false),
              );
            },
            itemCount: topicsList.length,
            shrinkWrap: true,
            onNextPage: () {
              if (!mIsLastPage) {
                mPage++;
                setState(() {});
                getList();
              }
            },
          ),
          Observer(builder: (_) {
            return appStore.isLoading
                ? Positioned(
                    bottom: mPage != 1 ? 10 : null,
                    child: LoadingWidget(isBlurBackground: false).center(),
                  )
                : NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: isError ? language.somethingWentWrong : language.noDataFound,
                    onRetry: () {
                      mPage = 1;
                      getList();
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center().visible(topicsList.isEmpty);
          })
        ],
      ),
    );
  }
}
