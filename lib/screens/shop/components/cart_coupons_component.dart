import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/woo_commerce/cart_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class CartCouponsComponent extends StatefulWidget {
  final List<CartCouponModel>? couponsList;
  final Function(CartModel)? onCouponRemoved;

  CartCouponsComponent({this.couponsList, this.onCouponRemoved});

  @override
  State<CartCouponsComponent> createState() => _CartCouponsComponentState();
}

class _CartCouponsComponentState extends State<CartCouponsComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.appliedCoupons, style: boldTextStyle()).paddingSymmetric(horizontal: 16),
        16.height,
        ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: widget.couponsList!.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, couponIndex) {
            CartCouponModel coupon = widget.couponsList!.validate()[couponIndex];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '${language.code}: ',
                        style: secondaryTextStyle(fontFamily: fontFamily),
                        children: <TextSpan>[
                          TextSpan(text: coupon.code.validate(), style: primaryTextStyle(fontFamily: fontFamily)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '${language.discount}: ',
                        style: secondaryTextStyle(fontFamily: fontFamily),
                        children: <TextSpan>[
                          TextSpan(text: '${coupon.totals!.currencySymbol.validate()}${getPrice(coupon.totals!.totalDiscount.validate())}', style: primaryTextStyle(fontFamily: fontFamily)),
                        ],
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                IconButton(
                  onPressed: () {
                    showConfirmDialogCustom(
                      context,
                      onAccept: (c) {
                        ifNotTester(() {
                          appStore.setLoading(true);
                          removeCoupon(code: coupon.code.validate()).then((value) {
                            widget.onCouponRemoved?.call(value);
                            appStore.setLoading(false);

                            log('Coupon removed');
                          }).catchError((e) {
                            log('error remove coupon: ${e.toString()}');
                            appStore.setLoading(false);
                          });
                        });
                      },
                      dialogType: DialogType.DELETE,
                        title: language.removeCouponConfirmation,
                      positiveText: language.remove,
                    );
                  },
                  icon: cachedImage(ic_delete, height: 20, width: 20, color: Colors.red),
                ),
              ],
            );
          },
        ),
        16.height,
      ],
    );
  }
}
