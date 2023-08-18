import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/settings/screens/pending_invites_screen.dart';

import '../../../main.dart';
import '../../../models/invitations/invite_list_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/images.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class PendingInvitesCardComponent extends StatefulWidget {
  final InviteListModel inviteList;
  bool isChecked;

  final bool isSent;
  final Function(int id, bool?)? callback;

  PendingInvitesCardComponent({Key? key, required this.inviteList, required this.isChecked, required this.isSent, this.callback}) : super(key: key);

  @override
  State<PendingInvitesCardComponent> createState() => _PendingInvitesCardComponentState();
}

class _PendingInvitesCardComponentState extends State<PendingInvitesCardComponent> {
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.inviteList.dateModified.validate().substring(0, 10)));
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        widget.isChecked = !widget.isChecked;
        setState(() {
          if (widget.isChecked) {
            selectedInviteRequests.add(widget.inviteList.id);
            appStore.setMultiSelect(true);
          } else {
            selectedInviteRequests.remove(widget.inviteList.id);
            if (selectedInviteRequests.isEmpty) {
              appStore.setMultiSelect(false);
              isChecked = false;
            }
          }
        });
      },
      onTap: () {
        if (appStore.isMultiSelect) {
          setState(() {
            if (selectedInviteRequests.contains(widget.inviteList.id)) {
              selectedInviteRequests.remove(widget.inviteList.id);
              if (selectedInviteRequests.isEmpty) {
                appStore.setMultiSelect(false);
                isChecked = false;
              }
            } else {
              widget.isChecked = !widget.isChecked;
              if (widget.isChecked) {
                selectedInviteRequests.add(widget.inviteList.id);
                appStore.setMultiSelect(true);
              } else {
                selectedInviteRequests.remove(widget.inviteList.id);
              }
            }
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: selectedInviteRequests.contains(widget.inviteList.id) ? greenColor.withAlpha(20) : context.cardColor, borderRadius: BorderRadius.circular(commonRadius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.inviteList.email.validate(),
              style: boldTextStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            8.height,
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: formattedDate,
                style: secondaryTextStyle(size: 12),
                /*children: [
                  TextSpan(
                    text: widget.inviteList.dateModified.validate().substring(10),
                    style: secondaryTextStyle(size: 10)
                  ),
                ]*/
              ),
            ),
            16.height,
            ReadMoreText(
              widget.inviteList.message.validate(),
              style: primaryTextStyle(),
              trimLines: 3,
              colorClickableText: appColorPrimary,
              trimMode: TrimMode.Line,
            ),
            16.height,
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: "${language.send}: ",
                    style: secondaryTextStyle(),
                    children: [
                      WidgetSpan(child: Icon(widget.isSent ? Icons.check_circle : Icons.circle_outlined, size: 16, color: appColorPrimary)),
                    ],
                  ),
                ),
                16.width,
                RichText(
                  text: TextSpan(
                    text: "${language.accepted}: ",
                    style: secondaryTextStyle(),
                    children: [
                      WidgetSpan(child: Icon(Icons.circle_outlined, size: 16, color: appColorPrimary)),
                    ],
                  ),
                ),
              ],
            ),
            16.height,
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: appColorPrimary.withAlpha(30), borderRadius: BorderRadius.circular(commonRadius)),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Image.asset(
                    ic_send,
                    color: appColorPrimary,
                    height: 20,
                    width: 20,
                  ),
                )
                    .onTap(() {
                      if (selectedInviteRequests.isEmpty) widget.callback?.call(widget.inviteList.id.validate().toInt(), true);
                    })
                    .withTooltip(msg: language.resendInvitation)
                    .expand(),
                16.width,
                Container(
                  decoration: BoxDecoration(color: redColor.withAlpha(30), borderRadius: BorderRadius.circular(commonRadius)),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Image.asset(
                    ic_shield_fail,
                    color: redColor,
                    height: 20,
                    width: 20,
                  ),
                )
                    .onTap(() {
                      if (selectedInviteRequests.isEmpty)
                        showConfirmDialogCustom(
                          context,
                          title: language.cancelInviteRequest,
                          onAccept: (s) {
                            widget.callback?.call(widget.inviteList.id.validate().toInt(), false);
                          },
                          dialogType: DialogType.CONFIRMATION,
                        );
                    })
                    .withTooltip(msg: language.cancel)
                    .expand(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
