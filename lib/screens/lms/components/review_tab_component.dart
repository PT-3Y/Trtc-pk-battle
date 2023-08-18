import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/course_review_model.dart';
import 'package:socialv/network/lms_rest_apis.dart';
import 'package:socialv/screens/lms/components/write_course_review.dart';

import '../../../utils/app_constants.dart';

class ReviewTabComponent extends StatefulWidget {
  final int courseId;

  const ReviewTabComponent({Key? key, required this.courseId}) : super(key: key);

  @override
  State<ReviewTabComponent> createState() => _ReviewTabComponentState();
}

class _ReviewTabComponentState extends State<ReviewTabComponent> {
  CourseReviewModel snap = CourseReviewModel();
  List<SingleRatingItem> ratings = [];

  bool showLoading = true;
  bool isFetched = false;

  @override
  void initState() {
    super.initState();
    getReview();
  }

  Future<void> getReview() async {
    ratings.clear();
    showLoading = true;
    getCourseReviews(courseId: widget.courseId).then((value) {
      snap = value;
      isFetched = true;

      if (value.data!.items != null) {
        value.data!.items!.keys.map((e) => value.data!.items![e]).toList().forEach((element) {
          ratings.add(SingleRatingItem.fromJson(element));
        });
      }

      log('Ratings: ${ratings.length}');

      showLoading = false;

      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
      showLoading = false;

      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isFetched && !showLoading)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (snap.message.validate().isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: appGreenColor.withAlpha(20),
                    border: Border(left: BorderSide(color: appGreenColor, width: 2)),
                  ),
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.all(16),
                  child: Text(snap.message.validate(), style: primaryTextStyle(color: appGreenColor)),
                ),
              if (snap.data != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 150,
                      width: context.width() * 0.3,
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snap.data!.rated.validate(), style: boldTextStyle()),
                          8.height,
                          RatingBarWidget(
                            onRatingChanged: (x) {
                              //
                            },
                            activeColor: Colors.amber,
                            inActiveColor: Colors.amber,
                            rating: snap.data!.rated.validate().toDouble(),
                            size: 14,
                            allowHalfRating: true,
                            disable: true,
                          ),
                          8.height,
                          Text(language.total + ': ' + snap.data!.total.validate().toString(), style: secondaryTextStyle()),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                      padding: EdgeInsets.all(16),
                      width: context.width() * 0.5,
                      height: 150,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: ratings.map((e) {
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.rated.toString(), style: boldTextStyle()),
                              SizedBox(
                                width: 100,
                                height: 8,
                                child: LinearProgressIndicator(
                                  color: starColor,
                                  backgroundColor: appStore.isDarkMode ? bodyDark.withOpacity(0.4) : bodyWhite.withOpacity(0.4),
                                  value: e.percent_float.validate().round() / 100,
                                ).cornerRadiusWithClipRRect(defaultRadius),
                              ),
                              6.height,
                              Text(e.total.toString(), style: primaryTextStyle()),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16),
              16.height,
              if (snap.data!.can_review.validate())
                appButton(
                  width: context.width() / 2 - 20,
                  context: context,
                  text: language.writeReview,
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      elevation: 0,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return WriteCourseReview(
                          courseId: widget.courseId,
                          callback: () {
                            appStore.setLoading(false);
                            getReview();
                          },
                        );
                      },
                    );
                  },
                ).paddingAll(16),
              if (snap.data!.reviews != null && snap.data!.reviews!.reviews.validate().isNotEmpty) Text(language.reviews, style: boldTextStyle()).paddingSymmetric(horizontal: 16),
              if (snap.data!.reviews != null && snap.data!.reviews!.reviews.validate().isNotEmpty)
                ListView.builder(
                  padding: EdgeInsets.all(16),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snap.data!.reviews!.reviews.validate().length,
                  itemBuilder: (ctx, index) {
                    Review review = snap.data!.reviews!.reviews.validate()[index];

                    return Container(
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(review.display_name.validate(), style: boldTextStyle()),
                              RatingBarWidget(
                                onRatingChanged: (x) {
                                  //
                                },
                                activeColor: Colors.amber,
                                inActiveColor: Colors.amber,
                                rating: review.rate.validate().toDouble(),
                                size: 14,
                                allowHalfRating: true,
                                disable: true,
                              ),
                            ],
                          ),
                          8.height,
                          Text(review.title.validate(), style: secondaryTextStyle()),
                          8.height,
                          Text(parseHtmlString(review.content.validate()), style: primaryTextStyle()),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ThreeBounceLoadingWidget().visible(showLoading)
      ],
    );
  }
}
