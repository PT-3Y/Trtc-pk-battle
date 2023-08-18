import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/dashboard_api_response.dart';
import 'package:socialv/models/members/profile_visibility_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/utils/app_constants.dart';

List<ProfileVisibilityModel> profileVisibility = [];

class ProfileVisibilityScreen extends StatefulWidget {
  const ProfileVisibilityScreen({Key? key}) : super(key: key);

  @override
  State<ProfileVisibilityScreen> createState() => _ProfileVisibilityScreenState();
}

class _ProfileVisibilityScreenState extends State<ProfileVisibilityScreen> {
  List<ProfileVisibilityModel> list = [];
  late Future<List<ProfileVisibilityModel>> future;

  bool isError = false;

  @override
  void initState() {
    future = getFiledList();
    super.initState();
  }

  Future<List<ProfileVisibilityModel>> getFiledList() async {
    profileVisibility.clear();
    list.clear();

    appStore.setLoading(true);

    await getProfileVisibility().then((value) {
      list.addAll(value);
      profileVisibility.addAll(value);
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;

      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    return list;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appStore.setLoading(false);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.profileVisibility, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<ProfileVisibilityModel>>(
            future: future,
            builder: (ctx, snap) {
              if (snap.hasError) {
                return NoDataWidget(
                  imageWidget: NoDataLottieWidget(),
                  title: isError ? language.somethingWentWrong : language.noDataFound,
                ).center();
              }

              if (snap.hasData) {
                if (snap.data.validate().isEmpty) {
                  return NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: isError ? language.somethingWentWrong : language.noDataFound,
                  ).center();
                } else {
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: context.width(),
                            color: context.cardColor,
                            padding: EdgeInsets.all(16),
                            child: Text(list[index].groupName.validate().toUpperCase(), style: boldTextStyle(color: context.primaryColor)),
                          ),
                          ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: list[index].fields.validate().length,
                            itemBuilder: (context, i) {
                              return VisibilityComponent(
                                field: list[index].fields.validate()[i],
                                groupIndex: index,
                                fieldIndex: i,
                                type: list[index].groupType.validate(),
                              );
                            },
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                          ),
                        ],
                      );
                    },
                  );
                }
              }


              return Offstage();
            },
          ),
          Observer(
            builder: (_) {
              if (appStore.isLoading) {
                return LoadingWidget();
              } else {
                return Offstage();
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: list.isEmpty
          ? Offstage()
          : appButton(
              context: context,
              text: language.submit.capitalizeFirstLetter(),
              onTap: () async {
                ifNotTester(() {
                  if (profileVisibility.isNotEmpty) {
                    profileVisibility.forEach((element) async {
                      if (element.isChange) {
                        appStore.setLoading(true);

                        await saveProfileVisibility(request: element.toJson()).then((value) {
                          appStore.setLoading(false);
                          toast(value.message);

                          finish(context, true);
                        }).catchError((e) {
                          appStore.setLoading(false);
                          toast(e.toString());
                        }).then((value) {
                          appStore.setLoading(false);
                        });
                      } else {
                        //appStore.setLoading(false);
                      }
                    });
                  }
                });
              },
            ).paddingAll(16),
    );
  }
}

class VisibilityComponent extends StatefulWidget {
  final Field field;
  final int fieldIndex;
  final int groupIndex;
  final String type;

  VisibilityComponent({required this.field, required this.groupIndex, required this.fieldIndex, required this.type});

  @override
  State<VisibilityComponent> createState() => _VisibilityComponentState();
}

class _VisibilityComponentState extends State<VisibilityComponent> {
  VisibilityOptions dropdownValue = VisibilityOptions();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    dropdownValue = widget.type == ProfileVisibilityTypes.dynamicSettings ? visibilities!.first : accountPrivacyVisibility!.first;

    if (widget.type == ProfileVisibilityTypes.dynamicSettings) {
      visibilities!.forEach((element) {
        if (element.label == widget.field.visibility) {
          dropdownValue = element;
        }
      });
    } else {
      accountPrivacyVisibility!.forEach((element) {
        if (element.label == widget.field.visibility) {
          dropdownValue = element;
        }
      });
    }

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.canChange.validate()) {
      return Observer(
        builder: (_) => Row(
          children: [
            Text(widget.field.name.validate(), style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)).expand(),
            widget.type == ProfileVisibilityTypes.dynamicSettings
                ? IgnorePointer(
                    ignoring: appStore.isLoading,
                    child: Container(
                      height: 40,
                      child: DropdownButton<VisibilityOptions>(
                        borderRadius: BorderRadius.circular(commonRadius),
                        value: dropdownValue,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                        elevation: 16,
                        underline: Container(height: 2, color: appColorPrimary),
                        style: primaryTextStyle(),
                        onChanged: (VisibilityOptions? newValue) {
                          dropdownValue = newValue!;
                          setState(() {});

                          profileVisibility[widget.groupIndex].isChange = true;
                          profileVisibility[widget.groupIndex].fields.validate()[widget.fieldIndex].level = newValue.id;
                        },
                        items: visibilities!.map<DropdownMenuItem<VisibilityOptions>>((e) {
                          return DropdownMenuItem<VisibilityOptions>(
                            value: e,
                            child: Text('${e.label.validate()}', overflow: TextOverflow.ellipsis, maxLines: 1),
                          );
                        }).toList(),
                      ).paddingSymmetric(horizontal: 16),
                    ),
                  ).expand()
                : IgnorePointer(
                    ignoring: appStore.isLoading,
                    child: Container(
                      height: 40,
                      child: DropdownButton<VisibilityOptions>(
                        borderRadius: BorderRadius.circular(commonRadius),
                        value: dropdownValue,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                        elevation: 16,
                        underline: Container(height: 2, color: appColorPrimary),
                        style: primaryTextStyle(),
                        onChanged: (VisibilityOptions? newValue) {
                          dropdownValue = newValue!;
                          setState(() {});

                          profileVisibility[widget.groupIndex].isChange = true;
                          profileVisibility[widget.groupIndex].fields.validate()[widget.fieldIndex].level = newValue.id;
                        },
                        items: accountPrivacyVisibility!.map<DropdownMenuItem<VisibilityOptions>>((e) {
                          return DropdownMenuItem<VisibilityOptions>(
                            value: e,
                            child: Text('${e.label.validate()}', overflow: TextOverflow.ellipsis, maxLines: 1),
                          );
                        }).toList(),
                      ).paddingSymmetric(horizontal: 16),
                    ),
                  ).expand(),
          ],
        ),
      );
    } else {
      return Row(
        children: [
          Text(widget.field.name.validate(), style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)).expand(),
          Text(
            widget.field.visibility.validate(),
            style: primaryTextStyle(fontStyle: FontStyle.italic, color: textSecondaryColor),
          ).paddingSymmetric(horizontal: 16, vertical: 8).expand(),
        ],
      );
    }
  }
}
