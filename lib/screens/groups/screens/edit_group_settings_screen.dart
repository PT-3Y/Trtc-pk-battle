import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import '../components/create_group_step_second.dart';

class EditGroupSettingsScreen extends StatefulWidget {
  final int groupId;
  final String? groupInviteStatus;
  final int? isGalleryEnabled;

  const EditGroupSettingsScreen({Key? key, required this.groupId, this.groupInviteStatus, this.isGalleryEnabled}) : super(key: key);

  @override
  State<EditGroupSettingsScreen> createState() => _EditGroupSettingsScreenState();
}

class _EditGroupSettingsScreenState extends State<EditGroupSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.editGroupSettings, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: CreateGroupStepSecond(
        isAPartOfSteps: false,
        groupInviteStatus: widget.groupInviteStatus,
        isGalleryEnabled: widget.isGalleryEnabled,
      ),
    );
  }
}
