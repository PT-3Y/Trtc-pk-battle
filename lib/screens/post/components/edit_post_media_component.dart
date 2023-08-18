import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models/post_mdeia_model.dart';
import 'package:socialv/models/posts/media_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';
import 'package:video_player/video_player.dart';

class EditPostMediaComponent extends StatefulWidget {
  final MediaModel mediaType;
  final List<PostMediaModel> mediaList;
  final VoidCallback? callback;

  const EditPostMediaComponent({required this.mediaType, required this.mediaList, this.callback});

  @override
  State<EditPostMediaComponent> createState() => _EditPostMediaComponentState();
}

class _EditPostMediaComponentState extends State<EditPostMediaComponent> {
  List<VideoPlayerController> controller = [];

  @override
  void initState() {
    super.initState();
    init();
  }
  void init()async{
    if (widget.mediaType.type == MediaTypes.video)
      widget.mediaList.forEach((element) {
        controller.add(VideoPlayerController.network(element.url.validate())
          ..initialize().then((_) {
            setState(() {});
          }));
      });
  }

  void deletePostMedia(PostMediaModel media) {

    showConfirmDialogCustom(
      context,
      onAccept: (c) {
        ifNotTester(() {
          deleteMedia(id: media.id.validate().toInt(), type: media.type == MediaTypes.gif ? MediaTypes.gif : MediaTypes.media).then((value) {
            log(value);
          }).catchError((e) {
            toast(e.toString(), print: true);
          });
        });

      },
      dialogType: DialogType.DELETE,
      title:language.removeMediaConfirmation,
      positiveText: language.delete,
    );

    int index=widget.mediaList.indexOf(media);
    widget.mediaList.remove(media);
    controller.removeAt(index);
    setState(() {});

    widget.callback?.call();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();

    controller.forEach((element) {
      element.dispose();
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaType.type == MediaTypes.photo) {
      return HorizontalList(
        itemCount: widget.mediaList.length,
        itemBuilder: (context, index) {
          PostMediaModel media = widget.mediaList[index];

          return Padding(
            padding: index == 0 ? EdgeInsets.only(left: 8) : EdgeInsets.all(0),
            child: Stack(
              children: [
                cachedImage(media.url.validate(), height: 80, width: 80, fit: BoxFit.cover).cornerRadiusWithClipRRect(commonRadius),
                Positioned(
                  child: Icon(Icons.cancel_outlined, color: context.primaryColor, size: 18).onTap(() async {
                    deletePostMedia(media);
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  right: 4,
                  top: 4,
                ),
              ],
            ),
          );
        },
      );
    } else if (widget.mediaType.type == MediaTypes.video) {
      return HorizontalList(
        itemCount: controller.length,
        itemBuilder: (context, index) {
          PostMediaModel media = widget.mediaList[index];

          return Padding(
            padding: index == 0 ? EdgeInsets.only(left: 8) : EdgeInsets.all(0),
            child: Stack(
              children: [
                controller[index].value.isInitialized
                    ? Container(
                        width: 80,
                        height: 80,
                        child: VideoPlayer(controller[index]).cornerRadiusWithClipRRect(commonRadius),
                      )
                    : Container(
                        decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                        height: 80,
                        width: 80,
                        padding: EdgeInsets.all(20),
                        child: Image.asset(ic_video, height: 20, width: 20, fit: BoxFit.cover),
                      ),
                Positioned(
                  child: Icon(Icons.cancel_outlined, color: context.primaryColor, size: 18).onTap(() async {
                    deletePostMedia(media);
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  right: 4,
                  top: 4,
                ),
              ],
            ),
          );
        },
      );
    } else if (widget.mediaType.type == MediaTypes.audio) {
      return HorizontalList(
        itemCount: widget.mediaList.length,
        itemBuilder: (context, index) {
          PostMediaModel media = widget.mediaList[index];

          return Padding(
            padding: index == 0 ? EdgeInsets.only(left: 8) : EdgeInsets.all(0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                  height: 80,
                  width: 80,
                  padding: EdgeInsets.all(20),
                  child: Image.asset(ic_voice, height: 20, width: 20, fit: BoxFit.cover),
                ),
                Positioned(
                  child: Icon(Icons.cancel_outlined, color: context.primaryColor, size: 18).onTap(() async {
                    deletePostMedia(media);
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  right: 4,
                  top: 4,
                ),
              ],
            ),
          );
        },
      );
    } else if (widget.mediaType.type == MediaTypes.doc) {
      return HorizontalList(
        itemCount: widget.mediaList.length,
        itemBuilder: (context, index) {
          PostMediaModel media = widget.mediaList[index];

          return Padding(
            padding: index == 0 ? EdgeInsets.only(left: 8) : EdgeInsets.all(0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                  height: 80,
                  width: 80,
                  padding: EdgeInsets.all(20),
                  child: Image.asset(ic_document, height: 20, width: 20, fit: BoxFit.cover),
                ),
                Positioned(
                  child: Icon(Icons.cancel_outlined, color: context.primaryColor, size: 18).onTap(() async {
                    deletePostMedia(media);
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  right: 4,
                  top: 4,
                ),
              ],
            ),
          );
        },
      );
    } else {
      return HorizontalList(
        itemCount: widget.mediaList.length,
        itemBuilder: (context, index) {
          PostMediaModel media = widget.mediaList[index];

          return Padding(
            padding: index == 0 ? EdgeInsets.only(left: 8) : EdgeInsets.all(0),
            child: Stack(
              children: [
                cachedImage(media.url.validate(), height: 80, width: 80, fit: BoxFit.cover).cornerRadiusWithClipRRect(commonRadius),
                Positioned(
                  child: Icon(Icons.cancel_outlined, color: context.primaryColor, size: 18).onTap(() async {
                    deletePostMedia(media);
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  right: 4,
                  top: 4,
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
