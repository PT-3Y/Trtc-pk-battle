import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/lms_common_models/section.dart';
import 'package:socialv/screens/lms/screens/lesson_screen.dart';
import 'package:socialv/screens/lms/screens/quiz_screen.dart';
import 'package:socialv/utils/app_constants.dart';

class CurriculumTabComponent extends StatefulWidget {
  final List<Section>? sections;
  final bool showCheck;
  final VoidCallback? callback;
  final bool isEnrolled;

  CurriculumTabComponent({this.sections, this.showCheck = false, this.callback, required this.isEnrolled});

  @override
  State<CurriculumTabComponent> createState() => _CurriculumTabComponentState();
}

class _CurriculumTabComponentState extends State<CurriculumTabComponent> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sections.validate().isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.sections.validate().length,
        itemBuilder: (ctx, index) {
          Section section = widget.sections.validate()[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(section.title.validate(), style: boldTextStyle()),
              16.height,
              Wrap(
                children: section.items.validate().map((e) {
                  int i = section.items.validate().indexOf(e);

                  return InkWell(
                    onTap: () {
                      if (e.type == CourseType.lp_lesson) {
                        LessonScreen(
                          onLessonComplete: () {
                            e.graduation = CourseStatus.passed;
                            e.status = CourseStatus.completed;
                            setState(() {});
                          },
                          lessonId: e.id.validate(),
                          isEnrolled: widget.isEnrolled,
                          isLocked: e.locked.validate(),
                        ).launch(context).then((value) {
                          if (value ?? false) widget.callback?.call();
                        });
                      } else if (e.type == CourseType.lp_quiz) {
                        QuizScreen(
                          quizId: e.id.validate(),
                          isLocked: e.locked.validate(),
                          completeQuiz: (bool val) {
                            if (val) {
                              e.graduation = CourseStatus.passed;
                              e.status = CourseStatus.completed;
                              setState(() {});
                            } else {
                              e.graduation = CourseStatus.failed;
                              e.status = CourseStatus.completed;
                              setState(() {});
                            }
                          },
                        ).launch(context).then((value) {
                          if (value ?? false) widget.callback?.call();
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${i + 1}. ${e.title.validate()}',
                                style: primaryTextStyle(),
                              ).expand(),
                              Image.asset(ic_preview, color: context.primaryColor, height: 18, width: 18, fit: BoxFit.cover).paddingSymmetric(vertical: 4),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          12.height,
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(Icons.access_time, color: context.iconColor, size: 20),
                              8.width,
                              Text(e.duration.validate(), style: secondaryTextStyle()).expand(),
                              if (e.status == CourseStatus.completed && e.graduation == CourseStatus.passed) Icon(Icons.check, color: appGreenColor, size: 20),
                              if (e.status == CourseStatus.completed && e.graduation == CourseStatus.failed) Image.asset(ic_close, color: Colors.red, height: 14, fit: BoxFit.cover),
                              if (e.locked.validate()) Icon(Icons.lock, color: appGreenColor, size: 14),
                            ],
                          ),
                          if (widget.showCheck)
                            InkWell(
                              child: Container(
                                child: Text(language.preview, style: primaryTextStyle(color: Colors.white, size: 14)),
                                decoration: BoxDecoration(color: context.primaryColor, borderRadius: radius(commonRadius)),
                                margin: EdgeInsets.all(14),
                                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                              ).center(),
                              onTap: () {
                                if (e.type == CourseType.lp_lesson) {
                                  LessonScreen(
                                    onLessonComplete: () {
                                      e.graduation = CourseStatus.passed;
                                      e.status = CourseStatus.completed;
                                      setState(() {});
                                    },
                                    lessonId: e.id.validate(),
                                    isEnrolled: widget.isEnrolled,
                                    isLocked: e.locked.validate(),
                                  ).launch(context).then((value) {
                                    if (value ?? false) widget.callback?.call();
                                  });
                                } else if (e.type == CourseType.lp_quiz) {
                                  QuizScreen(
                                    quizId: e.id.validate(),
                                    isLocked: e.locked.validate(),
                                    completeQuiz: (bool val) {
                                      if (val) {
                                        e.graduation = CourseStatus.passed;
                                        e.status = CourseStatus.completed;
                                        setState(() {});
                                      } else {
                                        e.graduation = CourseStatus.failed;
                                        e.status = CourseStatus.completed;
                                        setState(() {});
                                      }
                                    },
                                  ).launch(context).then((value) {
                                    if (value ?? false) widget.callback?.call();
                                  });
                                }
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              16.height,
            ],
          );
        },
      );
    } else {
      return NoDataWidget(
        imageWidget: NoDataLottieWidget(),
        title: language.noDataFound,
      ).center();
    }
  }
}
