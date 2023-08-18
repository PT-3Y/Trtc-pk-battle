import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/messages/screens/new_chat_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class InitialMessageComponent extends StatelessWidget {
  final String title;
  final bool showButton;

  InitialMessageComponent({required this.title, this.showButton = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.height() / 6),
        cachedImage(ic_start_chat, color: context.iconColor, fit: BoxFit.cover, height: 100, width: 100),
        16.height,
        Text(title, style: boldTextStyle()),
        16.height,
        if (showButton)
          appButton(
            context: context,
            text: language.startANewConversation,
            onTap: () {
              NewChatScreen().launch(context);
            },
          ),
      ],
    );
  }
}
