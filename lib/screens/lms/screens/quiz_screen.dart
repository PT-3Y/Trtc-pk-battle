import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/quiz_answers.dart';
import 'package:socialv/models/lms/quiz_model.dart';
import 'package:socialv/network/lms_rest_apis.dart';
import 'package:socialv/screens/lms/components/finish_quiz_component.dart';
import 'package:socialv/screens/lms/components/locked_content_widget.dart';
import 'package:socialv/screens/lms/components/quiz_component.dart';
import 'package:socialv/screens/lms/components/start_quiz_component.dart';
import 'package:socialv/utils/app_constants.dart';

class QuizScreen extends StatefulWidget {
  final int quizId;
  final bool isLocked;
  final Function(bool) completeQuiz;

  QuizScreen({required this.quizId, this.isLocked = false, required this.completeQuiz});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  QuizModel quiz = QuizModel();
  bool isError = false;
  bool isFetched = false;
  List<Answers> answers = [];

  bool isChanged = false;

  bool isReviewQuiz = false;
  List<QuestionAnsweresModel> reviewAnswers = [];

  @override
  void initState() {
    super.initState();

    if (!widget.isLocked.validate()) getQuiz();
  }

  Future<void> getQuiz() async {
    appStore.setLoading(true);
    await getQuizById(quizId: widget.quizId).then((value) async {
      quiz = value;
      isFetched = true;

      if (value.results!.status.validate() == CourseStatus.started) {
        if (!lmsStore.quizList.any((element) => element.quizId == widget.quizId)) {
          value.questions.validate().forEach((e) {
            answers.add(Answers(questionId: e.id.validate().toString()));
          });

          lmsStore.quizList.add(QuizAnswers(
            quizId: widget.quizId,
            answers: answers,
            startQuizTime: DateTime.now().toString(),
            isHours: quiz.duration.validate().split(' ').last == 'hours',
          ));

          await setValue(SharePreferencesKey.LMS_QUIZ_LIST, jsonEncode(lmsStore.quizList));
        }
      }

      log('lmsStore: ${lmsStore.quizList.length}');

      if (value.results!.results != null) {
        if (value.results!.results!.graduation.validate() == CourseStatus.passed) {
          widget.completeQuiz(true);
        } else {
          widget.completeQuiz(false);
        }
      }

      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      setState(() {});
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
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
                children: [
                  if (quiz.results!.status.validate().isEmpty)
                    StartQuizComponent(
                      quiz: quiz,
                      callback: () {
                        getQuiz();
                      },
                    ),
                  if (quiz.results!.status.validate() == CourseStatus.started || isReviewQuiz)
                    QuizComponent(
                      quiz: quiz,
                      callback: () {
                        isChanged = true;

                        if (isReviewQuiz) {
                          isReviewQuiz = false;
                          setState(() {});
                        } else {
                          getQuiz();
                        }
                      },
                      answers: reviewAnswers,
                      isReviewQuiz: isReviewQuiz,
                    ),
                  if (quiz.results!.status.validate() == CourseStatus.completed && !isReviewQuiz)
                    FinishQuizComponent(
                      quiz: quiz,
                      onReview: (ans) {
                        isReviewQuiz = true;
                        reviewAnswers = ans;
                        setState(() {});
                      },
                      onRetake: () {
                        isChanged = true;
                        isReviewQuiz = false;
                        reviewAnswers.clear();
                        getQuiz();
                      },
                    ),
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
