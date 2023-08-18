import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';

class CancelOrderBottomSheet extends StatefulWidget {
  final int orderId;
  final Function(String)? callback;

  const CancelOrderBottomSheet({required this.orderId, this.callback});

  @override
  State<CancelOrderBottomSheet> createState() => _CancelOrderBottomSheetState();
}

class _CancelOrderBottomSheetState extends State<CancelOrderBottomSheet> {
  List<String> cancelOrderList = [language.cancelOrderMessageOne, language.cancelOrderMessageTwo, language.cancelOrderMessageThree, language.cancelOrderMessageFour, language.cancelOrderMessageFive, language.cancelOrderMessageSix];

  String cancelOrderReason = "";
  int cancelOrderIndex = 0;

  @override
  void initState() {
    super.initState();
    cancelOrderReason = cancelOrderList.first;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 45,
            height: 5,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
          ),
          8.height,
          Container(
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(language.reasonForCancellation, style: boldTextStyle()).expand(),
                    Icon(Icons.close).onTap(() {
                      finish(context);
                    })
                  ],
                ),
                24.height,
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cancelOrderList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        cancelOrderReason = cancelOrderList[index];
                        print(cancelOrderReason);
                        cancelOrderIndex = index;
                        setState(() {});
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: boxDecorationWithRoundedCorners(
                              borderRadius: radius(4),
                              border: Border.all(color: context.primaryColor),
                              backgroundColor: cancelOrderIndex == index ? context.primaryColor : context.cardColor,
                            ),
                            width: 16,
                            height: 16,
                            child: Icon(Icons.done, size: 12, color: context.cardColor),
                            margin: EdgeInsets.only(top: 4),
                          ),
                          4.width,
                          Text(cancelOrderList[index], style: primaryTextStyle()).paddingLeft(8).expand(),
                        ],
                      ).paddingSymmetric(vertical: 8),
                    );
                  },
                ),
                24.height,
                AppButton(
                  width: context.width(),
                  textStyle: primaryTextStyle(color: white),
                  text: language.cancelOrder,
                  color: context.primaryColor,
                  onTap: () {
                    finish(context);

                    widget.callback?.call(cancelOrderReason);
                  },
                ),
                20.height,
              ],
            ),
          ).expand(),
        ],
      ),
    );
  }
}
