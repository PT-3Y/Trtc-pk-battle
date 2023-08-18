import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/shop/screens/shop_screen.dart';

import '../../../utils/app_constants.dart';

class EmptyCartComponent extends StatelessWidget {
  final bool isFromHome;

  const EmptyCartComponent({required this.isFromHome});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Lottie.asset(shopping_cart, height: 250),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(language.yourCartIsCurrentlyEmpty, style: secondaryTextStyle(size: 16)),
                10.height,
                AppButton(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                  text: language.returnToShop,
                  textStyle: secondaryTextStyle(color: Colors.white, size: 14),
                  onTap: () async {
                    if (isFromHome) {
                      finish(context);
                      ShopScreen().launch(context);
                    } else {
                      finish(context);
                    }
                  },
                  elevation: 0,
                  color: context.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    ).center();
  }
}
