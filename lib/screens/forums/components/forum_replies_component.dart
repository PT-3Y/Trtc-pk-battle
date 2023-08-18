import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/forums/common_models.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/forums/components/topic_reply_component.dart';

import '../../../utils/app_constants.dart';

class ForumRepliesComponent extends StatefulWidget {
  const ForumRepliesComponent({Key? key}) : super(key: key);

  @override
  State<ForumRepliesComponent> createState() => _ForumRepliesComponentState();
}

class _ForumRepliesComponentState extends State<ForumRepliesComponent> {
  List<TopicReplyModel> repliesList = [];

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
    if (mPage == 1) repliesList.clear();

    await forumRepliesList(page: mPage).then((value) {
      mIsLastPage = value.length != PER_PAGE;

      repliesList.addAll(value);
      setState(() {});
      if (mounted) appStore.setLoading(false);
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height() * 0.8,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          AnimatedListView(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 50, top: 16),
            itemBuilder: (context, index) {
              return TopicReplyComponent(
                reply: repliesList[index],
                showReply: false,
                isParent: true,
              );
            },
            itemCount: repliesList.length,
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
                  ).center().visible(repliesList.isEmpty);
          })
        ],
      ),
    );
  }
}
