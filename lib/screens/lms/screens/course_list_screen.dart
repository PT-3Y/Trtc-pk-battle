import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/course_list_model.dart';
import 'package:socialv/network/lms_rest_apis.dart';
import 'package:socialv/screens/lms/components/course_card_component.dart';
import 'package:socialv/screens/lms/components/empty_mycourse_component.dart';

import '../../../models/lms/course_category.dart';
import '../../../network/rest_apis.dart';
import '../../../utils/app_constants.dart';

// ignore: must_be_immutable
class CourseListScreen extends StatefulWidget {
  bool myCourses;
  int? categoryId;

  CourseListScreen({this.myCourses = false, this.categoryId});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  List<CourseListModel> courseList = [];
  List<CourseCategory> coursesType = [];
  late Future<List<CourseListModel>> future;
  String status = '';
  int selectedValue = 1;

  int mPage = 1;
  bool mIsLastPage = false;

  bool isError = false;
  bool isEmpty = false;
  int selectedCategory = 0;

  @override
  void initState() {
    typesOfCourses();
    future = getCourses();
    super.initState();
  }

  Future<void> typesOfCourses() async {
    appStore.setLoading(true);
    await getCourseCategory().then((value) {
      coursesType.addAll(value);
      coursesType.insert(0, CourseCategory(name: language.all));
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<List<CourseListModel>> getCourses() async {
    appStore.setLoading(true);

    if (widget.myCourses) {
      await getCourseList(page: mPage, myCourse: true, status: status).then((value) {
        if (mPage == 1) courseList.clear();
        mIsLastPage = value.length != PER_PAGE;
        courseList.addAll(value);
        setState(() {});

        appStore.setLoading(false);
      }).catchError((e) {
        isError = true;
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    } else {
      await getCourseList(page: mPage, categoryId: widget.categoryId).then((value) {
        if (mPage == 1) courseList.clear();
        mIsLastPage = value.length != PER_PAGE;
        courseList.addAll(value);
        setState(() {});
        appStore.setLoading(false);
      }).catchError((e) {
        isError = true;
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    }

    return courseList;
  }

  Future<void> onRefresh() async {
    isError = false;
    mPage = 1;
    future = getCourses();
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
    return AppScaffold(
      appBarTitle: widget.myCourses ? language.myCourses : language.courses,
      onBack: () {
        finish(context);
      },
      actions: [
        if (widget.myCourses)
          Theme(
            data: Theme.of(context).copyWith(useMaterial3: false),
            child: PopupMenuButton(
              enabled: !appStore.isLoading,
              position: PopupMenuPosition.under,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
              onSelected: (val) async {
                if (val == 1) {
                  status = '';
                } else if (val == 2) {
                  status = CourseStatus.inProgress;
                } else if (val == 3) {
                  status = CourseStatus.passed;
                } else {
                  status = CourseStatus.failed;
                }

                if (selectedValue != val) {
                  onRefresh();
                } else {
                  //
                }

                selectedValue = val.toString().toInt();
              },
              icon: Icon(Icons.more_vert, color: context.iconColor),
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(
                  value: 1,
                  child: Text(language.all, style: primaryTextStyle()),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text(language.inProgress, style: primaryTextStyle()),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text(language.passed, style: primaryTextStyle()),
                ),
                PopupMenuItem(
                  value: 4,
                  child: Text(language.failed, style: primaryTextStyle()),
                ),
              ],
            ),
          )
        else
          TextButton(
            onPressed: () {
              CourseListScreen(myCourses: true).launch(context);
            },
            child: Text(language.myCourses, style: primaryTextStyle(color: context.primaryColor)),
          ),
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        color: appColorPrimary,
        child: FutureBuilder<List<CourseListModel>>(
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
                if (widget.myCourses) {
                  isEmpty = true;
                  return EmptyMyCourseComponent().center();
                } else {
                  return Column(
                    children: [
                      if (!widget.myCourses)
                        HorizontalList(
                          itemCount: coursesType.length,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          itemBuilder: (context, index) {
                            CourseCategory item = coursesType[index];
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: selectedCategory == index ? context.primaryColor : context.cardColor,
                                borderRadius: BorderRadius.all(radiusCircular()),
                              ),
                              child: Text(
                                parseHtmlString(item.name.validate().capitalizeFirstLetter()),
                                style: boldTextStyle(size: 14, color: selectedCategory == index ? context.cardColor : context.primaryColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ).onTap(
                              () {
                                mPage = 1;
                                selectedCategory = index;
                                setState(() {});
                                widget.myCourses = false;
                                widget.categoryId = item.id;
                                getCourses();
                              },
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            );
                          },
                        ),
                      SizedBox(
                        height: context.height() * 0.74,
                        child: NoDataWidget(
                          imageWidget: NoDataLottieWidget(),
                          title: isError ? language.somethingWentWrong : language.noDataFound,
                          onRetry: () {
                            onRefresh();
                          },
                          retryText: '   ${language.clickToRefresh}   ',
                        ),
                      ),
                    ],
                  ).center();
                }
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      if (!widget.myCourses)
                        HorizontalList(
                          itemCount: coursesType.length,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          itemBuilder: (context, index) {
                            CourseCategory item = coursesType[index];
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: selectedCategory == index ? context.primaryColor : context.cardColor,
                                borderRadius: BorderRadius.all(radiusCircular()),
                              ),
                              child: Text(
                                parseHtmlString(item.name.validate().capitalizeFirstLetter()),
                                style: boldTextStyle(size: 14, color: selectedCategory == index ? context.cardColor : context.primaryColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ).onTap(
                              () {
                                mPage = 1;
                                selectedCategory = index;
                                setState(() {});
                                widget.myCourses = false;
                                widget.categoryId = item.id;
                                getCourses();
                              },
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            );
                          },
                        ),
                      AnimatedListView(
                        slideConfiguration: SlideConfiguration(
                          delay: 80.milliseconds,
                          verticalOffset: 300,
                        ),
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 50),
                        itemCount: courseList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          CourseListModel data = courseList[index];
                          return CourseCardComponent(course: data).paddingSymmetric(vertical: 8);
                        },
                        onNextPage: () {
                          if (!mIsLastPage) {
                            mPage++;
                            future = getCourses();
                          }
                        },
                      ),
                    ],
                  ),
                );
              }
            }
            return Offstage();
          },
        ),
      ),
    );
  }
}
