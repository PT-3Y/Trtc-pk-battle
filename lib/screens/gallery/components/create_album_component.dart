import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/gallery/screens/create_album_screen.dart';
import '../../../components/loading_widget.dart';
import '../../../components/no_data_lottie_widget.dart';
import '../../../main.dart';
import '../../../models/gallery/media_active_statuses_model.dart';
import '../../../models/posts/media_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';

class CreateAlbumComponent extends StatefulWidget {
  final List<MediaModel> mediaTypeList;
  final Function(int)? onNextPage;
  final int? groupId;

  CreateAlbumComponent({Key? key, required this.mediaTypeList, this.onNextPage, this.groupId}) : super(key: key);

  @override
  State<CreateAlbumComponent> createState() => _CreateAlbumComponentState();
}

int? albumId;

class _CreateAlbumComponentState extends State<CreateAlbumComponent> {
  final albumKey = GlobalKey<FormState>();
  MediaModel dropdownTypeValue = MediaModel();
  MediaActiveStatusesModel dropdownStatusValue = MediaActiveStatusesModel();
  TextEditingController titleCont = TextEditingController();
  TextEditingController discCont = TextEditingController();
  FocusNode titleNode = FocusNode();
  FocusNode discNode = FocusNode();

  List<MediaActiveStatusesModel> mediaStatusList = [];

  bool isError = false;

  @override
  void initState() {
    super.initState();
    getMediaStatusList();

    if (widget.mediaTypeList.validate().isNotEmpty) {
      dropdownTypeValue = widget.mediaTypeList[(widget.groupId != null) ? 2 : 1];
      selectedAlbumMedia = widget.mediaTypeList[(widget.groupId != null) ? 2 : 1];
    }
  }

  Future<List<MediaActiveStatusesModel>> getMediaStatusList() async {
    appStore.setLoading(true);
    await getMediaStatus(type: widget.groupId == null ? Component.members : Component.groups).then(
      (value) {
        mediaStatusList.addAll(value);
        dropdownStatusValue = mediaStatusList.first;
        appStore.setLoading(false);
        isError = false;
        setState(() {});
      },
    ).catchError(
      (e) {
        isError = true;
        appStore.setLoading(false);
        setState(() {});
      },
    );
    return mediaStatusList;
  }

  void createNewAlbum() {
    ifNotTester(
      () {
        appStore.setLoading(true);
        setState(() {});
        createAlbum(
          groupID: widget.groupId,
          component: widget.groupId == null ? Component.members : Component.groups,
          title: titleCont.text,
          type: selectedAlbumMedia!.type.validate(),
          description: discCont.text,
          status: dropdownStatusValue.slug.validate(),
        ).then((value) {
          albumId = value.albumId.validate();
          toast(value.message.toString(), print: true);
          isAlbumCreated = true;
          appStore.setLoading(false);
          widget.onNextPage!.call(1);
        }).catchError(
          (e) {
            toast(e.toString(), print: true);
            appStore.setLoading(false);
            setState(() {});
          },
        );
      },
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    titleNode.dispose();
    discNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (isError)
            SizedBox(
              height: context.height() * 0.8,
              child: NoDataWidget(
                imageWidget: NoDataLottieWidget(),
                title: isError ? language.somethingWentWrong : language.noDataFound,
                onRetry: () {
                  getMediaStatusList();
                },
                retryText: '   ${language.clickToRefresh}   ',
              ).center(),
            )
          else
            Container(
              height: context.height(),
              width: context.width(),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(defaultRadius)),
                color: context.cardColor,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    24.height,
                    Text(
                      "1. ${language.addAlbumDetails}",
                      style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 18),
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language.type, style: boldTextStyle()),
                        if (widget.mediaTypeList.validate().isNotEmpty)
                          Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<MediaModel>(
                                  isExpanded: true,
                                  borderRadius: BorderRadius.circular(commonRadius),
                                  value: dropdownTypeValue,
                                  icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                                  elevation: 8,
                                  style: primaryTextStyle(),
                                  underline: Container(height: 2, color: appColorPrimary),
                                  alignment: Alignment.bottomCenter,
                                  onChanged: (MediaModel? newValue) {
                                    setState(() {
                                      dropdownTypeValue = newValue!;
                                      selectedAlbumMedia = newValue;
                                    });
                                  },
                                  items: widget.mediaTypeList.sublist((widget.groupId != null) ? 2 : 1).map<DropdownMenuItem<MediaModel>>((e) {
                                    return DropdownMenuItem<MediaModel>(
                                      value: e,
                                      child: Text('${e.title.validate()}', overflow: TextOverflow.ellipsis, maxLines: 1),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language.status, style: boldTextStyle()),
                        Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<MediaActiveStatusesModel>(
                                borderRadius: BorderRadius.circular(commonRadius),
                                value: dropdownStatusValue,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                                elevation: 8,
                                style: primaryTextStyle(),
                                underline: Container(height: 2, color: appColorPrimary),
                                alignment: Alignment.bottomCenter,
                                onChanged: (MediaActiveStatusesModel? newValue) {
                                  setState(() {
                                    dropdownStatusValue = newValue!;
                                  });
                                },
                                items: mediaStatusList.map<DropdownMenuItem<MediaActiveStatusesModel>>((e) {
                                  return DropdownMenuItem<MediaActiveStatusesModel>(
                                    value: e,
                                    child: e.label != language.all ? Text('${e.label.validate()}', overflow: TextOverflow.ellipsis, maxLines: 1) : Offstage(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.height,
                    Form(
                      key: albumKey,
                      child: Column(
                        children: [
                          TextFormField(
                            focusNode: titleNode,
                            controller: titleCont,
                            autofocus: false,
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            decoration: inputDecorationFilled(
                              context,
                              fillColor: context.scaffoldBackgroundColor,
                              label: language.title,
                            ),
                            onFieldSubmitted: (value) {
                              titleNode.unfocus();
                              FocusScope.of(context).requestFocus(discNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return language.pleaseEnterTitle;
                              } else {
                                return null;
                              }
                            },
                          ),
                          16.height,
                          TextFormField(
                            focusNode: discNode,
                            controller: discCont,
                            autofocus: false,
                            maxLines: 5,
                            decoration: inputDecorationFilled(
                              context,
                              fillColor: context.scaffoldBackgroundColor,
                              label: language.description,
                            ),
                          ),
                        ],
                      ).paddingSymmetric(vertical: 8),
                    ),
                    8.height,
                    Align(
                      alignment: Alignment.center,
                      child: appButton(
                        text: language.create,
                        onTap: () {
                          hideKeyboard(context);
                          if (albumKey.currentState!.validate()) {
                            createNewAlbum();
                          }
                        },
                        context: context,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            child: Observer(builder: (_) => LoadingWidget().center().visible(appStore.isLoading)),
          ),
        ],
      ),
    );
  }
}
