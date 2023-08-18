import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../components/loading_widget.dart';
import '../../../components/no_data_lottie_widget.dart';
import '../../../main.dart';
import '../../../models/reactions/reactions_count_model.dart';
import '../../../network/rest_apis.dart';

import '../../../utils/constants.dart';

import '../components/reaction_list_component.dart';

class ReactionScreen extends StatefulWidget {
  final int postId;
  final bool isCommentScreen;

  const ReactionScreen({Key? key, required this.postId, required this.isCommentScreen}) : super(key: key);

  @override
  State<ReactionScreen> createState() => _ReactionScreenState();
}

class _ReactionScreenState extends State<ReactionScreen> {
  List<Reactions> list = [];
  List<Reactions> count = [];
  String selectedReaction = "";

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    reactionList();
  }

  void reactionList() async {
    appStore.setLoading(true);
    count.clear();

    await getUsersReaction(id: widget.postId, isComments: widget.isCommentScreen, reactionID: selectedReaction, page: mPage).then((value) {
      if (mPage == 1) list.clear();

      mIsLastPage = value.reactions.validate().length != PER_PAGE;
      list.addAll(value.reactions.validate());
      count = value.count.validate();
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      setState(() {});
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    reactionList();
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
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(language.reactions, style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.iconColor),
            onPressed: () {
              finish(context);
            },
          ),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            if ((isError || list.isEmpty) && !appStore.isLoading)
              NoDataWidget(
                imageWidget: NoDataLottieWidget(),
                title: isError ? language.somethingWentWrong : language.noDataFound,
                onRetry: () {
                  onRefresh();
                },
                retryText: '   ${language.clickToRefresh}   ',
              ).center(),
            if (list.isNotEmpty)
              AnimatedListView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 50, top: 50),
                slideConfiguration: SlideConfiguration(
                  delay: 80.milliseconds,
                  verticalOffset: 300,
                ),
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (p0, index) {
                  return ReactionListComponent(
                    reaction: list[index],
                    index: index,
                  );
                },
                onNextPage: () {
                  if (!mIsLastPage) {
                    mPage++;
                    reactionList();
                  }
                },
              ),
            Align(
              alignment: Alignment.topLeft,
              child: HorizontalList(
                itemCount: count.length,
                padding: EdgeInsets.symmetric(horizontal: 8),
                spacing: 0,
                runSpacing: 0,
                itemBuilder: (ctx, index) {
                  Reactions e = count[index];
                  if (e.count != 0)
                    return TextIcon(
                      onTap: () {
                        if (selectedReaction != e.id) {
                          if (e.id == "0") {
                            selectedReaction = "";
                          } else {
                            selectedReaction = e.id.validate();
                          }
                          mPage = 1;
                          reactionList();
                        }
                      },
                      text: e.id == "0" ? '${e.title.validate().capitalizeFirstLetter()} (${e.count.validate()})' : e.count.validate().toString(),
                      textStyle: secondaryTextStyle(size: 16),
                      prefix: e.icon.validate().isNotEmpty
                          ? cachedImage(
                              e.icon.validate(),
                              width: 16,
                              height: 16,
                              fit: BoxFit.cover,
                            )
                          : Offstage(),
                    );
                  else
                    return Offstage();
                },
              ),
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
    );
  }
}
