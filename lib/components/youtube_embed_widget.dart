import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/youtube_player_component.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher_string.dart';

class YouTubeEmbedWidget extends StatelessWidget {
  final String videoId;
  final bool? fullIFrame;

  YouTubeEmbedWidget(this.videoId, {this.fullIFrame});

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerComponent(id: videoId);
  }
}
