import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/quiz_answers.dart';
import 'package:socialv/models/lms/quiz_model.dart';
import 'package:socialv/network/lms_rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';
import 'package:socialv/utils/html_widget.dart';

class StartQuizComponent extends StatefulWidget {
  final QuizModel quiz;
  final VoidCallback? callback;

  const StartQuizComponent({required this.quiz, this.callback});

  @override
  State<StartQuizComponent> createState() => _StartQuizComponentState();
}

class _StartQuizComponentState extends State<StartQuizComponent> {
  QuizModel quiz = QuizModel();
  List<Answers> ansList = [];

  @override
  void initState() {
    super.initState();

    quiz = widget.quiz;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(quiz.name.validate(), style: boldTextStyle(size: 18)),
          HtmlWidget(postContent: quiz.content.validate()),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  cachedImage(ic_time_filled, height: 16, width: 16, fit: BoxFit.cover, color: context.primaryColor),
                  4.width,
                  Text('${language.duration}: ${quiz.duration.validate()}', style: secondaryTextStyle()),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 16,
                    color: context.primaryColor,
                  ),
                  4.width,
                  Text('${language.passingGrade}: ${quiz.meta_data!.lp_passing_grade.validate()}', style: secondaryTextStyle()),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  cachedImage(ic_quiz, height: 16, width: 16, fit: BoxFit.cover, color: context.primaryColor),
                  4.width,
                  Text('${language.questions}: ${quiz.questions.validate().length}', style: secondaryTextStyle()),
                ],
              ),
            ],
          ),
          16.height,
          appButton(
            width: context.width() / 2 - 20,
            context: context,
            text: language.start,
            onTap: () {
              ifNotTester(() {
                appStore.setLoading(true);

                startQuiz(quizId: quiz.id.validate()).then((value) async {
                  value.results!.question_ids.validate().forEach((element) {
                    ansList.add(Answers(questionId: element));
                  });

                  lmsStore.quizList.add(QuizAnswers(
                    quizId: quiz.id.validate(),
                    answers: ansList,
                    startQuizTime: DateTime.now().toString(),
                    isHours: quiz.duration.validate().split(' ').last == 'hours',
                  ));

                  await setValue(SharePreferencesKey.LMS_QUIZ_LIST, jsonEncode(lmsStore.quizList));

                  widget.callback?.call();

                  appStore.setLoading(false);
                }).catchError((e) {
                  appStore.setLoading(false);
                  toast(e.toString(), print: true);
                });
              });
            },
          ).center()
        ],
      ).paddingAll(16),
    );
  }
}
