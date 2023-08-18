import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/lms_rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';

class WriteCourseReview extends StatefulWidget {
  final int courseId;
  final VoidCallback? callback;

  const WriteCourseReview({required this.courseId, this.callback});

  @override
  State<WriteCourseReview> createState() => _WriteCourseReviewState();
}

class _WriteCourseReviewState extends State<WriteCourseReview> {
  final courseReviewFormKey = GlobalKey<FormState>();

  TextEditingController content = TextEditingController();
  TextEditingController title = TextEditingController();

  double selectedRating = 0;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height() * 0.7,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
              ),
              8.height,
              Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, right: 16, left: 16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: courseReviewFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        30.height,
                        Text('${language.writeReview}', style: boldTextStyle()),
                        16.height,
                        AppTextField(
                          controller: title,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          textFieldType: TextFieldType.NAME,
                          textStyle: boldTextStyle(),
                          isValidationRequired: true,
                          decoration: inputDecorationFilled(context, fillColor: context.scaffoldBackgroundColor, label: language.title),
                          onFieldSubmitted: (text) {
                            //addReview();
                          },
                        ),
                        16.height,
                        AppTextField(
                          controller: content,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          textFieldType: TextFieldType.MULTILINE,
                          textStyle: boldTextStyle(),
                          decoration: inputDecorationFilled(context, fillColor: context.scaffoldBackgroundColor, label: language.content),
                          minLines: 5,
                          onFieldSubmitted: (text) {
                            //addReview();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return language.pleaseEnterDescription;
                            }
                            return null;
                          },
                        ),
                        16.height,
                        Text(language.rating, style: primaryTextStyle()),
                        14.height,
                        RatingBarWidget(
                          onRatingChanged: (rating) {
                            selectedRating = rating;
                            setState(() {});
                          },
                          activeColor: Colors.amber,
                          inActiveColor: Colors.amber,
                          rating: selectedRating,
                          size: 20,
                          allowHalfRating: false,
                        ),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            appButton(
                              color: context.cardColor,
                              shapeBorder: RoundedRectangleBorder(
                                borderRadius: radius(defaultAppButtonRadius),
                                side: BorderSide(color: context.dividerColor),
                              ),
                              width: context.width() / 2 - 20,
                              context: context,
                              text: language.cancel.capitalizeFirstLetter(),
                              textStyle: boldTextStyle(),
                              onTap: () {
                                finish(context);
                              },
                            ),
                            appButton(
                              width: context.width() / 2 - 20,
                              context: context,
                              text: language.submit.capitalizeFirstLetter(),
                              onTap: () {
                                if (courseReviewFormKey.currentState!.validate()) {
                                  courseReviewFormKey.currentState!.save();
                                  hideKeyboard(context);
                                  finish(context);
                                  ifNotTester(() async {
                                    appStore.setLoading(true);

                                    await submitCourseReview(
                                      courseId: widget.courseId,
                                      content: content.text,
                                      title: title.text,
                                      rating: selectedRating.toInt(),
                                    ).then((value) async {
                                      toast(value.message);
                                      appStore.setLoading(true);
                                      widget.callback?.call();
                                    }).catchError((e) {
                                      appStore.setLoading(false);
                                      toast(e.toString());
                                    });
                                  });
                                } else {
                                  appStore.setLoading(false);
                                }
                              },
                            ),
                          ],
                        ),
                        50.height,
                      ],
                    ),
                  ),
                ),
              ).expand(flex: 1),
            ],
          ),
          Observer(builder: (_) => LoadingWidget().center().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
