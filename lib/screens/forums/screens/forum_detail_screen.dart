import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/forums/forum_detail_model.dart';
import 'package:socialv/models/forums/forum_model.dart';
import 'package:socialv/models/forums/topic_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/forums/components/forum_detail_component.dart';
import 'package:socialv/screens/forums/screens/create_topic_screen.dart';
import 'package:socialv/screens/groups/screens/group_detail_screen.dart';
import 'package:socialv/utils/app_constants.dart';

import '../../profile/components/profile_header_component.dart';

class ForumDetailScreen extends StatefulWidget {
  final int forumId;
  final String type;
  final bool isFromSubscription;

  const ForumDetailScreen({required this.forumId, required this.type, this.isFromSubscription = false});

  @override
  State<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> with SingleTickerProviderStateMixin {
  ForumDetailModel forum = ForumDetailModel();
  ScrollController _scrollController = ScrollController();

  List<TopicModel> topicList = [];
  List<ForumModel> forumList = [];

  int selectedIndex = 0;

  late TabController tabController;

  int mPage = 1;
  bool mIsLastPage = false;

  bool isSubscribed = false;
  bool showOptions = false;
  bool isError = false;
  bool isUpdate = false;
  bool isFetched = false;

  @override
  void initState() {
    super.initState();
    getDetails();

    tabController = TabController(length: 2, vsync: this);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
          appStore.setLoading(true);
          getDetails();
        }
      }
    });
  }

  Future<ForumDetailModel> getDetails() async {
    isError = false;
    appStore.setLoading(true);

    await getForumDetail(forumId: widget.forumId, page: mPage).then((value) async {
      forum = value;

      if (value.forumList.validate().isNotEmpty) {
        selectedIndex = 1;
      } else {
        selectedIndex = 0;
      }

      isFetched = true;
      isSubscribed = value.isSubscribed.validate();
      if (mPage == 1) {
        forumList.clear();
        topicList.clear();
      }

      mIsLastPage = value.topicList.validate().length != PER_PAGE && value.forumList.validate().length != PER_PAGE;
      topicList.addAll(value.topicList.validate());
      forumList.addAll(value.forumList.validate());

      showOptions = forumList.validate().isNotEmpty && topicList.validate().isNotEmpty;

      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      setState(() {});

      toast(e.toString(), print: true);
    });

    return forum;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    tabController.dispose();
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
          mPage = 1;
          getDetails();
        },
        color: context.primaryColor,
        child: Scaffold(
          appBar: AppBar(
            title: Text(forum.title.validate(), style: boldTextStyle(size: 20)),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.iconColor),
              onPressed: () {
                finish(context, isUpdate);
              },
            ),
            actions: [
              Theme(
                data: Theme.of(context).copyWith(useMaterial3: false),
                child: PopupMenuButton(
                  position: PopupMenuPosition.under,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
                  onSelected: (val) async {
                    if (val == 1) {
                      ifNotTester(() {
                        isSubscribed = !isSubscribed;
                        setState(() {});

                        if (isSubscribed) {
                          toast(language.subscribedSuccessfully);
                        } else {
                          toast(language.unsubscribedSuccessfully);
                        }

                        subscribeForum(forumId: widget.forumId).then((value) {
                          if (widget.isFromSubscription) isUpdate = true;
                        }).catchError((e) {
                          log(e.toString());
                        });
                      });
                    } else {
                      CreateTopicScreen(forumName: forum.title.validate(), forumId: widget.forumId).launch(context).then((value) {
                        if (value ?? false) {
                          isUpdate = true;
                          appStore.setLoading(true);
                          mPage = 1;
                          setState(() {});
                          getDetails();
                        }
                      });
                    }
                  },
                  icon: Icon(Icons.more_horiz),
                  itemBuilder: (context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      value: 1,
                      child: Text(isSubscribed ? language.unsubscribe : language.subscribe),
                      textStyle: primaryTextStyle(),
                    ),
                    if (forum.groupDetails == null || forum.groupDetails!.isGroupMember.validate())
                      PopupMenuItem(
                        value: 2,
                        child: Text(language.createTopic),
                        textStyle: primaryTextStyle(),
                      ),
                  ],
                ),
              ),
            ],
          ),
          body: Observer(
            builder: (_) {
              return Stack(
                alignment: isFetched ? Alignment.topCenter : Alignment.center,
                children: [
                  isFetched
                      ? SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileHeaderComponent(
                                avatarUrl: forum.image.validate(),
                                cover: forum.groupDetails != null && forum.groupDetails!.coverImage.validate().isNotEmpty ? forum.groupDetails!.coverImage.validate() : null,
                              ),
                              16.height,
                              Text(forum.title.validate(), style: boldTextStyle(size: 20)).paddingSymmetric(horizontal: 16).onTap(() {
                                if (forum.groupDetails != null && forum.groupDetails!.groupId != 0) {
                                  GroupDetailScreen(groupId: forum.groupDetails!.groupId.validate()).launch(context).then((value) {
                                    if (value ?? false) {
                                      mPage = 1;
                                      setState(() {});
                                      getDetails();
                                    }
                                  });
                                }
                              }, splashColor: Colors.transparent, highlightColor: Colors.transparent).center(),
                              8.height,
                              ReadMoreText(
                                forum.description.validate(),
                                trimLength: 100,
                                style: secondaryTextStyle(),
                                textAlign: TextAlign.center,
                              ).paddingSymmetric(horizontal: 16).center(),
                              16.height,
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

                                    subscribeForum(forumId: widget.forumId).then((value) {
                                      if (widget.isFromSubscription) isUpdate = true;
                                    }).catchError((e) {
                                      log(e.toString());
                                    });
                                  });
                                },
                              ).paddingSymmetric(horizontal: 16),
                              Container(
                                margin: EdgeInsets.all(16),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: context.primaryColor.withAlpha(30),
                                  border: Border(left: BorderSide(color: context.primaryColor, width: 2)),
                                ),
                                child: Text(forum.lastUpdate.validate(), style: secondaryTextStyle()),
                              ),
                              if ((forum.groupDetails != null && forum.groupDetails!.isGroupMember.validate()) || forum.isPrivate == 0)
                                ForumDetailComponent(
                                    type: widget.type,
                                    forumList: forumList,
                                    topicList: topicList,
                                    selectedIndex: selectedIndex,
                                    showOptions: showOptions,
                                    callback: () {
                                      isUpdate = true;
                                      mPage = 1;
                                      setState(() {});
                                      getDetails();
                                    })
                              else if (forum.groupDetails != null && !forum.groupDetails!.isGroupMember.validate())
                                appButton(
                                  context: context,
                                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                                  text: language.viewGroup,
                                  textStyle: boldTextStyle(color: Colors.white),
                                  onTap: () {
                                    if (forum.groupDetails != null && forum.groupDetails!.groupId != 0)
                                      GroupDetailScreen(groupId: forum.groupDetails!.groupId.validate()).launch(context).then((value) {
                                        if (value ?? false) {
                                          mPage = 1;
                                          setState(() {});
                                          getDetails();
                                        }
                                      });
                                    else
                                      toast(language.canNotViewThisGroup);
                                  },
                                  width: context.width() - 64,
                                ).paddingSymmetric(vertical: 20).center()
                              else
                                ForumDetailComponent(
                                    type: widget.type,
                                    forumList: forumList,
                                    topicList: topicList,
                                    selectedIndex: selectedIndex,
                                    showOptions: showOptions,
                                    callback: () {
                                      isUpdate = true;
                                      mPage = 1;
                                      setState(() {});
                                      getDetails();
                                    }),
                              70.height,
                            ],
                          ),
                        ).visible(!isError)
                      : LoadingWidget().center().visible(!appStore.isLoading & !isError),
                  if (isError)
                    NoDataWidget(
                      imageWidget: NoDataLottieWidget(),
                      title: isError ? language.somethingWentWrong : language.noDataFound,
                      retryText: '   ${language.clickToRefresh}   ',
                      onRetry: () {
                        mPage = 1;
                        getDetails();
                      },
                    ).center(),
                  Positioned(
                    bottom: mPage != 1 ? 10 : null,
                    child: LoadingWidget(isBlurBackground: mPage == 1 ? true : false).center().visible(appStore.isLoading),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
