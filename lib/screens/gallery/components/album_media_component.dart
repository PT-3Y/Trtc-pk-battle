import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/post/screens/audio_post_screen.dart';
import 'package:socialv/screens/post/screens/image_screen.dart';
import 'package:socialv/screens/post/screens/pdf_screen.dart';
import 'package:socialv/screens/post/screens/video_post_screen.dart';

import '../../../utils/cached_network_image.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/images.dart';

class AlbumMediaComponent extends StatefulWidget {
  final String mediaUrl;
  final String? mediaType;
  final String thumbnail;
  final bool? canDelete;
  final VoidCallback? onDelete;

  AlbumMediaComponent({required this.mediaUrl, this.onDelete, this.canDelete = false, required this.thumbnail, this.mediaType});

  @override
  State<AlbumMediaComponent> createState() => _AlbumMediaComponentState();
}

class _AlbumMediaComponentState extends State<AlbumMediaComponent> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.mediaUrl.validate())
      ..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.thumbnail);
    return GestureDetector(
      onTap: () {
        if (widget.mediaType == MediaTypes.photo) {
          ImageScreen(imageURl: widget.mediaUrl.validate()).launch(context);
        } else if (widget.mediaType == MediaTypes.audio) {
          AudioPostScreen(widget.mediaUrl.validate()).launch(context);
        } else if (widget.mediaType == MediaTypes.video) {
          VideoPostScreen(widget.mediaUrl.validate()).launch(context);
        } else if (widget.mediaType == MediaTypes.doc) {
          PDFScreen(docURl: widget.mediaUrl.validate()).launch(context);
        } else {
          //
        }
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(commonRadius),
            ),
            height: context.height(),
            width: context.width(),
            child: widget.mediaType != MediaTypes.video
                ? cachedImage(
                    height: context.height(),
                    width: context.width(),
                    widget.mediaType == MediaTypes.photo ? widget.mediaUrl.validate() : widget.thumbnail.validate(),
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(commonRadius)
                : _controller!.value.isInitialized
                    ? VideoPlayer(_controller!).cornerRadiusWithClipRRect(commonRadius)
                    : cachedImage(
                        height: context.height(),
                        width: context.width(),
                        widget.thumbnail.validate(),
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRect(commonRadius),
          ),
          if (widget.canDelete.validate())
            IconButton(
                onPressed: () {
                  showConfirmDialogCustom(
                    context,
                    title: language.albumDeleteConfirmation,
                    onAccept: (s) {
                      widget.onDelete!.call();
                    },
                    dialogType: DialogType.DELETE,
                  );
                },
                icon: Image.asset(
                  ic_delete,
                  color: Colors.white,
                  height: 18,
                  width: 18,
                )),
        ],
      ),
    );
  }
}
