import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/quiz_model.dart';

import '../../../utils/app_constants.dart';

class SingleChoiceComponent extends StatefulWidget {
  final List<Option> options;
  final int quizId;
  final int questionId;
  final QuestionAnsweresModel? answered;
  final bool isReviewQuiz;

  const SingleChoiceComponent({required this.options, required this.quizId, required this.questionId, this.answered, required this.isReviewQuiz});

  @override
  State<SingleChoiceComponent> createState() => _SingleChoiceComponentState();
}

class _SingleChoiceComponentState extends State<SingleChoiceComponent> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();

    if (widget.answered != null && widget.answered!.answered.validate().isNotEmpty) {
      selectedIndex = widget.options.indexWhere((element) => element.value.validate() == widget.answered!.answered.validate());
      setState(() {});
    } else if (lmsStore.quizList.isNotEmpty) {
      int index = lmsStore.quizList.indexWhere((element) => element.quizId == widget.quizId);

      int x = lmsStore.quizList[index].answers.validate().indexWhere((element) => element.questionId.validate().toInt() == widget.questionId);

      if (lmsStore.quizList[index].answers.validate()[x].value.validate().isNotEmpty) {
        selectedIndex = widget.options.indexWhere((element) => element.value == lmsStore.quizList[index].answers.validate()[x].value.validate());
        setState(() {});
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, i) {
        Option option = widget.options[i];

        return InkWell(
          onTap: () {
            if (!widget.isReviewQuiz) {
              selectedIndex = i;
              setState(() {});

              if (lmsStore.quizList.isNotEmpty) {
                int index = lmsStore.quizList.indexWhere((element) => element.quizId == widget.quizId);

                int x = lmsStore.quizList[index].answers.validate().indexWhere((element) => element.questionId.validate().toInt() == widget.questionId);
                lmsStore.quizList[index].answers.validate()[x].value = option.value.validate();

                setValue(SharePreferencesKey.LMS_QUIZ_LIST, jsonEncode(lmsStore.quizList));
              }
            }
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            decoration: widget.answered != null
                ? BoxDecoration(
                    border: widget.answered!.options![i].is_true == 'yes' ? Border.all(color: appGreenColor) : null,
                    borderRadius: radius(commonRadius),
                  )
                : BoxDecoration(),
            padding: EdgeInsets.only(left: 8, right: 100, top: 8, bottom: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selectedIndex == i ? Icons.check_circle_rounded : Icons.circle_outlined,
                  color: selectedIndex == i
                      ? appGreenColor
                      : appStore.isDarkMode
                          ? bodyDark
                          : bodyWhite,
                ),
                16.width,
                Text(option.title.validate(), style: secondaryTextStyle(size: 16), maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
              ],
            ),
          ),
        );
      },
      itemCount: widget.options.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}
