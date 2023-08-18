import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/quiz_model.dart';
import 'package:socialv/network/lms_rest_apis.dart';
import 'package:socialv/screens/lms/components/fill_blanks_component.dart';
import 'package:socialv/screens/lms/components/single_choice_component.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class QuizComponent extends StatefulWidget {
  final QuizModel quiz;
  final VoidCallback callback;
  final List<QuestionAnsweresModel>? answers;
  final bool isReviewQuiz;

  const QuizComponent({required this.quiz, required this.callback, this.answers, required this.isReviewQuiz});

  @override
  State<QuizComponent> createState() => _QuizComponentState();
}

class _QuizComponentState extends State<QuizComponent> {
  PageController pageController = PageController();

  bool showInHours = false;

  Timer? timer;
  int startSeconds = 0;
  String timeToShow = "";
  int timeLeft = 0;

  int pageIndex = 1;

  @override
  void initState() {
    super.initState();

    if (!widget.isReviewQuiz) {
      lmsStore.quizList.forEach((element) {
        if (element.quizId == widget.quiz.id) {
          startSeconds = DateTime.now().difference(DateTime.parse(element.startQuizTime)).inSeconds;
        }

        if (widget.quiz.duration!.split(' ').last == 'minutes') {
          if (widget.quiz.duration!.split(' ').first.toInt() * 60 > startSeconds) {
            timeLeft = widget.quiz.duration!.split(' ').first.toInt() * 60 - startSeconds;
          } else {
            finishQuizFunc();
          }
        } else if (widget.quiz.duration!.split(' ').last == 'hours') {
          if (widget.quiz.duration!.split(' ').first.toInt() * 60 > startSeconds) {
            showInHours = true;
            timeLeft = (widget.quiz.duration!.split(' ').first.toInt() * 3600) - startSeconds;
          } else {
            finishQuizFunc();
          }
        } else {
          //
        }
      });

      startTimer();
    }
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (time) {
      timeLeft = timeLeft - 1;
      if (timeLeft == 0) {
        finishQuizFunc();
        timer!.cancel();
      }

      int hours = showInHours ? (timeLeft / 3600).floor().toInt() : 0;
      int minutes = ((timeLeft / 60) % 60).toInt();
      int seconds = (timeLeft % 60);

      if (showInHours) {
        timeToShow = hours.toString().padLeft(2, "0") + ':' + minutes.toString().padLeft(2, "0") + ":" + seconds.toString().padLeft(2, "0");
      } else {
        timeToShow = minutes.toString().padLeft(2, "0") + ":" + seconds.toString().padLeft(2, "0");
      }

      setState(() {});
    });
  }

  Future<void> finishQuizFunc() async {
    ifNotTester(() {
      if (lmsStore.quizList.isNotEmpty) {
        appStore.setLoading(true);

        Map ans = {};

        lmsStore.quizList.first.answers.validate().forEach((element) {
          ans.putIfAbsent(element.questionId..validate(), () => element.value.validate());
        });

        Map request = {
          "id": lmsStore.quizList.firstWhere((element) => element.quizId == widget.quiz.id).quizId,
          "answered": ans,
        };

        finishQuiz(request: request).then((value) async {
          lmsStore.quizList.removeWhere((element) => element.quizId == widget.quiz.id);
          await setValue(SharePreferencesKey.LMS_QUIZ_LIST, jsonEncode(lmsStore.quizList));

          widget.callback.call();
          appStore.setLoading(false);
        }).catchError((e) {
          appStore.setLoading(false);

          toast(e.toString());
        });
      } else {
        log(lmsStore.quizList.length);
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    pageController.dispose();

    if (timer != null) timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(widget.quiz.name.validate(), style: boldTextStyle(size: 18)),
          16.height,
          Container(
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: radius(commonRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.primaryColor,
                    borderRadius: radiusOnly(topRight: commonRadius, topLeft: commonRadius),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${language.questions}:  $pageIndex/${widget.quiz.results!.results!.question_count.validate()}', style: primaryTextStyle(color: Colors.white)),
                      if (!widget.isReviewQuiz)
                        TextIcon(
                          text: timeToShow,
                          textStyle: primaryTextStyle(color: Colors.white),
                          prefix: cachedImage(ic_timer, height: 18, width: 18, fit: BoxFit.cover, color: Colors.white),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: context.height() * 0.55,
                  width: context.width() - 64,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PageView.builder(
                        itemCount: widget.quiz.questions.validate().length,
                        itemBuilder: (BuildContext context, int index) {
                          Question question = widget.quiz.questions.validate()[index];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${index + 1}. ' + question.title.validate(), style: primaryTextStyle()),
                              16.height,
                              if (question.type == QuestionType.single_choice || question.type == QuestionType.true_or_false)
                                SingleChoiceComponent(
                                  options: question.options.validate(),
                                  questionId: question.id.validate(),
                                  quizId: widget.quiz.id.validate(),
                                  answered: widget.answers.validate().isNotEmpty ? widget.answers.validate()[index] : null,
                                  isReviewQuiz: widget.isReviewQuiz,
                                ),
                              if (question.type == QuestionType.fill_in_blanks)
                                FillBlanksComponent(
                                  options: question.options.validate(),
                                  isReviewQuiz: widget.isReviewQuiz,
                                  answered: widget.answers.validate().isNotEmpty ? widget.answers.validate()[index] : null,
                                  questionId: question.id.validate(),
                                  quizId: widget.quiz.id.validate(),
                                ),
                              if (widget.isReviewQuiz && widget.answers.validate().isNotEmpty)
                                Container(
                                  decoration: BoxDecoration(color: widget.answers.validate()[index].correct.validate() ? appGreenColor : appOrangeColor, borderRadius: radius(commonRadius)),
                                  child: Text(widget.answers.validate()[index].correct.validate() ? language.correct : language.incorrect, style: primaryTextStyle(color: Colors.white)),
                                  margin: EdgeInsets.only(top: 12),
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                ),
                            ],
                          ).paddingAll(16);
                        },
                        onPageChanged: (i) {
                          pageIndex = i + 1;
                          setState(() {});
                        },
                        controller: pageController,
                      ),
                      Positioned(
                        bottom: 16,
                        child: Row(
                          children: [
                            if (pageIndex > 1)
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  pageController.previousPage(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.linear,
                                  );
                                },
                                child: Container(
                                  child: Text(language.prev, style: secondaryTextStyle()),
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: context.scaffoldBackgroundColor,
                                    border: Border.all(color: context.primaryColor),
                                    borderRadius: radius(commonRadius),
                                  ),
                                ),
                              ),
                            16.width,
                            Container(
                              height: 30,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.quiz.questions.validate().length,
                                itemBuilder: (ctx, index) {
                                  if ((index + 1) == pageIndex)
                                    return Container(
                                      margin: EdgeInsets.symmetric(horizontal: 4),
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      decoration: BoxDecoration(color: context.primaryColor, shape: BoxShape.circle),
                                      child: Text((index + 1).toString(), style: secondaryTextStyle(color: Colors.white)).center(),
                                    );
                                  else
                                    return Icon(Icons.circle, color: context.primaryColor, size: 8).paddingSymmetric(horizontal: 2);
                                },
                              ),
                            ),
                            16.width,
                            if (pageIndex < widget.quiz.questions.validate().length)
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  pageController.nextPage(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.linear,
                                  );
                                },
                                child: Container(
                                  child: Text(language.next, style: secondaryTextStyle()),
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: context.scaffoldBackgroundColor,
                                    border: Border.all(color: context.primaryColor),
                                    borderRadius: radius(commonRadius),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                appButton(
                  width: context.width() / 2 - 20,
                  context: context,
                  text: widget.isReviewQuiz ? language.result : language.finishQuiz,
                  onTap: () {
                    if (widget.isReviewQuiz) {
                      widget.callback.call();
                    } else {
                      showConfirmDialogCustom(
                        context,
                        onAccept: (c) {
                          finishQuizFunc();
                        },
                        dialogType: DialogType.CONFIRMATION,
                        title: language.finishQuizConfirmation,
                        positiveText: language.yes,
                      );
                    }
                  },
                ).paddingSymmetric(vertical: 16)
              ],
            ),
          ),
        ],
      ).paddingAll(16),
    );
  }
}
