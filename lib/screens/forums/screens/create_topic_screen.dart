import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';

class CreateTopicScreen extends StatefulWidget {
  final String forumName;
  final int forumId;

  const CreateTopicScreen({Key? key, required this.forumName, required this.forumId}) : super(key: key);

  @override
  State<CreateTopicScreen> createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  final createTopicFormKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController tags = TextEditingController();

  bool doNotify = false;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> createTopic() async {
    if (createTopicFormKey.currentState!.validate()) {
      createTopicFormKey.currentState!.save();
      hideKeyboard(context);

      ifNotTester(() async {
        Map request = {
          "forum_id": widget.forumId,
          "topic_title": title.text,
          "topic_content": description.text,
          "tags": tags.text.split(','),
          "notify_me": doNotify,
          "image": image.text,
        };
        appStore.setLoading(true);

        await createForumsTopic(request: request).then((value) async {
          toast(value.message);
          appStore.setLoading(false);
          finish(context, true);
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString());
        });
      });
    } else {
      appStore.setLoading(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: createTopicFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${language.createNewTopicIn} ${widget.forumName}:', style: boldTextStyle(size: 20)),
                  16.height,
                  AppTextField(
                    controller: title,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    textFieldType: TextFieldType.NAME,
                    textStyle: boldTextStyle(),
                    decoration: inputDecorationFilled(context, fillColor: context.cardColor, label: '${language.topicTitleText}'),
                    onFieldSubmitted: (text) {
                      //addReview();
                    },
                  ),
                  16.height,
                  AppTextField(
                    controller: description,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    textFieldType: TextFieldType.MULTILINE,
                    textStyle: boldTextStyle(),
                    minLines: 5,
                    maxLines: 5,
                    decoration: inputDecorationFilled(context, fillColor: context.cardColor, label: language.description),
                    onFieldSubmitted: (text) {
                      //addReview();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return language.pleaseEnterDescription;
                      }
                      return null;
                    },
                  ),
                  16.height,
                  TextField(
                    controller: image,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    style: boldTextStyle(),
                    decoration: inputDecorationFilled(context, fillColor: context.cardColor, label: language.imageLink),
                  ),
                  16.height,
                  AppTextField(
                    controller: tags,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    textFieldType: TextFieldType.MULTILINE,
                    textStyle: boldTextStyle(),
                    minLines: 1,
                    maxLines: 5,
                    decoration: inputDecorationFilled(context, fillColor: context.cardColor, label: language.topicTags),
                    isValidationRequired: false,
                    onFieldSubmitted: (text) {
                      //addReview();
                    },
                  ),
                  Text(language.notePleaseAddComma, style: secondaryTextStyle()),
                  16.height,
                  Row(
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(borderRadius: radius(2)),
                        activeColor: context.primaryColor,
                        value: doNotify,
                        onChanged: (val) {
                          doNotify = !doNotify;
                          setState(() {});
                        },
                      ),
                      Text(language.notifyMeText, style: secondaryTextStyle()).onTap(() {
                        doNotify = !doNotify;
                        setState(() {});
                      }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                    ],
                  ),
                  16.height,
                  appButton(
                    context: context,
                    text: language.submit.capitalizeFirstLetter(),
                    onTap: () {
                      ifNotTester(() {
                        if (!appStore.isLoading) createTopic();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Observer(builder: (_) => LoadingWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
