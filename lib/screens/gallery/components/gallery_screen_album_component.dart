import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../main.dart';
import '../../../models/gallery/albums.dart';

class GalleryScreenAlbumComponent extends StatefulWidget {
  final Albums album;
  final Function(int)? callback;
  final bool canDelete;

  const GalleryScreenAlbumComponent({Key? key, required this.album, this.callback, this.canDelete = false}) : super(key: key);

  @override
  State<GalleryScreenAlbumComponent> createState() => _GalleryScreenAlbumComponentState();
}

class _GalleryScreenAlbumComponentState extends State<GalleryScreenAlbumComponent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(commonRadius),
          ),
          child: cachedImage(widget.album.thumbnail, height: context.height(), width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(commonRadius),
        ),
        if (widget.canDelete.validate())
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                if (!appStore.isLoading)
                  showConfirmDialogCustom(
                    context,
                    title: language.albumDeleteConfirmation,
                    onAccept: (s) {
                      widget.callback!.call(widget.album.id!.toInt());
                    },
                    dialogType: DialogType.DELETE,
                  );
              },
              icon: Image.asset(ic_delete, color: Colors.white, height: 20, width: 20),
            ),
          ),
        Positioned(
          bottom: 8,
          left: 8,
          child: SizedBox(
            width: context.width() * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.album.name.validate(), maxLines: 1, overflow: TextOverflow.ellipsis, style: boldTextStyle(size: 14, color: Colors.white)),
                2.height,
                if (widget.album.description != " ")
                  Text(
                    widget.album.description.validate(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: secondaryTextStyle(size: 12, color: Colors.white),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
