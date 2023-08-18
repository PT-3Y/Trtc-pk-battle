import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/messages_repository.dart';
import 'package:socialv/screens/messages/screens/preview_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

// ignore: must_be_immutable
class SetChatWallpaperScreen extends StatefulWidget {
  final bool isGeneralSetting;
  final Function(File?)? sendFile;
  final int? threadId;
  String? wallpaperUrl;

  SetChatWallpaperScreen({required this.isGeneralSetting, this.sendFile, this.threadId, this.wallpaperUrl});

  @override
  State<SetChatWallpaperScreen> createState() => _SetChatWallpaperScreenState();
}

class _SetChatWallpaperScreenState extends State<SetChatWallpaperScreen> {
  File? wallpaperFile;

  @override
  void initState() {
    super.initState();
  }

  Future<void> setWallpaper({required File file}) async {
    wallpaperFile = file;

    saveChatBackground(
      id: widget.isGeneralSetting ? appStore.loginUserId : widget.threadId.validate().toString(),
      image: file,
      type: widget.isGeneralSetting ? "global" : "thread",
    ).then((value) {
      if (widget.isGeneralSetting) {
        getSettings();
      } else {
        widget.sendFile?.call(file);
      }
    });

    setState(() {});
  }

  Future<void> deleteWallpaper() async {
    Map request = {
      "id": widget.isGeneralSetting ? appStore.loginUserId : widget.threadId.validate().toString(),
      "type": widget.isGeneralSetting ? "global" : "thread",
    };

    deleteChatBackground(request: request).then((value) {
      //
    }).catchError((e) {
      log(e.toString());
    });
    setState(() {});
  }

  Future<void> getSettings() async {
    await userSettings().then((value) {
      if (value.chatBackground != null && value.chatBackground!.url.validate().isNotEmpty) {
        messageStore.setGlobalChatBackground(value.chatBackground!.url.validate());
      }
    }).catchError((e) {
      log('Error: ${e.toString()}');
    });

    setState(() {});
  }

  bool showDeleteButton() {
    if (wallpaperFile != null || (widget.wallpaperUrl != null && widget.wallpaperUrl.validate().isNotEmpty)) {
      if (widget.wallpaperUrl.validate() == messageStore.globalChatBackground && !widget.isGeneralSetting) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(language.customWallpaper, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Column(
        children: [
          16.height,
          Container(
            height: context.height() * 0.6,
            width: context.width() * 0.6,
            decoration: BoxDecoration(
              color: context.scaffoldBackgroundColor,
              border: Border.all(color: context.dividerColor),
              borderRadius: radius(commonRadius),
            ),
            child: Stack(
              children: [
                if (widget.wallpaperUrl != null && widget.wallpaperUrl.validate().isNotEmpty)
                  cachedImage(
                    widget.wallpaperUrl,
                    height: context.height() * 0.6,
                    width: context.width() * 0.8,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(commonRadius),
                if (wallpaperFile != null)
                  Image.file(
                    File(wallpaperFile!.path.validate()),
                    height: context.height() * 0.6,
                    width: context.width() * 0.8,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(commonRadius),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: context.scaffoldBackgroundColor,
                        borderRadius: radiusOnly(topRight: commonRadius, topLeft: commonRadius),
                        boxShadow: kElevationToShadow[1],
                      ),
                      child: Row(
                        children: [
                          cachedImage(AppImages.defaultAvatarUrl, height: 30, width: 30, fit: BoxFit.cover).cornerRadiusWithClipRRect(15),
                          4.width,
                          Text(language.contactName, style: primaryTextStyle()),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Divider(indent: 16, height: 32, color: context.dividerColor).expand(),
                        Text(language.today, style: secondaryTextStyle(size: 12)).paddingSymmetric(horizontal: 8),
                        Divider(endIndent: 16, height: 32, color: context.dividerColor).expand(),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: context.width() * 0.4,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 40,
                        width: context.width() * 0.4,
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(color: context.primaryColor, borderRadius: radius(commonRadius)),
                      ),
                    ).expand(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 50,
                      width: context.width() * 0.8,
                      decoration: BoxDecoration(color: context.cardColor, borderRadius: radiusOnly(bottomLeft: commonRadius, bottomRight: commonRadius)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language.writeAMessage, style: secondaryTextStyle()),
                          cachedImage(ic_send, color: appStore.isDarkMode ? bodyDark : bodyWhite, width: 18, height: 18, fit: BoxFit.cover),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ).center(),
          TextButton(
            onPressed: () async {
              appStore.setLoading(true);
              await getImageSource(isCamera: false).then((value) {
                if (value != null) {
                  PreviewScreen(wallPaperFile: value).launch(context).then((isChanged) {
                    if (isChanged) {
                      setWallpaper(file: value);
                    }
                  });
                }
                appStore.setLoading(false);
              }).catchError((e) {
                appStore.setLoading(false);
              });
            },
            child: Text(language.change, style: primaryTextStyle(color: context.primaryColor)),
          ),
          16.height,
          if (showDeleteButton())
            TextIcon(
              prefix: cachedImage(ic_delete, color: Colors.red, height: 20, width: 20),
              text: language.removeCustomWallpaper,
              textStyle: primaryTextStyle(color: Colors.red),
              spacing: 14,
              onTap: () {
                showConfirmDialogCustom(
                  context,
                  onAccept: (ctx) {
                    deleteWallpaper();

                    wallpaperFile = null;
                    widget.wallpaperUrl = null;

                    if (widget.isGeneralSetting) {
                      messageStore.setGlobalChatBackground('');
                    } else {
                      widget.sendFile?.call(null);
                    }

                    setState(() {});
                  },
                  dialogType: DialogType.DELETE,
                  title: language.removeWallpaperConfirmation,
                  positiveText: language.remove,
                  negativeText: language.cancel,
                );
              },
            ),
        ],
      ),
    );
  }
}
