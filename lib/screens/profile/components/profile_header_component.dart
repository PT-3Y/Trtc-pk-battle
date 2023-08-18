import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/cached_network_image.dart';
import 'package:socialv/utils/constants.dart';

class ProfileHeaderComponent extends StatelessWidget {
  final String avatarUrl;
  final String? cover;

  ProfileHeaderComponent({required this.avatarUrl, this.cover});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          height: avatarUrl.isNotEmpty ? context.height() * 0.26 : context.height() * 0.2,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              cover.validate().isNotEmpty
                  ? cachedImage(
                      cover,
                      width: context.width(),
                      height: context.height() * 0.2,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      AppImages.profileBackgroundImage,
                      width: context.width(),
                      height: context.height() * 0.2,
                      fit: BoxFit.cover,
                    ),
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), shape: BoxShape.circle),
                  child: cachedImage(avatarUrl, height: 88, width: 88, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
                ),
              ).visible(avatarUrl.isNotEmpty),
            ],
          ),
        ),
      ],
    );
  }
}
