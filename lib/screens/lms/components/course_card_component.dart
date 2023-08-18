import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/lms/course_list_model.dart';
import 'package:socialv/screens/lms/components/price_widget.dart';
import 'package:socialv/screens/lms/screens/course_detail_screen.dart';
import 'package:socialv/screens/lms/screens/course_list_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class CourseCardComponent extends StatelessWidget {
  final CourseListModel course;

  const CourseCardComponent({required this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CourseDetailScreen(courseId: course.id.validate()).launch(context);
      },
      child: Container(
        decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            cachedImage(
              course.image.validate(),
              height: 200,
              width: context.width(),
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRectOnly(topLeft: commonRadius.toInt(), topRight: commonRadius.toInt()),
            20.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (course.categories.validate().isNotEmpty)
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              CourseListScreen(categoryId: course.categories.validate().first.id.validate()).launch(context);
                            },
                            child: Text(
                              parseHtmlString(course.categories.validate().first.name.validate()),
                              style: boldTextStyle(color: context.primaryColor, fontFamily: fontFamily, size: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ).flexible(),
                        if (course.categories.validate().isNotEmpty) Text('|', style: secondaryTextStyle(fontFamily: fontFamily)).paddingSymmetric(horizontal: 14),
                        Row(
                          children: [
                            Image.asset(ic_star_filled, height: 14, width: 14, color: starColor, fit: BoxFit.cover),
                            6.width,
                            Text(
                              course.rating.toString(),
                              style: boldTextStyle(size: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ).expand(),
                          ],
                        ).expand(),
                      ],
                    ).expand(),
                    PriceWidgetLms(originPrice: course.origin_price_rendered, salePrice: course.sale_price.validate(), price: course.price_rendered.validate()),
                  ],
                ),
                8.height,
                Text(course.name.validate(), style: boldTextStyle()),
                14.height,
                Wrap(
                  spacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        cachedImage(ic_profile, height: 14, width: 16, fit: BoxFit.cover, color: context.iconColor),
                        4.width,
                        Text(course.instructor!.name.validate(), style: secondaryTextStyle()),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        cachedImage(ic_course, height: 14, width: 20, fit: BoxFit.contain ,color: context.iconColor),
                        4.width,
                        Text('${course.count_students.validate().toString()} students', style: secondaryTextStyle()),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        cachedImage(ic_book, height: 14, width: 14, fit: BoxFit.contain, color: context.iconColor),
                        4.width,
                        Text('${course.course_data!.result!.items!.lesson!.total!.validate().toString()} lessons', style: secondaryTextStyle()),
                      ],
                    )
                  ],
                ),
                24.height,
              ],
            ).paddingSymmetric(horizontal: 16)
          ],
        ),
      ),
    );
  }
}
