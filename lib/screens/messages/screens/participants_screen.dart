import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/messages/message_users.dart';
import 'package:socialv/network/messages_repository.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../models/messages/messages_model.dart';
import '../../../models/messages/threads_model.dart';
import '../../../utils/app_constants.dart';
import '../components/add_new_participant_component.dart';

// ignore: must_be_immutable
class ParticipantsScreen extends StatefulWidget {
  final int participantsCount;
  final bool? isModerator;
  final bool? canInvite;
  List<MessagesUsers> user;
  final int? threadId;
  List<Messages>? messages;
  Threads? thread;

  ParticipantsScreen({required this.participantsCount, required this.user, this.threadId, this.isModerator, this.canInvite, this.messages, this.thread});

  @override
  State<ParticipantsScreen> createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  bool isRefresh = false;
  TextEditingController subjectController = TextEditingController();
  bool allowOtherToInvite = false;

  @override
  void initState() {
    super.initState();
    allowOtherToInvite = widget.canInvite.validate();
  }

  Future<void> removeChatParticipant({required int id}) async {
    appStore.setLoading(true);
    await removeParticipant(userId: id, threadId: widget.threadId.validate()).then((value) {
      widget.user.removeWhere((element) {
        return element.userId == id;
      });
      isRefresh = true;
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  Future<void> allowOthersToInvite() async {
    appStore.setLoading(true);
    await allowOtherToInviteMembers(canInvite: allowOtherToInvite, threadId: widget.threadId.validate()).then((value) {
      isRefresh = true;
      appStore.setLoading(false);
      finish(context, isRefresh);
    }).catchError((e) {
      isRefresh = true;
      appStore.setLoading(false);
      finish(context, isRefresh);
    });
  }

  Future<void> changeSubject() async {
    appStore.setLoading(true);
    await changeSubjectOfParticipants(subject: subjectController.text, threadId: widget.threadId.validate()).then((value) {
      isRefresh = true;
      appStore.setLoading(false);
    }).catchError((e) {
      isRefresh = true;
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  Future<void> refreshThread() async {
    appStore.setLoading(true);
    await getSpecificThread(threadId: widget.threadId.validate()).then((value) async {
      widget.messages.validate().clear();
      widget.messages = value.messages.validate().reversed.validate();
      widget.thread = value.threads.validate().first;
      widget.user = value.users.validate();
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.canInvite.validate() != allowOtherToInvite) {
          allowOthersToInvite();
        } else {
          finish(context, isRefresh);
        }
        isRefresh = false;
        return Future.value(true);
      },
      child: Observer(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(language.participants.capitalizeFirstLetter(), style: boldTextStyle(size: 20)),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.iconColor),
              onPressed: () {
                if (widget.canInvite.validate() != allowOtherToInvite) {
                  allowOthersToInvite();
                } else {
                  finish(context, isRefresh);
                }
                isRefresh = false;
              },
            ),
            actions: [
              if (widget.isModerator.validate() || widget.canInvite.validate())
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      isDismissible: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return FractionallySizedBox(
                          heightFactor: 0.8,
                          child: AddNewParticipantComponent(
                            threadId: widget.threadId.validate(),
                            callback: () {
                              finish(context);
                              isRefresh = true;
                              refreshThread();
                            },
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add_circle_outline),
                  color: appColorPrimary,
                  iconSize: 24,
                ),
            ],
          ),
          body: appStore.isLoading
              ? LoadingWidget()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      if (widget.isModerator.validate())
                        Column(
                          children: [
                            16.height,
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(language.conversationSettings, style: boldTextStyle(size: 18)),
                            ).paddingSymmetric(horizontal: 16),
                            16.height,
                            AppTextField(
                              textFieldType: TextFieldType.NAME,
                              controller: subjectController,
                              decoration: inputDecorationFilled(
                                context,
                                fillColor: context.cardColor,
                                label: language.changeConversationSubject,
                              ),
                              onFieldSubmitted: (p0) {
                                if (subjectController.text.trim().isNotEmpty) {
                                  changeSubject();
                                }
                              },
                            ).paddingSymmetric(horizontal: 16),
                            16.height,
                            CheckboxListTile(
                              title: Text(language.allowInviteText, style: primaryTextStyle(size: 16)),
                              subtitle: Text(language.enableInviteConversation, style: secondaryTextStyle(size: 12)),
                              isThreeLine: true,
                              value: allowOtherToInvite,
                              onChanged: (value) {
                                setState(() {
                                  allowOtherToInvite = !allowOtherToInvite;
                                });
                              },
                            )
                          ],
                        ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.user.length,
                        itemBuilder: (ctx, index) {
                          MessagesUsers element = widget.user[index];

                          return Row(
                            children: [
                              cachedImage(element.avatar.validate(), height: 36, width: 36, fit: BoxFit.cover).cornerRadiusWithClipRRect(18),
                              16.width,
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: '${element.name.validate()} ', style: primaryTextStyle(fontFamily: fontFamily)),
                                    if (element.verified.validate() == 1) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ).expand(),
                              if (element.id.validate() != appStore.loginUserId)
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    useMaterial3: false,
                                  ),
                                  child: PopupMenuButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
                                    onSelected: (val) async {
                                      if (val == 1) {
                                        if (element.blocked == 0) {
                                          element.blocked = 1;
                                          blockUser(userId: element.userId.validate());
                                        } else {
                                          element.blocked = 0;
                                          unblockUser(userId: element.userId.validate());
                                        }
                                        setState(() {});
                                      } else {
                                        removeChatParticipant(id: element.userId.validate());
                                      }
                                    },
                                    icon: Icon(Icons.more_horiz),
                                    itemBuilder: (context) => <PopupMenuEntry>[
                                      if (element.canBlock == 1)
                                        PopupMenuItem(
                                          value: 1,
                                          child: TextIcon(
                                            text: element.blocked.validate() == 0 ? language.block : language.unblock,
                                            textStyle: secondaryTextStyle(),
                                          ),
                                        ),
                                      if (widget.isModerator.validate())
                                        PopupMenuItem(
                                          value: 2,
                                          child: TextIcon(
                                            text: language.kickParticipant,
                                            textStyle: secondaryTextStyle(),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ).paddingSymmetric(vertical: 8);
                        },
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
