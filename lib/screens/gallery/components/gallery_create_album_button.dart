import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/no_data_lottie_widget.dart';
import '../../../main.dart';
import '../../../models/posts/media_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/images.dart';

class GalleryCreateAlbumButton extends StatefulWidget {
  final bool isEmptyList;
  final VoidCallback? callback;
  final List<MediaModel> mediaTypeList;

  const GalleryCreateAlbumButton({Key? key, required this.mediaTypeList, required this.isEmptyList, this.callback}) : super(key: key);

  @override
  State<GalleryCreateAlbumButton> createState() => _GalleryCreateAlbumButtonState();
}

class _GalleryCreateAlbumButtonState extends State<GalleryCreateAlbumButton> {
  @override
  Widget build(BuildContext context) {
    return widget.isEmptyList
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              EmptyPostLottieWidget(),
              Text(
                language.pushYourCreativityWithAlbums,
                style: secondaryTextStyle(),
                textAlign: TextAlign.center,
              ).paddingSymmetric(horizontal: 32),
              16.height,
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  side: MaterialStateProperty.all(BorderSide(color: appColorPrimary.withOpacity(0.5))),
                ),
                onPressed: () {
                  widget.callback!.call();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 20, color: context.iconColor),
                    4.width,
                    Text(language.addYourAlbum, style: primaryTextStyle(size: 14)),
                  ],
                ),
              ),
            ],
          )
        : Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(commonRadius),
                ),
                child: Column(
                  children: [
                    Image.asset(ic_plus, height: 22, width: 22, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                    8.height,
                    Text(language.createAlbum, style: secondaryTextStyle(size: 16)),
                  ],
                ),
              ).expand(),
            ],
          ).onTap(() {
            widget.callback!.call();
          }, highlightColor: Colors.transparent, hoverColor: Colors.transparent, splashColor: Colors.transparent);
  }
}
