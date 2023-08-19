import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/posts/post_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/home/components/ad_component.dart';
import 'package:socialv/screens/home/components/initial_home_component.dart';
import 'package:socialv/screens/home/components/suggested_user_component.dart';
import 'package:socialv/screens/post/components/post_component.dart';
import 'package:socialv/screens/stories/component/home_story_component.dart';
import 'package:socialv/Trtc/trtc_sdk_manager.dart';
// import 'package:socialv/Trtc/TRTCLiveRoomDemo/ui/list/LiveRoomList.dart';




import '../../utils/app_constants.dart';

class HomeFragment extends StatefulWidget {
  final ScrollController controller;

  const HomeFragment({super.key, required this.controller});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  List<PostModel> postList = [];
  late Future<List<PostModel>> future;

  int mPage = 1;
  bool mIsLastPage = false;
  bool isError = false;

  @override
  void initState() {
        init();/// add nea feature setting userid username
    future = getPostList();

    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = const Duration(milliseconds: 500);
    _animationController.drive(CurveTween(curve: Curves.easeOutQuad));

    super.initState();

    setStatusBarColorBasedOnTheme();

    widget.controller.addListener(() {
      /// pagination
      if (selectedIndex == 0) {
        if (widget.controller.position.pixels == widget.controller.position.maxScrollExtent) {
          if (!mIsLastPage) {
            mPage++;
            future = getPostList();
          }
        }
      }
    });

    LiveStream().on(OnAddPost, (p0) {
      appStore.setLoading(true);
      postList.clear();
      mPage = 1;
      setState(() {});
      future = getPostList();
    });



    
  }

  

   Future<void> init() async {
    // =======================Fong 20230816=========================//
    String loginUserId = appStore.loginUserId;
    String loginName = appStore.loginName;
    await TrtcSDKManager.instance.connectUser(loginUserId, loginName, token: '');
    //  ====================Fong end=================================//
  }



  Future<List<PostModel>> getPostList({bool showLoader = true}) async {
    if (showLoader) appStore.setLoading(true);
    await getPost(page: mPage, type: PostRequestType.all).then((value) {
      if (mPage == 1) postList.clear();

      mIsLastPage = value.length != PER_PAGE;
      postList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
      setState(() {});
    });

    return postList;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(OnAddPost);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.height,
            if (!isError)
              HomeStoryComponent(callback: () {
                LiveStream().emit(GetUserStories);
              }),
            AnimatedListView(
              padding: EdgeInsets.only(bottom: mIsLastPage ? 16 : 60),
              itemCount: postList.length,
              slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PostComponent(
                      post: postList[index],
                      count: 0,
                      callback: () {
                        mPage = 1;
                        future = getPostList();
                      },
                      commentCallback: () {
                        mPage = 1;
                        future = getPostList(showLoader: false);
                      },
                      showHidePostOption: true,
                    ).paddingSymmetric(horizontal: 8),
                    if ((index + 1) % 5 == 0) AdComponent(),
                    if ((index + 1) == 3) SuggestedUserComponent(),
                  ],
                );
              },
              shrinkWrap: true,
            ),
          ],
        ),
        if (!appStore.isLoading && isError && postList.isEmpty)
          SizedBox(
            height: context.height() * 0.8,
            child: NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: isError ? language.somethingWentWrong : language.noDataFound,
              onRetry: () {
                isError = false;
                LiveStream().emit(OnAddPost);
              },
              retryText: '   ${language.clickToRefresh}   ',
            ).center(),
          ),
        if (postList.isEmpty && !appStore.isLoading && !isError)
          SizedBox(
            height: context.height() * 0.8,
            child: InitialHomeComponent().center(),
          ),
        Observer(builder: (_) {
          if (mPage != 1) {
            return Positioned(
              bottom: mPage != 1 ? 8 : null,
              child: Observer(builder: (_) => LoadingWidget(isBlurBackground: false).center().visible(appStore.isLoading)),
            );
          } else {
            return LoadingWidget().center().visible(appStore.isLoading);
          }
        }),
      ],
    );
  }
}
