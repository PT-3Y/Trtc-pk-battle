import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/quiz_answers.dart';
import 'package:socialv/models/lms/quiz_model.dart';
import 'package:socialv/network/lms_rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class FinishQuizComponent extends StatefulWidget {
  final QuizModel quiz;
  final Function(List<QuestionAnsweresModel>)? onReview;
  final VoidCallback? onRetake;

  FinishQuizComponent({required this.quiz, this.onReview, this.onRetake});

  @override
  State<FinishQuizComponent> createState() => _FinishQuizComponentState();
}

class _FinishQuizComponentState extends State<FinishQuizComponent> {
  List<Answers> ansList = [];

  List<QuestionAnsweresModel> answered = [];

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(color: context.cardColor),
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.quiz.name.validate(), style: boldTextStyle(size: 18)),
              16.height,
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      color: widget.quiz.results!.results!.graduation.validate() == CourseStatus.failed ? Colors.red : appGreenColor,
                      backgroundColor: appStore.isDarkMode ? bodyDark.withOpacity(0.4) : bodyWhite.withOpacity(0.4),
                      strokeWidth: 8,
                      value: widget.quiz.results!.results!.result.validate() / 100,
                    ),
                  ),
                  Text('${widget.quiz.results!.results!.result.validate()}%', style: boldTextStyle(size: 16)),
                ],
              ).center(),
              Container(
                width: context.width() - 32,
                margin: EdgeInsets.symmetric(vertical: 16),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.quiz.results!.results!.graduation.validate() == CourseStatus.failed ? Colors.red : appGreenColor,
                  borderRadius: radius(commonRadius),
                ),
                child: TextIcon(
                  spacing: 8,
                  text: widget.quiz.results!.results!.graduation.validate().capitalizeFirstLetter(),
                  textStyle: boldTextStyle(color: Colors.white),
                  suffix: widget.quiz.results!.results!.graduation.validate() == CourseStatus.failed ? cachedImage(ic_close, height: 14, width: 14, fit: BoxFit.cover, color: Colors.white) : Icon(Icons.check, color: Colors.white),
                ).center(),
              ),
              Text('${language.passingGrade}: ${widget.quiz.results!.results!.passing_grade.validate()}', style: secondaryTextStyle(size: 16)),
              10.height,
              Text('${language.timeSpend}: ${widget.quiz.results!.results!.time_spend.validate()}', style: secondaryTextStyle(size: 16)),
              10.height,
              Text('${language.points} ${widget.quiz.results!.results!.user_mark.validate()} / ${widget.quiz.results!.results!.mark.validate()}', style: secondaryTextStyle(size: 16)),
              10.height,
              Text('${language.questions}: ${widget.quiz.results!.results!.question_count.validate()}', style: secondaryTextStyle(size: 16)),
              10.height,
              Text('${language.correct}: ${widget.quiz.results!.results!.question_correct.validate()}', style: secondaryTextStyle(size: 16)),
              10.height,
              Text('${language.questionsWrong} ${widget.quiz.results!.results!.question_wrong.validate()}', style: secondaryTextStyle(size: 16)),
              10.height,
              Text('${language.questionsAttempted} ${widget.quiz.results!.results!.question_answered.validate()}', style: secondaryTextStyle(size: 16)),
              10.height,
              Text('${language.questionsSkipped} ${widget.quiz.results!.results!.question_empty.validate()}', style: secondaryTextStyle(size: 16)),
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (widget.quiz.results!.retake_count.validate() != widget.quiz.results!.retaken.validate())
                    appButton(
                      width: context.width() / 2 - 50,
                      context: context,
                      text: '${language.retake} (${widget.quiz.results!.retake_count.validate() - widget.quiz.results!.retaken.validate()})',
                      onTap: () {
                        ifNotTester(() async {
                          appStore.setLoading(true);

                          startQuiz(quizId: widget.quiz.id.validate()).then((value) async {
                            value.results!.question_ids.validate().forEach((element) {
                              ansList.add(Answers(questionId: element));
                            });

                            lmsStore.quizList.add(QuizAnswers(
                              quizId: widget.quiz.id.validate(),
                              answers: ansList,
                              startQuizTime: DateTime.now().toString(),
                              isHours: widget.quiz.duration.validate().split(' ').last == 'hours',
                            ));

                            await setValue(SharePreferencesKey.LMS_QUIZ_LIST, jsonEncode(lmsStore.quizList));

                            widget.onRetake?.call();

                            appStore.setLoading(false);
                          }).catchError((e) {
                            appStore.setLoading(false);
                            toast(e.toString(), print: true);
                          });
                        });
                      },
                    ),
                  appButton(
                    width: context.width() / 2 - 50,
                    context: context,
                    text: language.review,
                    onTap: () {
                      ifNotTester(() {
                        answered.clear();

                        widget.quiz.results!.answered!.keys.map((e) => widget.quiz.results!.answered![e]).toList().forEach((element) {
                          answered.add(QuestionAnsweresModel.fromJson(element));
                        });

                        widget.onReview?.call(answered);
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        if (widget.quiz.results!.attempts.validate().isNotEmpty)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language.lastAttempts, style: boldTextStyle()),
              16.height,
              Table(
                children: [
                  TableRow(
                    children: [
                      Text(language.questions, style: secondaryTextStyle(), textAlign: TextAlign.center).center().paddingAll(4),
                      Text(language.timeSpend, style: secondaryTextStyle(), textAlign: TextAlign.center).center().paddingAll(4),
                      Text(language.marks, style: secondaryTextStyle(), textAlign: TextAlign.center).center().paddingAll(4),
                      Text(language.passingGrade, style: secondaryTextStyle(), textAlign: TextAlign.center).center().paddingAll(4),
                      Text(language.result, style: secondaryTextStyle(), textAlign: TextAlign.center).center().paddingAll(4),
                    ],
                  ),
                  ...widget.quiz.results!.attempts.validate().map((e) {
                    return TableRow(
                      children: [
                        Text('${e.question_answered}/${e.question_count}', style: secondaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis).center().paddingAll(4),
                        Text(e.time_spend.validate(), style: secondaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis).center().paddingAll(4),
                        Text('${e.user_mark}/${e.mark}', style: secondaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis).center().paddingAll(4),
                        Text(e.passing_grade.validate(), style: secondaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis).center().paddingAll(4),
                        Text(e.result.validate().toString(), style: secondaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis).center().paddingAll(4),
                      ],
                    );
                  }).toList(),
                ],
                border: TableBorder.all(color: appStore.isDarkMode ? bodyDark : bodyWhite, width: 1.5),
              ),
            ],
          ).paddingAll(16),
      ],
    );
  }
}
