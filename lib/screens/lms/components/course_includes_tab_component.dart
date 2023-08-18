import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/lms/lms_common_models/course_data.dart';
import 'package:socialv/models/lms/lms_common_models/course_meta_data.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class CourseIncludesTabComponent extends StatelessWidget {
  final List<String>? requirements;
  final List<String>? features;
  final List<String>? audiences;
  final CourseData? courseData;
  final CourseMetaData? metaData;

  CourseIncludesTabComponent({Key? key, this.requirements, this.features, this.audiences, this.courseData, this.metaData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                cachedImage(ic_book_filled, height: 16, width: 16, fit: BoxFit.cover, color: context.primaryColor),
                10.width,
                Text('${courseData!.result!.items!.lesson!.total} ${language.detailedLessons}', style: primaryTextStyle()),
              ],
            ),
            Row(
              children: [
                cachedImage(ic_quiz, height: 16, width: 16, fit: BoxFit.cover, color: context.primaryColor),
                10.width,
                Text('${courseData!.result!.items!.quiz!.total} ${language.quiz}', style: primaryTextStyle()),
              ],
            ).paddingSymmetric(vertical: 8),
            Row(
              children: [
                cachedImage(ic_calendar_filled, height: 16, width: 16, fit: BoxFit.cover, color: context.primaryColor),
                10.width,
                Text('${metaData!.lp_duration} ${language.ofTheEntireCourse}', style: primaryTextStyle()),
              ],
            ),
            Row(
              children: [
                cachedImage(ic_student, height: 16, width: 16, fit: BoxFit.cover, color: context.primaryColor),
                10.width,
                Text('${metaData!.lp_students} ${language.studentsParticipated}', style: primaryTextStyle()),
              ],
            ).paddingSymmetric(vertical: 8),
            Row(
              children: [
                cachedImage(ic_tick_filled, height: 16, width: 16, fit: BoxFit.cover, color: context.primaryColor),
                10.width,
                Text(
                  '${language.assessments} ${courseData!.result!.evaluate_type.validate() == CourseType.evaluate_lesson ? language.yes : language.self}',
                  style: primaryTextStyle(),
                ),
              ],
            ).paddingSymmetric(vertical: 8),
          ],
        ).paddingAll(16),
        if (requirements.validate().isNotEmpty)
          ExpansionTile(
            textColor: context.primaryColor,
            childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(language.requirements),
            children: requirements.validate().map((e) {
              return Text(parseHtmlString(e), style: secondaryTextStyle()).paddingSymmetric(vertical: 6);
            }).toList(),
          ),
        if (features.validate().isNotEmpty)
          ExpansionTile(
            textColor: context.primaryColor,
            childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(language.features),
            children: features.validate().map((e) {
              return Text(parseHtmlString(e), style: secondaryTextStyle()).paddingSymmetric(vertical: 6);
            }).toList(),
          ),
        if (audiences.validate().isNotEmpty)
          ExpansionTile(
            textColor: context.primaryColor,
            childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(language.targetAudiences),
            children: audiences.validate().map((e) {
              return Text(parseHtmlString(e), style: secondaryTextStyle()).paddingSymmetric(vertical: 6);
            }).toList(),
          ),
      ],
    );
  }
}
