import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher_string.dart';

class VimeoEmbedWidget extends StatelessWidget {
  final String videoId;

  VimeoEmbedWidget(this.videoId);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Html(
        data:
            '<iframe src="https://player.vimeo.com/video/$videoId" width="640" height="360" frameborder="0" allow="autoplay; fullscreen" allowfullscreen="allowfullscreen" mozallowfullscreen="mozallowfullscreen" msallowfullscreen="msallowfullscreen" oallowfullscreen="oallowfullscreen" webkitallowfullscreen="webkitallowfullscreen"></iframe>',
      ),
    ).onTap(() {
      url_launcher.launchUrl(Uri.parse('https://player.vimeo.com/video/$videoId'), mode: LaunchMode.inAppWebView);
    });
  }
}
