import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/post/components/audio_component.dart';

import '../../../utils/app_constants.dart';

class AudioPostScreen extends StatelessWidget {
  final String audioUrl;

  const AudioPostScreen(this.audioUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text(audioUrl.split('/').last, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: context.width() - 32,
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: radius(defaultAppButtonRadius),
            ),
            child: Image.asset(ic_voice),
          ).paddingTop(16),
          16.height,
          AudioPostComponent(audioURl: audioUrl),
        ],
      ),
    );
  }
}
