import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/messages/messages_model.dart';
import 'package:socialv/screens/messages/screens/view_message_media_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class MessageMediaComponent extends StatefulWidget {
  final List<MessageFiles>? files;

  const MessageMediaComponent({Key? key, this.files}) : super(key: key);

  @override
  State<MessageMediaComponent> createState() => _MessageMediaComponentState();
}

class _MessageMediaComponentState extends State<MessageMediaComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ViewMessageMediaScreen(files: widget.files).launch(context);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Wrap(
        spacing: 8,
        children: widget.files.validate().take(2).map((e) {
          String type = e.mimeType.validate().substring(0, e.mimeType.validate().indexOf('/'));

          return Stack(
            children: [
              if (type == MediaTypes.image)
                cachedImage(e.thumb, height: 80, width: 80, fit: BoxFit.cover).cornerRadiusWithClipRRect(commonRadius)
              else if (type == MediaTypes.video)
                Container(
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                  height: 80,
                  width: 80,
                  padding: EdgeInsets.all(20),
                  child: Image.asset(ic_video, height: 20, width: 20, fit: BoxFit.cover),
                ),
              if (widget.files.validate().indexOf(e) == 1 && widget.files!.length > 2)
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: radius(commonRadius),
                  ),
                  child: Text('+ ${widget.files.validate().length - 2}', style: boldTextStyle(color: Colors.white, size: 20)).center(),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
