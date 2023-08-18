import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/lms/screens/lms_order_screen.dart';
import 'package:socialv/utils/app_constants.dart';

import '../../../components/loading_widget.dart';
import '../../../components/no_data_lottie_widget.dart';
import '../../../models/lms/course_orders.dart';
import '../../../models/lms/lms_order_model.dart';
import '../../../network/rest_apis.dart';
import '../components/course_orders_card_component.dart';
import 'course_detail_screen.dart';

class CourseOrdersScreen extends StatefulWidget {
  const CourseOrdersScreen({Key? key}) : super(key: key);

  @override
  State<CourseOrdersScreen> createState() => _CourseOrdersScreenState();
}

class _CourseOrdersScreenState extends State<CourseOrdersScreen> {
  late LmsOrderModel orderDetail;
  List<CourseOrders> courseOrdersList = [];
  late Future<List<CourseOrders>> future;
  ScrollController scrollController = ScrollController();
  int mPage = 1;
  bool isError = false;
  bool mIsLastPage = false;
  bool loaderPosition = false;

  @override
  void initState() {
    super.initState();
    init();
    afterBuildCreated(
      () {
        scrollController.addListener(
          () {
            if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
              if (!mIsLastPage) {
                mPage++;
                init();
              }
            }
          },
        );
      },
    );
  }

  void init() async {
    future = getCourseOrders();
  }

  Future<List<CourseOrders>> getCourseOrders() async {
    appStore.setLoading(true);
    if (mPage == 1) courseOrdersList.clear();
    await courseOrders(page: mPage).then((value) {
      courseOrdersList.addAll(value);
      mIsLastPage = value.length != PER_PAGE;
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
      isError = true;
      appStore.setLoading(false);
    });
    return courseOrdersList;
  }

  Future<void> orderDetails({required int id}) async {
    appStore.setLoading(true);
    await getOrderDetails(id: id).then((value) {
      orderDetail = value;
      appStore.setLoading(false);
      LmsOrderScreen(orderDetail: orderDetail).launch(context).then((value) {
        loaderPosition = value;
      });
    }).catchError((e) {
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    // scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Course Orders",
          style: boldTextStyle(size: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (isError && !appStore.isLoading) {
                return SizedBox(
                  height: context.height() * 0.8,
                  child: NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: language.somethingWentWrong,
                    onRetry: () {
                      init();
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center(),
                );
              } else if (snapshot.hasData && !appStore.isLoading) {
                if (courseOrdersList.isEmpty) {
                  return SizedBox(
                    height: context.height() * 0.8,
                    child: NoDataWidget(
                      imageWidget: NoDataLottieWidget(),
                      title: language.noDataFound,
                      onRetry: () {
                        init();
                      },
                      retryText: '   ${language.clickToRefresh}   ',
                    ).center(),
                  );
                } else {
                  return AnimatedListView(
                    controller: scrollController,
                    padding: EdgeInsets.only(bottom: mIsLastPage ? 16 : 60, left: 16, right: 16, top: 16),
                    itemCount: courseOrdersList.length,
                    shrinkWrap: true,
                    slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
                    itemBuilder: (p0, index) {
                      CourseOrders data = courseOrdersList[index];
                      return CourseOrderCardComponent(
                        data: data,
                        onTap: (id) {
                          loaderPosition = true;
                          orderDetails(id: id);
                        },
                      );
                    },
                  );
                }
              } else {
                return Offstage();
              }
            },
          ),
          Positioned(
            bottom: loaderPosition || mPage != 1 ? 8 : null,
            width: loaderPosition || mPage != 1 ? MediaQuery.of(context).size.width : null,
            child: Observer(builder: (_) => LoadingWidget(isBlurBackground: mPage == 1 ? true : false).center().visible(appStore.isLoading)),
          ),
        ],
      ),
    );
  }
}
