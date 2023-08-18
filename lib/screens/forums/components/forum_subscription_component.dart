import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/forums/forum_model.dart';
import 'package:socialv/models/forums/topic_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/forums/components/forums_card_component.dart';
import 'package:socialv/screens/forums/components/topic_card_component.dart';
import 'package:socialv/screens/forums/screens/forum_detail_screen.dart';
import 'package:socialv/screens/forums/screens/forums_screen.dart';
import 'package:socialv/screens/forums/screens/topic_detail_screen.dart';
import 'package:socialv/screens/forums/screens/topics_screen.dart';

class ForumSubscriptionComponent extends StatefulWidget {
  const ForumSubscriptionComponent({Key? key}) : super(key: key);

  @override
  State<ForumSubscriptionComponent> createState() => _ForumSubscriptionComponentState();
}

class _ForumSubscriptionComponentState extends State<ForumSubscriptionComponent> {
  List<ForumModel> forumList = [];
  List<TopicModel> topicList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getList();
  }

  Future<void> getList() async {
    appStore.setLoading(true);

    await subscribedList(perPage: 3).then((value) {
      forumList = value.forums.validate();
      topicList = value.topics.validate();
      setState(() {});
      if (mounted) appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString());
      setState(() {});
      if (mounted) appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.forums, style: boldTextStyle()),
                  Text(language.viewAll, style: primaryTextStyle(color: context.primaryColor)).onTap(() {
                    ForumsScreen().launch(context).then((value) {
                      if (value ?? false) {
                        getList();
                      }
                    });
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent).visible(forumList.validate().length > 2),
                ],
              ).visible(forumList.isNotEmpty),
              AnimatedListView(
                listAnimationType: ListAnimationType.FadeIn,
                itemCount: forumList.take(2).length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  ForumModel forum = forumList[index];
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      ForumDetailScreen(
                        forumId: forum.id.validate(),
                        type: forum.type.validate(),
                        isFromSubscription: true,
                      ).launch(context).then((value) {
                        if (value ?? false) {
                          getList();
                        }
                      });
                    },
                    child: ForumsCardComponent(
                      title: forum.title,
                      description: forum.description,
                      postCount: forum.postCount,
                      topicCount: forum.topicCount,
                      freshness: forum.freshness,
                    ),
                  );
                },
              ).visible(forumList.isNotEmpty),
              16.height.visible(forumList.isNotEmpty),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.topics, style: boldTextStyle()),
                  Text(language.viewAll, style: primaryTextStyle(color: context.primaryColor)).onTap(() {
                    TopicsScreen().launch(context).then((value) {
                      if (value ?? false) {
                        getList();
                      }
                    });
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent).visible(topicList.validate().length > 2),
                ],
              ).visible(topicList.isNotEmpty),
              AnimatedListView(
                listAnimationType: ListAnimationType.FadeIn,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: topicList.take(2).length,
                itemBuilder: (ctx, index) {
                  TopicModel topic = topicList[index];
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      TopicDetailScreen(topicId: topic.id.validate()).launch(context).then((value) {
                        if (value ?? false) {
                          getList();
                        }
                      });
                    },
                    child: TopicCardComponent(topic: topic, isFavTab: false, showForums: false),
                  );
                },
              ).visible(topicList.isNotEmpty),
              50.height,
            ],
          ).paddingSymmetric(horizontal: 16),
        ),
        Observer(
          builder: (_) {
            return appStore.isLoading
                ? LoadingWidget(isBlurBackground: false).center()
                : NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: language.noDataFound,
                    onRetry: () {
                      getList();
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center().visible(topicList.isEmpty && forumList.isEmpty);
          },
        )
      ],
    );
  }
}
