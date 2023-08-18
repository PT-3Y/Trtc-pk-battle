import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/lesson_model.dart';
import 'package:socialv/network/lms_rest_apis.dart';
import 'package:socialv/screens/lms/components/locked_content_widget.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/html_widget.dart';

class LessonScreen extends StatefulWidget {
  final int lessonId;
  final bool isEnrolled;
  final bool isLocked;
  final VoidCallback onLessonComplete;

  const LessonScreen({required this.lessonId, required this.isEnrolled, required this.isLocked, required this.onLessonComplete});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  LessonModel lesson = LessonModel();
  bool isError = false;
  bool isFetched = false;
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    getLesson();
  }

  Future<void> getLesson() async {
    if (!widget.isLocked) {
      appStore.setLoading(true);
      await getLessonById(lessonId: widget.lessonId).then((value) {
        lesson = value;
        isFetched = true;
        setState(() {});
        appStore.setLoading(false);
      }).catchError((e) {
        isError = true;
        setState(() {});
        appStore.setLoading(false);
        toast('Error: ${e.toString()}');
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onBack: () {
        if (appStore.isLoading) appStore.setLoading(false);
        finish(context, isChanged);
      },
      child: Stack(
        children: [
          if (widget.isLocked) LockedContentWidget(),
          if (isFetched)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.name.validate(), style: boldTextStyle(size: 18)).paddingAll(16),
                  HtmlWidget(postContent: lesson.content.validate()).paddingAll(12),
                  if (widget.isEnrolled)
                    if (lesson.results!.status.validate() == CourseStatus.completed)
                      Container(
                        decoration: BoxDecoration(color: appGreenColor, borderRadius: radius(defaultAppButtonRadius)),
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        child: TextIcon(
                          spacing: 14,
                          text: language.completed,
                          textStyle: boldTextStyle(color: Colors.white),
                          suffix: Icon(Icons.check, color: Colors.white, size: 20),
                        ),
                      )
                    else
                      appButton(
                        color: appGreenColor,
                        width: context.width() / 2 - 20,
                        context: context,
                        text: language.complete,
                        onTap: () {
                          showConfirmDialogCustom(
                            context,
                            onAccept: (c) {
                              ifNotTester(() {
                                appStore.setLoading(true);
                                finishLesson(lessonId: widget.lessonId).then((value) {
                                  isChanged = true;
                                  appStore.setLoading(false);

                                  toast(value.message);

                                  widget.onLessonComplete.call();
                                  finish(context, isChanged);
                                }).catchError((e) {
                                  appStore.setLoading(false);
                                  toast(e.toString());
                                });
                              });
                            },
                            dialogType: DialogType.CONFIRMATION,
                            title: language.completeLessonConfirmation,
                            positiveText: language.yes,
                            negativeText: language.no,
                          );
                        },
                      ).paddingAll(16),
                ],
              ),
            ),
          if (isError && !widget.isLocked)
            NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: language.noTopicsFound,
            ),
        ],
      ),
    );
  }
}
