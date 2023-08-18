import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models.dart';
import 'package:socialv/models/lms/course_list_model.dart';
import 'package:socialv/network/lms_rest_apis.dart';
import 'package:socialv/screens/lms/components/course_card_component.dart';
import 'package:socialv/screens/lms/components/course_includes_tab_component.dart';
import 'package:socialv/screens/lms/components/curriculam_tab_component.dart';
import 'package:socialv/screens/lms/components/faq_tab_component.dart';
import 'package:socialv/screens/lms/components/instructor_tab_component.dart';
import 'package:socialv/screens/lms/components/overview_tab_component.dart';
import 'package:socialv/screens/lms/components/review_tab_component.dart';
import 'package:socialv/screens/lms/components/start_course_widget.dart';
import 'package:socialv/screens/lms/screens/buy_course_screen.dart';
import 'package:socialv/screens/lms/screens/course_sections_screen.dart';
import 'package:socialv/utils/app_constants.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;

  CourseDetailScreen({required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  CourseListModel? course;

  late Future<CourseListModel> future;

  List<DrawerModel> tabsList = getCourseTabs();
  int selectedTabIndex = 0;

  bool isError = false;

  @override
  void initState() {
    future = getCourseDetail();
    super.initState();
  }

  Future<CourseListModel> getCourseDetail({bool isCourseStarted = false}) async {
    appStore.setLoading(true);

    await getCourseById(courseId: widget.courseId).then((value) {
      course = value;
      setState(() {});

      appStore.setLoading(false);

      /// todo: check
      if (isCourseStarted) {
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                backgroundColor: context.cardColor,
                shape: RoundedRectangleBorder(borderRadius: radius()),
                child: StartCourseWidget(callback: () {
                  CourseSectionsScreen(
                    sections: course!.sections,
                    isEnrolled: course!.course_data!.status == CourseStatus.enrolled,
                    callback: () {
                      future = getCourseDetail();
                    },
                  ).launch(context);
                }),
              );
            });
      }
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return course!;
  }

  Widget getTabWidget() {
    if (selectedTabIndex == 1) {
      return OverviewTabComponent(overviewContent: course!.content);
    } else if (selectedTabIndex == 2) {
      return CurriculumTabComponent(
        sections: course!.sections,
        isEnrolled: course!.course_data!.status == CourseStatus.enrolled,
        callback: () {
          onRefresh();
        },
      );
    } else if (selectedTabIndex == 3) {
      return InstructorTabComponent(instructor: course!.instructor);
    } else if (selectedTabIndex == 4) {
      return FaqTabComponent(
        faqs: course!.meta_data!.lp_faqs.validate(),
      );
    } else if (selectedTabIndex == 5) {
      return ReviewTabComponent(courseId: widget.courseId);
    } else {
      return CourseIncludesTabComponent(
        metaData: course!.meta_data!,
        courseData: course!.course_data!,
        requirements: course!.meta_data!.lp_requirements.validate(),
        features: course!.meta_data!.lp_key_features.validate(),
        audiences: course!.meta_data!.lp_target_audiences.validate(),
      );
    }
  }

  Future<void> onRefresh() async {
    isError = false;
    future = getCourseDetail();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: AppScaffold(
        onBack: () {
          if (appStore.isLoading) appStore.setLoading(false);
          finish(context);
        },
        appBarTitle: language.courseDetail,
        child: FutureBuilder<CourseListModel>(
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
              if (snap.data == null) {
                return NoDataWidget(
                  imageWidget: NoDataLottieWidget(),
                  title: isError ? language.somethingWentWrong : language.noDataFound,
                  onRetry: () {
                    onRefresh();
                  },
                  retryText: '   ${language.clickToRefresh}   ',
                ).center();
              } else {
                if (course != null) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        CourseCardComponent(course: course!).paddingSymmetric(horizontal: 16, vertical: 16),
                        if (course!.course_data!.status == CourseStatus.enrolled && course!.course_data!.graduation == CourseStatus.inProgress)
                          Row(
                            children: [
                              Text('Course Results: ${course!.course_data!.result!.result.validate()}%', style: boldTextStyle()).paddingSymmetric(horizontal: 16),
                              SizedBox(
                                width: context.width() / 3,
                                height: 14,
                                child: LinearProgressIndicator(
                                  color: context.primaryColor,
                                  backgroundColor: appStore.isDarkMode ? bodyDark.withOpacity(0.4) : bodyWhite.withOpacity(0.4),
                                  value: course!.course_data!.result!.result.validate() / 100,
                                  minHeight: 14,
                                ).cornerRadiusWithClipRRect(defaultRadius),
                              ),
                            ],
                          ),
                        if (course!.course_data!.status == CourseStatus.enrolled)
                          appButton(
                            width: context.width() / 2 - 20,
                            context: context,
                            text: language.lblContinue,
                            onTap: () {
                              CourseSectionsScreen(
                                sections: course!.sections,
                                isEnrolled: course!.course_data!.status == CourseStatus.enrolled,
                                callback: () {
                                  future = getCourseDetail(isCourseStarted: true);
                                },
                              ).launch(context);
                            },
                          ).paddingSymmetric(vertical: 16)
                        else if (course!.course_data!.status.validate().isEmpty && course!.price_rendered == 'Free')
                          appButton(
                            width: context.width() / 2 - 20,
                            context: context,
                            text: language.startNow,
                            onTap: () {
                              ifNotTester(() {
                                appStore.setLoading(true);
                                enrollCourse(courseId: widget.courseId).then((value) {
                                  course!.course_data!.status = CourseStatus.enrolled;
                                  onRefresh();

                                  //toast(value.message);
                                }).catchError((e) {
                                  appStore.setLoading(false);

                                  toast(e.toString());
                                });
                              });
                            },
                          ).paddingSymmetric(vertical: 16)
                        else if (course!.can_retake.validate())
                          appButton(
                            width: context.width() / 2 - 20,
                            context: context,
                            text: '${language.retake} (${course!.ratake_count.validate() - course!.rataken.validate()})',
                            onTap: () {
                              ifNotTester(() {
                                appStore.setLoading(true);
                                retakeCourse(courseId: widget.courseId).then((value) {
                                  course!.course_data!.status = CourseStatus.enrolled;
                                  onRefresh();
                                  toast(value.message);
                                }).catchError((e) {
                                  appStore.setLoading(false);

                                  toast(e.toString());
                                });
                              });
                            },
                          ).paddingSymmetric(vertical: 16)
                        else if (course!.course_data!.status.validate().isEmpty && course!.price_rendered != 'Free')
                          if (course!.in_cart.validate())
                            Container(
                              width: context.width(),
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: appGreenColor.withAlpha(20),
                                border: Border(left: BorderSide(color: appGreenColor, width: 2)),
                              ),
                              padding: EdgeInsets.all(14),
                              child: Text('${language.yourOrderIsWaitingFor} ${course!.order_status.validate()}', style: primaryTextStyle(color: appGreenColor)),
                            )
                          else
                            appButton(
                              width: context.width() / 2 - 20,
                              context: context,
                              text: language.buyNow,
                              onTap: () {
                                BuyCourseScreen(
                                  courseImage: course!.image.validate(),
                                  courseName: course!.name.validate(),
                                  coursePriseRendered: course!.price_rendered.validate(),
                                  coursePrise: course!.price.validate(),
                                  courseId: course!.id.validate(),
                                  callback: () {
                                    onRefresh();
                                  },
                                ).launch(context);
                              },
                            ).paddingSymmetric(vertical: 16)
                        else if (course!.course_data!.status.validate() == CourseStatus.finished && course!.course_data!.graduation == CourseStatus.passed)
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: blueTickColor.withAlpha(20),
                              border: Border(left: BorderSide(color: blueTickColor, width: 2)),
                            ),
                            child: Text(language.youHaveFinishedThisCourse, style: primaryTextStyle(color: blueTickColor)),
                          )
                        else
                          Offstage(),
                        if (course!.can_finish.validate())
                          appButton(
                            width: context.width() / 2 - 20,
                            context: context,
                            text: language.finishCourse,
                            onTap: () {
                              ifNotTester(() {
                                showConfirmDialogCustom(
                                  context,
                                  onAccept: (c) {
                                    ifNotTester(() {
                                      appStore.setLoading(true);
                                      finishCourse(courseId: course!.id.validate()).then((value) {
                                        appStore.setLoading(false);
                                        onRefresh();
                                      }).catchError((e) {
                                        appStore.setLoading(false);
                                        toast(e.toString(), print: true);
                                      });
                                    });
                                  },
                                  dialogType: DialogType.CONFIRMATION,
                                  title: language.finishCourseConfirmation,
                                  positiveText: language.finish,
                                );
                              });
                            },
                          ),
                        16.height,
                        HorizontalList(
                          itemCount: tabsList.length,
                          itemBuilder: (ctx, index) {
                            DrawerModel tab = tabsList[index];
                            return GestureDetector(
                              onTap: () {
                                selectedTabIndex = index;
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedTabIndex == index ? context.primaryColor : context.scaffoldBackgroundColor,
                                  borderRadius: radius(commonRadius),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                                child: Text(
                                  tab.title.validate(),
                                  style: boldTextStyle(
                                    color: selectedTabIndex == index
                                        ? Colors.white
                                        : appStore.isDarkMode
                                            ? bodyDark
                                            : bodyWhite,
                                    size: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        getTabWidget(),
                      ],
                    ),
                  );
                } else {
                  return NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: isError ? language.somethingWentWrong : language.noDataFound,
                    onRetry: () {
                      onRefresh();
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center();
                }
              }
            }
            return Offstage();
          },
        ),
      ),
    );
  }
}
