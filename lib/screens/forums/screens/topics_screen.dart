import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/forums/topic_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/forums/components/topic_card_component.dart';
import 'package:socialv/screens/forums/screens/topic_detail_screen.dart';

import '../../../utils/app_constants.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({Key? key}) : super(key: key);

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  List<TopicModel> topicsList = [];
  late Future<List<TopicModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;

  bool isError = false;
  bool isUpdate = false;

  @override
  void initState() {
    future = getTopics();
    super.initState();
  }

  Future<List<TopicModel>> getTopics() async {
    isError = false;
    appStore.setLoading(true);

    await subscribedList(page: mPage).then((value) {
      if (mPage == 1) topicsList.clear();
      mIsLastPage = value.topics.validate().length != PER_PAGE;
      topicsList.addAll(value.topics.validate());
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return topicsList;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        appStore.setLoading(false);
        finish(context, isUpdate);
        return Future.value(true);
      },
      child: RefreshIndicator(
        onRefresh: () async {
          mPage = 1;
          future = getTopics();
        },
        color: context.primaryColor,
        child: Scaffold(
          appBar: AppBar(
            title: Text(language.topics, style: boldTextStyle(size: 20)),
            centerTitle: true,
          ),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              FutureBuilder<List<TopicModel>>(
                future: future,
                builder: (ctx, snap) {
                  if (snap.hasError) {
                    return NoDataWidget(
                      imageWidget: NoDataLottieWidget(),
                      title: isError ? language.somethingWentWrong : language.noDataFound,
                      onRetry: () {
                        mPage = 1;
                        future = getTopics();
                      },
                      retryText: '   ${language.clickToRefresh}   ',
                    ).center();
                  }

                  if (snap.hasData) {
                    if (snap.data.validate().isEmpty) {
                      return NoDataWidget(
                        imageWidget: NoDataLottieWidget(),
                        title: isError ? language.somethingWentWrong : language.noDataFound,
                        onRetry: () {
                          mPage = 1;
                          future = getTopics();
                        },
                        retryText: '   ${language.clickToRefresh}   ',
                      ).center();
                    } else {
                      return AnimatedListView(
                        slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                        itemCount: topicsList.length,
                        itemBuilder: (context, index) {
                          TopicModel data = topicsList[index];

                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              TopicDetailScreen(topicId: data.id.validate()).launch(context).then((value) {
                                if (value ?? false) {
                                  isUpdate = true;
                                  future = getTopics();
                                }
                              });
                            },
                            child: TopicCardComponent(topic: data, isFavTab: false),
                          );
                        },
                        onNextPage: () {
                          if (!mIsLastPage) {
                            mPage++;
                            future = getTopics();
                          }
                        },
                      );
                    }
                  }
                  return Offstage();
                },
              ),
              Observer(
                builder: (_) {
                  if (appStore.isLoading) {
                    return Positioned(
                      bottom: mPage != 1 ? 10 : null,
                      child: LoadingWidget(isBlurBackground: mPage == 1 ? true : false),
                    );
                  } else {
                    return Offstage();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
