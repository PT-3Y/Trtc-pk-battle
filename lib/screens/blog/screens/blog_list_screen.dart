import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/posts/wp_post_response.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/blog/components/blog_card_component.dart';
import 'package:socialv/utils/constants.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({Key? key}) : super(key: key);

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  List<WpPostResponse> blogList = [];
  late Future<List<WpPostResponse>> future;

  List<String> tags = [];
  String category = '';

  int mPage = 1;
  bool mIsLastPage = false;

  bool isChange = false;
  bool isError = false;

  @override
  void initState() {
    future = getBlogs();
    super.initState();
  }

  Future<List<WpPostResponse>> getBlogs() async {
    appStore.setLoading(true);

    await getBlogList(page: mPage).then((value) {
      if (mPage == 1) blogList.clear();
      mIsLastPage = value.length != PER_PAGE;
      blogList.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return blogList;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    future = getBlogs();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.blogs, style: boldTextStyle(size: 20)),
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
          FutureBuilder<List<WpPostResponse>>(
            future: future,
            builder: (ctx, snap) {
              if (snap.hasError) {
                return NoDataWidget(
                  imageWidget: NoDataLottieWidget(),
                  title: isError ? language.somethingWentWrong : language.noDataFound,
                  onRetry: () {
                    onRefresh();
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
                      onRefresh();
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center();
                } else {
                  return AnimatedListView(
                    slideConfiguration: SlideConfiguration(
                      delay: 80.milliseconds,
                      verticalOffset: 300,
                    ),
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                    itemCount: blogList.length,
                    itemBuilder: (context, index) {
                      WpPostResponse data = blogList[index];
                      return Observer(builder: (context) {
                        return BlogCardComponent(data: data);
                      });
                    },
                    onNextPage: () {
                      if (!mIsLastPage && !appStore.isLoading) {
                        mPage++;
                        future = getBlogs();
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
    );
  }
}
