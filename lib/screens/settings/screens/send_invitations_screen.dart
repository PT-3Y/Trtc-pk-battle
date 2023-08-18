import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/loading_widget.dart';
import '../../../main.dart';
import '../../../network/rest_apis.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';
import 'pending_invites_screen.dart';

// ignore: must_be_immutable
class SendInvitationsScreen extends StatefulWidget {
  SendInvitationsScreen({Key? key}) : super(key: key);

  @override
  State<SendInvitationsScreen> createState() => _SendInvitationsScreenState();
}

class _SendInvitationsScreenState extends State<SendInvitationsScreen> {
  final sendInvitationsFormKey = GlobalKey<FormState>();
  TextEditingController emailCont = TextEditingController();
  TextEditingController messageCont = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode messageNode = FocusNode();

  Future<void> sendInviteRequest() async {
    appStore.setLoading(true);
    await sendInvite(email: emailCont.text, message: messageCont.text, isResend: false).then((value) {
      toast(value.message, print: true);
      emailCont.clear();
      messageCont.clear();
      appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    emailNode.dispose();
    messageNode.dispose();
    appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.sendInvites, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_horiz),
            position: PopupMenuPosition.under,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
            onSelected: (value) {
              if (value == 0) {
                PendingInvitesScreen().launch(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(language.pendingInvites),
                textStyle: primaryTextStyle(),
                value: 0,
              ),
            ],
          ),
        ],
      ),
      body: Observer(
        builder: (_) => Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(language.sendInvitesSubtitle, style: secondaryTextStyle()),
                  16.height,
                  Form(
                    key: sendInvitationsFormKey,
                    child: Column(
                      children: [
                        AppTextField(
                          focus: emailNode,
                          nextFocus: messageNode,
                          enabled: !appStore.isLoading,
                          isValidationRequired: true,
                          controller: emailCont,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          textFieldType: TextFieldType.EMAIL,
                          errorThisFieldRequired: language.thisFiledIsRequired,
                          textStyle: boldTextStyle(),
                          decoration: inputDecorationFilled(
                            context,
                            label: language.emailAddressOfNewUser,
                            fillColor: context.cardColor,
                          ),
                        ),
                        16.height,
                        AppTextField(
                          focus: messageNode,
                          enabled: !appStore.isLoading,
                          isValidationRequired: false,
                          controller: messageCont,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          textFieldType: TextFieldType.MULTILINE,
                          maxLines: 5,
                          minLines: 5,
                          textStyle: boldTextStyle(),
                          decoration: inputDecorationFilled(
                            context,
                            label: language.addAPersonalizedMessage,
                            fillColor: context.cardColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.height,
                  appButton(
                      text: language.sendInvitation,
                      onTap: () {
                        hideKeyboard(context);
                        if (sendInvitationsFormKey.currentState!.validate() && emailCont.text.isNotEmpty) {
                          sendInviteRequest();
                        } else {
                          toast(language.pleaseEnterValidEmailId);
                        }
                      },
                      context: context)
                ],
              ),
            ),
            LoadingWidget().center().visible(appStore.isLoading)
          ],
        ),
      ),
    );
  }
}
