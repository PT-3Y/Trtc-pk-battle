import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/posts/media_model.dart';

import '../../../utils/app_constants.dart';

class AddPostMediaComponent extends StatefulWidget {
  final MediaModel selectedMedia;
  final VoidCallback onSelectMedia;
  final bool enableSelectMedia;
  final VoidCallback mediaListAdd;
  final Function(String)? linkListAdd;
  final VoidCallback clearMediaList;

  const AddPostMediaComponent({
    required this.selectedMedia,
    required this.onSelectMedia,
    required this.enableSelectMedia,
    required this.mediaListAdd,
    required this.clearMediaList,
    required this.linkListAdd,
  });

  @override
  State<AddPostMediaComponent> createState() => _AddPostMediaComponentState();
}

class _AddPostMediaComponentState extends State<AddPostMediaComponent> {
  TextEditingController link = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            DottedBorderWidget(
              padding: EdgeInsets.symmetric(vertical: 32),
              radius: defaultAppButtonRadius,
              dotsWidth: 8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    elevation: 0,
                    color: appColorPrimary,
                    text: language.selectFiles,
                    textStyle: boldTextStyle(color: Colors.white),
                    onTap: () async {
                      if (widget.selectedMedia.type == MediaTypes.photo || widget.selectedMedia.type == MediaTypes.video) {
                        widget.onSelectMedia.call();
                      } else {
                        widget.mediaListAdd.call();
                        /* appStore.setLoading(true);
                        mediaList.addAll(
                          await getMultipleFiles(mediaType: selectedMedia!).whenComplete(() => appStore.setLoading(false)),
                        );

                        setState(() {});

                        log('MediaList: ${mediaList.length}');*/
                      }
                    },
                  ),
                  16.height,
                  Text(
                    '${language.addPost} ${widget.selectedMedia.title.capitalizeFirstLetter()}',
                    style: secondaryTextStyle(size: 16),
                  ).center(),
                  8.height,
                  Text(
                    '${language.pleaseSelectOnly} ${widget.selectedMedia.type} ${language.files} ',
                    style: secondaryTextStyle(),
                  ).center(),
                ],
              ),
            ),
            if (widget.enableSelectMedia.validate())
              Positioned(
                child: Icon(Icons.cancel_outlined, color: appColorPrimary, size: 18).onTap(() {
                  if (!appStore.isLoading) {
                    widget.clearMediaList.call();
                    /*  mediaList.clear();
                    selectedMedia = null;
                    setState(() {});*/
                  }
                }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                right: 6,
                top: 6,
              ),
          ],
        ),
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: link,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              decoration: inputDecorationFilled(
                context,
                label: 'Enter link',
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                fillColor: context.scaffoldBackgroundColor,
              ),
            ).expand(),
            TextButton(
              onPressed: () {
                widget.linkListAdd?.call(link.text);
                link.clear();
              },
              child: Text('Add', style: boldTextStyle(color: context.primaryColor)),
            )
          ],
        ),
      ],
    );
  }
}
