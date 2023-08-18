import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/profile_field_model.dart';
import 'package:socialv/screens/profile/components/expansion_body.dart';
import 'package:socialv/utils/app_constants.dart';

String name = appStore.loginFullName;
bool isValid = true;

// ignore: must_be_immutable
class ProfileFieldComponent extends StatefulWidget {
  final Field field;
  int count;

  ProfileFieldComponent({required this.field, required this.count});

  @override
  State<ProfileFieldComponent> createState() => _ProfileFieldComponentState();
}

class _ProfileFieldComponentState extends State<ProfileFieldComponent> {
  TextEditingController controller = TextEditingController();
  OptionField? selectedValue;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.field.type == FieldType.selectBox) {
      if (widget.field.options.validate().isNotEmpty && widget.field.value.validate().isEmpty) {
        //selectedValue = widget.field.options.validate().first;
      } else {
        selectedValue = widget.field.options.validate().firstWhere((element) => element.name == widget.field.value);
      }
    } else if (widget.field.type == FieldType.datebox) {
      if (widget.field.value.validate().isNotEmpty) controller.text = widget.field.value.validate().substring(0, 10);
    } else {
      if (widget.field.label == 'Name' && widget.field.value!.isEmpty) {
        controller.text = appStore.loginFullName;
      } else {
        controller.text = widget.field.value.validate();
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.count == 0) {
      init();
      widget.count = widget.count + 1;
    }

    if (widget.field.type == FieldType.textBox || widget.field.type == FieldType.url) {
      return Container(
        decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultAppButtonRadius)),
        child: AppTextField(
          enabled: !appStore.isLoading,
          controller: controller,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          textFieldType: TextFieldType.NAME,
          textStyle: boldTextStyle(),
          isValidationRequired: widget.field.isRequired.validate(),
          maxLines: 1,
          decoration: InputDecoration(
            labelText: widget.field.label,
            labelStyle: secondaryTextStyle(weight: FontWeight.w600),
            errorStyle: primaryTextStyle(color: Colors.red, size: 12),
            enabledBorder: OutlineInputBorder(borderRadius: radius(defaultAppButtonRadius), borderSide: BorderSide(color: context.cardColor)),
            disabledBorder: OutlineInputBorder(borderRadius: radius(defaultAppButtonRadius), borderSide: BorderSide(color: context.cardColor)),
            focusedBorder: OutlineInputBorder(borderRadius: radius(defaultAppButtonRadius), borderSide: BorderSide(color: context.cardColor)),
            border: OutlineInputBorder(borderRadius: radius(defaultAppButtonRadius), borderSide: BorderSide(color: context.cardColor)),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
            alignLabelWithHint: true,
          ),
          onChanged: (text) {
            isValid = true;

            if (widget.field.label == ProfileFields.name) {
              name = controller.text;
            }

            if (widget.field.type == FieldType.url || group.groupName == ProfileFields.socialNetworks) {
              if (controller.text.validateURL()) {
                group.fields![group.fields!.indexOf(widget.field)].value = text;
                isDetailChange = true;
              } else {
                isValid = false;
              }
            } else {
              group.fields![group.fields!.indexOf(widget.field)].value = text;
              isDetailChange = true;
            }
          },
          onFieldSubmitted: (text) {
            isValid = true;

            if (widget.field.label == ProfileFields.name) {
              name = controller.text;
            }

            if (widget.field.type == FieldType.url || group.groupName == ProfileFields.socialNetworks) {
              if (controller.text.validateURL()) {
                group.fields![group.fields!.indexOf(widget.field)].value = text;
                isDetailChange = true;
              } else {
                isValid = false;
                toast(language.enterValidUrl);
              }
            } else {
              group.fields![group.fields!.indexOf(widget.field)].value = text;
              isDetailChange = true;
            }
          },
        ),
      );
    } else if (widget.field.type == FieldType.textarea) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultAppButtonRadius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.field.label.validate(), style: secondaryTextStyle(weight: FontWeight.w600, color: appStore.isDarkMode ? bodyDark : bodyWhite)),
            AppTextField(
              enabled: !appStore.isLoading,
              isValidationRequired: widget.field.isRequired.validate(),
              controller: controller,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              textFieldType: TextFieldType.MULTILINE,
              textStyle: boldTextStyle(),
              minLines: 5,
              //maxLines: 5,
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (text) {
                group.fields![group.fields!.indexOf(widget.field)].value = text;
                isDetailChange = true;
              },
              onFieldSubmitted: (text) {
                group.fields![group.fields!.indexOf(widget.field)].value = text;
                isDetailChange = true;
              },
            ),
          ],
        ),
      );
    } else if (widget.field.type == FieldType.selectBox) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultAppButtonRadius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.field.label.validate(), style: secondaryTextStyle(weight: FontWeight.w600)),
            IgnorePointer(
              ignoring: appStore.isLoading,
              child: DropdownButton<OptionField>(
                borderRadius: BorderRadius.circular(commonRadius),
                value: selectedValue,
                icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                elevation: 16,
                isExpanded: true,
                style: primaryTextStyle(),
                underline: Container(height: 2, color: context.primaryColor),
                onChanged: (OptionField? newValue) {
                  selectedValue = newValue!;
                  group.fields![group.fields!.indexOf(widget.field)].value = selectedValue!.name;
                  isDetailChange = true;
                  setState(() {});
                },
                hint: Text('${language.select} ${widget.field.label.validate()}', style: secondaryTextStyle(weight: FontWeight.w600)),
                items: widget.field.options.validate().map<DropdownMenuItem<OptionField>>((e) {
                  return DropdownMenuItem<OptionField>(
                    value: e,
                    child: Text('${e.name.validate()}', overflow: TextOverflow.ellipsis, maxLines: 1),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    } else if (widget.field.type == FieldType.datebox) {
      DateTime dateTime = widget.field.value!.isNotEmpty ? DateTime.parse(widget.field.value.validate()) : DateTime.now().subtract(Duration(days: 1));

      return Container(
        decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(defaultAppButtonRadius)),
        child: AppTextField(
          enabled: !appStore.isLoading,
          isValidationRequired: widget.field.isRequired.validate(),
          controller: controller,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          textFieldType: TextFieldType.NAME,
          textStyle: boldTextStyle(),
          maxLines: 1,
          decoration: InputDecoration(
            labelText: widget.field.label,
            labelStyle: secondaryTextStyle(weight: FontWeight.w600),
            errorStyle: primaryTextStyle(color: Colors.red, size: 12),
            disabledBorder: OutlineInputBorder(borderRadius: radius(defaultAppButtonRadius), borderSide: BorderSide(color: context.cardColor)),
            enabledBorder: OutlineInputBorder(borderRadius: radius(defaultAppButtonRadius), borderSide: BorderSide(color: context.cardColor)),
            focusedBorder: OutlineInputBorder(borderRadius: radius(defaultAppButtonRadius), borderSide: BorderSide(color: context.cardColor)),
            border: OutlineInputBorder(borderRadius: radius(defaultAppButtonRadius), borderSide: BorderSide(color: context.cardColor)),
            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
            alignLabelWithHint: true,
          ),
          onTap: () async {
            hideKeyboard(context);
            final datePick = await showDatePicker(
                context: context,
                initialDate: dateTime,
                firstDate: DateTime(1900),
                  lastDate: DateTime.now().subtract(Duration(days: 1)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: appColorPrimary, // header background color
                        onPrimary: Colors.white, // header text color
                        onSurface: context.iconColor, // body text color
                      ),
                    ),
                    child: child.validate(),
                  );
                });

            if (datePick != null && datePick != dateTime) {
              setState(() {
                controller.text = DateFormat("yyyy-MM-dd").format(datePick);
              });
            }

            group.fields![group.fields!.indexOf(widget.field)].value = DateFormat("yyyy-MM-dd HH:mm:ss").format(datePick!);
            isDetailChange = true;
          },
          onFieldSubmitted: (text) {
            group.fields![group.fields!.indexOf(widget.field)].value = text;
            isDetailChange = true;
          },
        ),
      );
    } else {
      return Text(widget.field.type.validate());
    }
  }
}
