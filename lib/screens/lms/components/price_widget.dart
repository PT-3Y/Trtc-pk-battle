import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/app_constants.dart';

class PriceWidget extends StatelessWidget {
  final String? salePrice;
  final String? originPrice;
  final String? price;

  const PriceWidget({
    Key? key,
    this.salePrice,
    this.price,
    this.originPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!salePrice.validate().contains('0.00')) {
      return RichText(
        text: TextSpan(
          text: '${originPrice.validate()}',
          style: secondaryTextStyle(decoration: TextDecoration.lineThrough, fontFamily: fontFamily),
          children: <TextSpan>[
            TextSpan(
              text: '  ${salePrice.validate()}',
              style: boldTextStyle(decoration: TextDecoration.none, color: context.primaryColor, fontFamily: fontFamily),
            ),
          ],
        ),
      );
    } else if (price.validate().contains('Free')) {
      return Text('Free', style: boldTextStyle(decoration: TextDecoration.none, color: appGreenColor));
    } else {
      return Text('${price.validate()}', style: boldTextStyle(decoration: TextDecoration.none, color: context.primaryColor));
    }
  }
}

class PriceWidgetLms extends StatelessWidget {
  final int? salePrice;
  final String? originPrice;
  final String? price;

  const PriceWidgetLms({
    Key? key,
    this.salePrice,
    this.price,
    this.originPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (salePrice != 0) {
      return RichText(
        text: TextSpan(
          text: '${originPrice.validate()}',
          style: secondaryTextStyle(decoration: TextDecoration.lineThrough, fontFamily: fontFamily),
          children: <TextSpan>[
            TextSpan(
              text: '  ${price.validate()}',
              style: boldTextStyle(decoration: TextDecoration.none, color: context.primaryColor, fontFamily: fontFamily),
            ),
          ],
        ),
      );
    } else if (price.validate().contains('Free')) {
      return Text('Free', style: boldTextStyle(decoration: TextDecoration.none, color: appGreenColor));
    } else {
      return Text('${price.validate()}', style: boldTextStyle(decoration: TextDecoration.none, color: context.primaryColor));
    }
  }
}
