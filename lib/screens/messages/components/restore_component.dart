import 'package:flutter/material.dart';
import 'package:linear_timer/linear_timer.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/messages_repository.dart';

import '../../../utils/app_constants.dart';

class RestoreComponent extends StatefulWidget {
  final int threadId;
  final Function(bool) callback;

  const RestoreComponent({required this.threadId, required this.callback});

  @override
  State<RestoreComponent> createState() => _RestoreComponentState();
}

class _RestoreComponentState extends State<RestoreComponent> with TickerProviderStateMixin {
  LinearTimerController? restoreChatController;

  bool isRestored = false;

  @override
  void initState() {
    super.initState();

    restoreChatController = LinearTimerController(this);

    afterBuildCreated(() => restoreChatController!.start());
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    restoreChatController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width() / 1.5,
      decoration: BoxDecoration(
        color: isRestored
            ? appGreenColor
            : appStore.isDarkMode
                ? bodyDark
                : bodyWhite,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRestored)
            Row(
              children: [
                SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                ),
                16.width,
                Text(language.restoring, style: boldTextStyle(color: Colors.white)),
              ],
            ).paddingAll(16)
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info, color: Colors.white),
                8.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.conversationDeleted, style: boldTextStyle(color: Colors.white)),
                    Text(
                      language.restore,
                      style: secondaryTextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ).onTap(() async {
                      isRestored = true;

                      setState(() {});
                      await restoreThread(threadId: widget.threadId.validate()).then((value) {
                        widget.callback.call(true);
                      }).catchError((e) {
                        toast(e.toString());
                      });
                    })
                  ],
                ),
              ],
            ).paddingAll(16),
          LinearTimer(
            forward: false,
            duration: Duration(seconds: 10),
            color: Colors.white,
            backgroundColor: Colors.black,
            controller: restoreChatController,
            onTimerEnd: () {
              widget.callback.call(false);
            },
          ),
        ],
      ),
    );
  }
}
