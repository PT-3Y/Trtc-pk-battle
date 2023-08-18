import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';

import '../../../utils/app_constants.dart';

class UpdateReviewComponent extends StatefulWidget {
  final int? rating;
  final String? review;
  final int? reviewId;

  const UpdateReviewComponent({this.review, this.rating, this.reviewId});

  @override
  State<UpdateReviewComponent> createState() => _UpdateReviewComponentState();
}

class _UpdateReviewComponentState extends State<UpdateReviewComponent> {
  double selectedRating = 3;

  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.review != null) {
      reviewController.text = parseHtmlString(widget.review.validate());
      selectedRating = widget.rating.validate().toDouble();
    }
  }

  void updateReview() {
    if (selectedRating > 0) {
      if (reviewController.text.isNotEmpty) {
        ifNotTester(() async {
          appStore.setLoading(true);
          finish(context);
          Map request = {"review": reviewController.text, "rating": selectedRating.toString()};
          await updateProductReview(request: request, reviewId: widget.reviewId.validate()).then((value) async {
            toast(language.reviewUpdatedSuccessfully);
            appStore.setLoading(false);
          }).catchError((e) {
            appStore.setLoading(false);
            toast(e.toString(), print: true);
          });
        });
      } else {
        toast(language.pleaseAddReview);
      }
    } else {
      toast(language.pleaseAddRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language.rating, style: boldTextStyle(color: context.primaryColor, size: 20)),
                if (widget.review != null)
                  IconButton(
                    onPressed: () async {
                      showConfirmDialogCustom(
                        context,
                        onAccept: (c) {
                          ifNotTester(() {
                            appStore.setLoading(true);
                            finish(context);
                            deleteProductReview(reviewId: widget.reviewId.validate()).then((value) {
                              appStore.setLoading(false);
                              toast(language.reviewDeletedSuccessfully);
                            }).catchError((e) {
                              appStore.setLoading(false);
                              toast(e.toString());
                            });
                          });
                        },
                        dialogType: DialogType.CONFIRMATION,
                        title: language.deleteReviewConfirmation,
                        positiveText: language.delete,
                      );
                    },
                    icon: Icon(Icons.delete_outline, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                  ),
              ],
            ),
            RatingBarWidget(
              onRatingChanged: (rating) {
                selectedRating = rating;
                setState(() {});
              },
              activeColor: Colors.amber,
              inActiveColor: Colors.amber,
              rating: selectedRating,
              size: 30,
              allowHalfRating: false,
            ),
            16.height,
            AppTextField(
              controller: reviewController,
              textFieldType: TextFieldType.OTHER,
              minLines: 5,
              maxLines: 10,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
                labelText: language.writeReview,
                labelStyle: secondaryTextStyle(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: radius(),
                  borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: radius(),
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: radius(),
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
                errorMaxLines: 2,
                errorStyle: primaryTextStyle(color: Colors.red, size: 12),
                focusedBorder: OutlineInputBorder(borderRadius: radius(), borderSide: BorderSide(color: context.scaffoldBackgroundColor, width: 0.0)),
                filled: true,
                fillColor: context.scaffoldBackgroundColor,
              ),
              onFieldSubmitted: (x) {
                updateReview();
              },
            ),
            32.height,
            Row(
              children: [
                AppButton(
                  text: language.cancel,
                  textColor: textPrimaryColorGlobal,
                  color: context.cardColor,
                  elevation: 0,
                  onTap: () {
                    finish(context);
                  },
                ).expand(),
                16.width,
                AppButton(
                  textColor: Colors.white,
                  text: language.submit,
                  elevation: 0,
                  color: context.primaryColor,
                  onTap: () {
                    updateReview();
                  },
                ).expand(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
