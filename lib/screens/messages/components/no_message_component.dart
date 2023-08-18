import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class NoMessageComponent extends StatelessWidget {
  final String? errorText;

  NoMessageComponent({this.errorText});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: context.height() / 4),
          cachedImage(ic_start_chat, color: context.iconColor, fit: BoxFit.cover, height: 100, width: 100),
          16.height,
          Text(errorText.validate().isNotEmpty ? errorText.validate() : language.newConversationText, style: boldTextStyle()),
        ],
      ),
    );
  }
}
