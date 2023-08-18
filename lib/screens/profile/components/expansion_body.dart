import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/profile_field_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/components/profile_field_component.dart';
import 'package:socialv/utils/app_constants.dart';

ProfileFieldModel group = ProfileFieldModel();
bool isDetailChange = false;

// ignore: must_be_immutable
class ExpansionBody extends StatefulWidget {
  ProfileFieldModel group = ProfileFieldModel();
  final VoidCallback? callback;

  ExpansionBody({required this.group, this.callback});

  @override
  State<ExpansionBody> createState() => _ExpansionBodyState();
}

class _ExpansionBodyState extends State<ExpansionBody> {
  final profileFieldFormKey = GlobalKey<FormState>();
  List<ProfileFieldModel> fieldList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
          key: profileFieldFormKey,
          child: ListView.builder(
            itemCount: widget.group.fields.validate().length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, i) {
              Field element = widget.group.fields![i];

              return ProfileFieldComponent(field: element, count: 0).paddingSymmetric(horizontal: 16, vertical: 8);
            },
          ),
        ),
        16.height,
        AppButton(
          elevation: 0,
          onTap: () {
            ifNotTester(() async {
              if (profileFieldFormKey.currentState!.validate() && isValid) {
                profileFieldFormKey.currentState!.save();
                hideKeyboard(context);

                if (group.fields.validate().any((element) => element.value.validate().isNotEmpty)) {
                  if (isDetailChange) {
                    appStore.setLoading(true);
                    await updateProfileFields(request: group.toJson()).then((value) {
                      toast('${group.groupName} ${language.updatedSuccessfully}');
                      appStore.setLoginFullName(name);
                      widget.callback?.call();
                    }).catchError((e) {
                      appStore.setLoading(false);
                      toast(e.toString());
                    });
                  }
                } else {
                  toast(language.enterValidDetails);
                }
              } else {
                toast(language.enterValidDetails);
              }
            });
          },
          padding: EdgeInsets.symmetric(horizontal: 16),
          text: language.saveChanges,
          textColor: Colors.white,
          color: context.primaryColor,
        ),
        16.height,
      ],
    );
  }
}
