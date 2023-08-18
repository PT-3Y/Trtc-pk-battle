import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/models/lms/lms_common_models/section.dart';
import 'package:socialv/screens/lms/components/curriculam_tab_component.dart';

class CourseSectionsScreen extends StatefulWidget {
  final List<Section>? sections;
  final bool isEnrolled;
  final VoidCallback? callback;

  const CourseSectionsScreen({Key? key, this.sections, required this.isEnrolled, this.callback});

  @override
  State<CourseSectionsScreen> createState() => _CourseSectionsScreenState();
}

class _CourseSectionsScreenState extends State<CourseSectionsScreen> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onBack: () {
        finish(context);
      },
      child: SingleChildScrollView(
        child: CurriculumTabComponent(
          sections: widget.sections,
          showCheck: true,
          isEnrolled: widget.isEnrolled,
          callback: () {
            widget.callback!.call();
          },
        ),
      ),
    );
  }
}
