import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/lms/course_orders.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';

class CourseOrderCardComponent extends StatelessWidget {
  final CourseOrders data;
  final Function(int)? onTap;

  const CourseOrderCardComponent({Key? key, required this.data, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!(data.id.validate().toInt());
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(commonRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  data.orderNumber.validate(),
                  style: secondaryTextStyle(),
                ).expand(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: radius(4),
                    color: context.primaryColor,
                  ),
                  child: Text(
                    data.orderStatus.validate().capitalizeFirstLetter(),
                    style: secondaryTextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            8.height,
            RichText(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: "Course Name: ",
                style: boldTextStyle(),
                children: [
                  TextSpan(
                    text: data.orderItems.validate().first.name.validate(),
                    style: primaryTextStyle(),
                  )
                ],
              ),
            ),
            8.height,
            Divider(),
            8.height,
            RichText(
              text: TextSpan(
                text: "Total: ",
                style: boldTextStyle(),
                children: [
                  TextSpan(
                    text: (data.orderItems.validate().first.regularPrice.validate().isEmpty || data.orderItems.validate().first.regularPrice.validate() == "0")
                        ? "Free"
                        : "${data.orderItems.validate().first.regularPrice.validate()}\$",
                    style: secondaryTextStyle(size: 16),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
