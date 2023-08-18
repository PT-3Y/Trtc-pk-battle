import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/forums/common_models.dart';
import 'package:socialv/models/forums/topic_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/forums/components/initial_topic_reply_component.dart';
import 'package:socialv/screens/forums/components/topic_reply_component.dart';
import 'package:socialv/utils/app_constants.dart';

class TopicDetailScreen extends StatefulWidget {
  final int topicId;
  final bool isFromFav;

  const TopicDetailScreen({required this.topicId, this.isFromFav = false});

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  TopicModel topic = TopicModel();
  List<TopicReplyModel> postList = [];

  ScrollController _scrollController = ScrollController();

  int mPage = 1;
  bool mIsLastPage = false;

  bool isSubscribed = false;
  bool isFavourite = false;
  bool isError = false;
  bool isFetched = false;

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    getDetails();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
          appStore.setLoading(true);
          getDetails();
        }
      }
    });

    LiveStream().on(GetTopicDetail, (p0) {
      getDetails();
    });
  }

  Future<TopicModel> getDetails() async {
    isError = false;
    appStore.setLoading(true);

    if (mPage == 1) {
      postList.clear();
    }

    await getTopicDetail(topicId: widget.topicId, page: mPage).then((value) async {
      topic = value.first;

      mIsLastPage = value.first.postList.validate().length != PER_PAGE;
      postList.addAll(value.first.postList.validate());

      isSubscribed = value.first.isSubscribed.validate();
      isFavourite = value.first.isFavorites.validate();
      isFetched = true;
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      setState(() {});
      appStore.setLoading(false);

      toast(e.toString(), print: true);
    });

    return topic;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(GetTopicDetail);
    _scrollController.dispose();
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
          getDetails();
        },
        color: context.primaryColor,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.iconColor),
              onPressed: () {
                finish(context, isUpdate);
              },
            ),
          ),
          body: Observer(
            builder: (_) => Stack(
              alignment: isFetched ? Alignment.topCenter : Alignment.center,
              children: [
                isFetched
                    ? Container(
                        height: context.height(),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: EdgeInsets.all(18),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(topic.title.validate(), style: boldTextStyle(size: 22)),
                              16.height,
                              Row(
                                children: [
                                  AppButton(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    elevation: 0,
                                    color: isSubscribed ? appOrangeColor : appGreenColor,
                                    child: Text(isSubscribed ? language.unsubscribe : language.subscribe, style: boldTextStyle(color: Colors.white)),
                                    onTap: () {
                                      ifNotTester(() {
                                        isSubscribed = !isSubscribed;
                                        setState(() {});
                                        if (isSubscribed) {
                                          toast(language.subscribedSuccessfully);
                                        } else {
                                          toast(language.unsubscribedSuccessfully);
                                        }

                                        subscribeForum(forumId: widget.topicId).then((value) {
                                          isUpdate = true;
                                        }).catchError((e) {
                                          log(e.toString());
                                        });
                                      });
                                    },
                                  ),
                                  10.width,
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      ifNotTester(() {
                                        isFavourite = !isFavourite;
                                        setState(() {});
                                        if (isFavourite) {
                                          toast(language.addedToFavourites);
                                          if (widget.isFromFav) isUpdate = false;
                                        } else {
                                          toast(language.removedFromFavourites);
                                          isUpdate = true;
                                        }

                                        favoriteTopic(topicId: widget.topicId).then((value) {
                                          log(value.message);
                                        }).catchError((e) {
                                          log(e.toString());
                                        });
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(color: appOrangeColor, borderRadius: radius(defaultAppButtonRadius)),
                                      child: Image.asset(isFavourite ? ic_star_filled : ic_star, width: 26, height: 26, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              16.height,
                              if (topic.tags.validate().isNotEmpty)
                                Wrap(
                                  children: [
                                    Text(
                                      '${language.tags}: ',
                                      style: secondaryTextStyle(color: context.iconColor),
                                    ),
                                    Wrap(
                                      children: topic.tags.validate().map((e) {
                                        int index = topic.tags!.indexOf(e);
                                        return Text('${e.name.validate()} ${index == topic.tags!.length - 1 ? '' : ','}', style: secondaryTextStyle());
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              16.height,
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: context.primaryColor.withAlpha(30),
                                  border: Border(left: BorderSide(color: context.primaryColor, width: 2)),
                                ),
                                child: Text(topic.lastUpdate.validate(), style: secondaryTextStyle()),
                              ),
                              16.height,
                              InitialTopicReplyComponent(
                                topicContent: topic.description.validate(),
                                topicTitle: topic.title.validate(),
                                topicId: widget.topicId,
                                callback: () {
                                  isUpdate = true;
                                  getDetails();
                                },
                              ).visible(topic.postList.validate().isEmpty),
                              Text('${language.viewing} ${topic.postCount} ${language.replies.toLowerCase()}').visible(topic.postList.validate().isNotEmpty),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: postList.validate().length,
                                itemBuilder: (ctx, index) {
                                  TopicReplyModel reply = postList[index];

                                  return Column(
                                    children: [
                                      TopicReplyComponent(
                                        topicId: widget.topicId,
                                        reply: reply,
                                        callback: () {
                                          getDetails();
                                          isUpdate = true;
                                        },
                                        isParent: true,
                                      ),
                                      ListView.builder(
                                        itemBuilder: (_, i) {
                                          return TopicReplyComponent(
                                            topicId: widget.topicId,
                                            isParent: false,
                                            reply: reply.children.validate()[i],
                                            callback: () {
                                              getDetails();
                                              isUpdate = true;
                                            },
                                          );
                                        },
                                        padding: EdgeInsets.only(left: 16),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: reply.children.validate().length,
                                      ),
                                    ],
                                  );
                                },
                              ).visible(postList.validate().isNotEmpty),
                              70.height,
                            ],
                          ),
                        ),
                      ).visible(!isError)
                    : LoadingWidget().center().visible(!appStore.isLoading && !isError),
                if (isError)
                  NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: isError ? language.somethingWentWrong : language.noDataFound,
                    onRetry: () {
                      getDetails();
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center().visible(!appStore.isLoading),
                Positioned(
                  bottom: mPage != 1 ? 10 : null,
                  child: LoadingWidget(isBlurBackground: mPage == 1 ? true : false).center().visible(appStore.isLoading),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
