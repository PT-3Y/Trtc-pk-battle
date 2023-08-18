import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/lms_payment_model.dart';
import 'package:socialv/network/lms_rest_apis.dart';
import 'package:socialv/screens/lms/screens/lms_order_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class BuyCourseScreen extends StatelessWidget {
  final String? courseImage;
  final String? courseName;
  final String? coursePriseRendered;
  final int? coursePrise;
  final int courseId;
  final VoidCallback? callback;

  const BuyCourseScreen({
    this.courseImage,
    this.courseName,
    this.coursePrise,
    required this.courseId,
    this.coursePriseRendered,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController note = TextEditingController();
    String selectedPaymentMethod = '';

    return AppScaffold(
      appBarTitle: language.checkout,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(14),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${language.yourOrder}:', style: boldTextStyle(size: 18)),
                  16.height,
                  Row(
                    children: [
                      cachedImage(courseImage, height: 60, width: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(commonRadius),
                      16.width,
                      Text(courseName.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                    ],
                  ),
                  Divider(color: context.dividerColor, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language.subTotal, style: boldTextStyle(size: 14)),
                      Text(coursePriseRendered.validate(), style: secondaryTextStyle()),
                    ],
                  ),
                  Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language.total, style: boldTextStyle()),
                      Text(coursePriseRendered.validate(), style: boldTextStyle(size: 20, color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                    ],
                  ),
                ],
              ),
            ),
            AppTextField(
              controller: note,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              textFieldType: TextFieldType.MULTILINE,
              textStyle: boldTextStyle(),
              decoration: inputDecorationFilled(context, fillColor: context.cardColor, label: language.noteToAdministrator),
              minLines: 5,
            ).paddingSymmetric(horizontal: 16),
            SnapHelperWidget(
              future: getLmsPayments(),
              onSuccess: (List<LmsPaymentModel> snap) {
                return Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${language.paymentMethod}:', style: boldTextStyle()),
                      16.height,
                      ListView.builder(
                        itemCount: snap.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          LmsPaymentModel payment = snap[index];

                          if (payment.isSelected.validate()) {
                            selectedPaymentMethod = payment.id.validate();
                          }

                          /// todo: select different payment methods
                          if (payment.id == 'offline-payment') {
                            return Row(
                              children: [
                                Icon(
                                  payment.isSelected.validate() ? Icons.check_circle_rounded : Icons.circle_outlined,
                                  color: payment.isSelected.validate() ? context.primaryColor : context.iconColor,
                                ),
                                16.width,
                                Text(payment.description.validate(), style: primaryTextStyle()),
                              ],
                            );
                          } else
                            return Offstage();
                        },
                      ),
                    ],
                  ),
                );
              },
              loadingWidget: ThreeBounceLoadingWidget().paddingSymmetric(vertical: 16),
              errorWidget: TextIcon(
                text: language.paymentGatewaysNotFound,
                textStyle: boldTextStyle(size: 18),
                prefix: Icon(Icons.payment, color: context.iconColor),
                spacing: 16,
              ).paddingSymmetric(vertical: 16),
            ),
            16.height,
            appButton(
              context: context,
              text: language.placeOrder,
              onTap: () async {
                ifNotTester(() async {
                  if (selectedPaymentMethod.isNotEmpty) {
                    appStore.setLoading(true);
                    await lmsPlaceOrder(
                      courseIds: [courseId],
                      subTotal: coursePrise.validate().toDouble(),
                      total: coursePrise.validate().toDouble(),
                      paymentMethod: selectedPaymentMethod,
                    ).then((value) {
                      appStore.setLoading(false);
                      finish(context);
                      LmsOrderScreen(orderDetail: value).launch(context).then((value) {
                        callback?.call();
                      });
                    }).catchError((e) {
                      toast(e.toString());
                      appStore.setLoading(true);
                    });
                  } else {
                    toast(language.paymentMethodIsRequired);
                  }
                });
              },
            ),
            16.height,
          ],
        ),
      ),
    );
  }
}
