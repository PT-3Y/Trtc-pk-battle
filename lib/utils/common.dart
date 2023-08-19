import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/groups/group_response.dart';
import 'package:socialv/models/lms/quiz_answers.dart';
import 'package:socialv/models/members/member_response.dart';
import 'package:socialv/models/posts/media_model.dart';
import 'package:socialv/models/story/common_story_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/Trtc/Trtc_userinfo/Trtc_userinfo.dart';


import 'app_constants.dart';

InputDecoration inputDecoration(
  BuildContext context, {
  String? hint,
  String? label,
  TextStyle? hintStyle,
  TextStyle? labelStyle,
  Widget? prefix,
  EdgeInsetsGeometry? contentPadding,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    contentPadding: contentPadding,
    labelText: label,
    hintText: hint,
    hintStyle: hintStyle ?? secondaryTextStyle(),
    labelStyle: labelStyle ?? secondaryTextStyle(),
    prefix: prefix,
    prefixIcon: prefixIcon,
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: dividerColor)),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: context.primaryColor)),
    border: UnderlineInputBorder(borderSide: BorderSide(color: context.primaryColor)),
    focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
    alignLabelWithHint: true,
  );
}

InputDecoration inputDecorationFilled(
  BuildContext context, {
  String? label,
  EdgeInsetsGeometry? contentPadding,
  required Color fillColor,
  Widget? prefix,
  String? hint,
  TextStyle? hintStyle,
}) {
  return InputDecoration(
    fillColor: fillColor,
    filled: true,
    contentPadding: contentPadding ?? EdgeInsets.all(16),
    labelText: label ?? null,
    hintText: hint ?? null,
    hintStyle: hintStyle ?? secondaryTextStyle(weight: FontWeight.w600),
    labelStyle: secondaryTextStyle(weight: FontWeight.w600),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    enabledBorder: OutlineInputBorder(borderRadius: radius(defaultAppButtonRadius), borderSide: BorderSide(color: context.cardColor)),
    disabledBorder: OutlineInputBorder(borderRadius: radius(defaultAppButtonRadius), borderSide: BorderSide(color: context.cardColor)),
    focusedBorder: OutlineInputBorder(borderRadius: radius(defaultAppButtonRadius), borderSide: BorderSide(color: context.cardColor)),
    border: OutlineInputBorder(borderRadius: radius(defaultAppButtonRadius), borderSide: BorderSide(color: context.cardColor)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
    alignLabelWithHint: true,
    prefix: prefix,
  );
}

Widget headerContainer({required Widget child, required BuildContext context}) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        width: context.width(),
        decoration: BoxDecoration(color: context.primaryColor, borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
        padding: EdgeInsets.all(22),
        child: child,
      ),
      Container(
        height: 20,
        decoration: BoxDecoration(color: context.cardColor, borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
      )
    ],
  );
}

Widget appButton({
  required String text,
  required Function onTap,
  double? width,
  double? height,
  ShapeBorder? shapeBorder,
  required BuildContext context,
  Color? color,
  TextStyle? textStyle,
}) {
  return AppButton(
    shapeBorder: shapeBorder ?? RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius)),
    text: text,
    textStyle: textStyle ?? boldTextStyle(color: Colors.white),
    onTap: onTap,
    elevation: 0,
    color: color ?? context.primaryColor,
    width: width ?? context.width() - 32,
    height: height ?? 56,
  );
}

Future<File?> getImageSource({bool isCamera = true, bool isVideo = false}) async {
  final picker = ImagePicker();

  XFile? pickedImage;
  if (isVideo) {
    await picker.pickVideo(source: isCamera ? ImageSource.camera : ImageSource.gallery).then((value) {
      pickedImage = value;
    }).catchError((e) {
      log('Error: ${e.toString()}');
    });
  } else {
    pickedImage = await picker.pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
  }

  return File(pickedImage!.path);
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

void onShareTap(BuildContext context) async {
  if (isAndroid) {
    Share.share('Share $APP_NAME app $playStoreBaseURL${await getPackageName()}');
  } else {
    Share.share('Share $APP_NAME app $IOS_APP_LINK');
  }
}

String getFormattedDate(String date) => DateFormat.yMMMMd('en_US').format(DateTime.parse(date));

List<MemberResponse> getMemberListPref() {
  if (getStringAsync(SharePreferencesKey.RECENT_SEARCH_MEMBERS).isNotEmpty)
    return (json.decode(getStringAsync(SharePreferencesKey.RECENT_SEARCH_MEMBERS)) as List).map((i) => MemberResponse.fromJson(i)).toList();
  return [];
}

List<GroupResponse> getGroupListPref() {
  if (getStringAsync(SharePreferencesKey.RECENT_SEARCH_GROUPS).isNotEmpty)
    return (json.decode(getStringAsync(SharePreferencesKey.RECENT_SEARCH_GROUPS)) as List).map((i) => GroupResponse.fromJson(i)).toList();
  return [];
}

List<QuizAnswers> getLmsQuizListPref() {
  if (getStringAsync(SharePreferencesKey.LMS_QUIZ_LIST).isNotEmpty) {
    return (json.decode(getStringAsync(SharePreferencesKey.LMS_QUIZ_LIST)) as List).map((i) => QuizAnswers.fromJson(i)).toList();
  } else {
    return [];
  }
}

class TabIndicator extends Decoration {
  final BoxPainter painter = TabPainter();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => painter;
}

class TabPainter extends BoxPainter {
  Paint? _paint;

  TabPainter() {
    _paint = Paint()..color = Colors.white;
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Size size = Size(configuration.size!.width, 4);
    Offset _offset = Offset(offset.dx, offset.dy + 36);
    final Rect rect = _offset & size;
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          bottomRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        _paint!);
  }
}

Future<List<File>> getMultipleFiles({required MediaModel mediaType}) async {
  FilePickerResult? filePickerResult;
  List<File> imgList = [];

  FileType type = FileType.custom;

  if (isIOS) {
    log('${mediaType.type}');
    if (mediaType.type == MediaTypes.photo)
      type = FileType.image;
    else if (mediaType.type == MediaTypes.video)
      type = FileType.video;
    else
      type = FileType.custom;
  } else {
    type = FileType.custom;
  }

  filePickerResult = await FilePicker.platform.pickFiles(allowMultiple: true, type: type, allowedExtensions: type == FileType.custom ? mediaType.allowedType.validate() : null);

  if (filePickerResult != null) {
    filePickerResult.files.forEach((element) {
      log('element: ${element.path.validate().split("/").last.split(".").last}');

      if (element.path.validate().split("/").last.split(".").last.isNotEmpty && mediaType.allowedType!.any((e) => e == element.path.validate().split("/").last.split(".").last)) {
        imgList.add(File(element.path!));
      } else {
        toast(language.cannotAddThisFile);
      }
    });
  }
  return imgList;
}

String getFileExtension(String fileName) {
  try {
    return "." + fileName.split('.').last;
  } catch (e) {
    return '';
  }
}

String convertToAgo(String dateTime) {
  if (dateTime.isNotEmpty) {
    DateTime input = DateFormat(dateTime.contains('T') ? DATE_FORMAT_2 : DATE_FORMAT_1).parse(dateTime, true);

    return socialvFormatTime(input.millisecondsSinceEpoch);
  } else {
    return '';
  }
}

String formatDate(String date) {
  DateTime input = DateFormat(DATE_FORMAT_2).parse(date, true);

  return DateFormat.yMMMMd().format(input).toString();
}

Future<void> openWebPage(BuildContext context, {required String url}) async {
  final theme = Theme.of(context);
  try {
    await launch(
      url,
      customTabsOption: CustomTabsOption(
        toolbarColor: theme.primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: CustomTabsSystemAnimation.slideIn(),
        extraCustomTabs: const <String>['org.mozilla.firefox', 'com.microsoft.emmx'],
      ),
      safariVCOption: SafariViewControllerOption(
        preferredBarTintColor: theme.primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

void ifNotTester(VoidCallback callback) {
  if (appStore.loginEmail == DEMO_USER_EMAIL) {
    toast(language.demoUserText);
  } else {
    callback.call();
  }
}

Future<List<MediaSourceModel>> getMultipleImages() async {
  FilePickerResult? filePickerResult;
  List<MediaSourceModel> imgList = [];
  filePickerResult = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.media);
  String mediaType = MediaTypes.photo;

  if (filePickerResult != null) {
    filePickerResult.files.forEach((element) {
      log('element: ${element.path.validate().split("/").last.split(".").last}');

      if (allowedVideoExtensions.any((e) => e == element.path.validate().split("/").last.split(".").last)) {
        mediaType = MediaTypes.video;
      }

      if (element.path.validate().split("/").last.split(".").last.isNotEmpty) {
        imgList.add(MediaSourceModel(
          mediaFile: File(element.path!),
          mediaType: mediaType,
          extension: element.path.validate().split("/").last.split(".").last,
        ));
      } else {
        toast('Cannot add this file');
      }
    });
  }
  return imgList;
}

String timeStampToDate(int time) {
  final DateTime input = DateTime.fromMillisecondsSinceEpoch(time * 1000);

  return input.timeAgo;
}

String getPrice(String price) {
  if (price.length > 2) {
    return price.substring(0, price.length - 2);
  } else {
    return price;
  }
}

void setStatusBarColorBasedOnTheme() {
  setStatusBarColor(appStore.isDarkMode ? appBackgroundColorDark : appLayoutBackground);
}

Future<bool> get isIqonicProduct async => await getPackageName() == APP_PACKAGE_NAME;

Future<GiphyGif?> selectGif({required BuildContext context}) async {
  GiphyGif? gif;

  await GiphyGet.getGif(
    context: context,
    apiKey: isIOS ? getStringAsync(SharePreferencesKey.IOS_GIPHY_API_KEY) : getStringAsync(SharePreferencesKey.GIPHY_API_KEY),
    tabColor: context.primaryColor,
    debounceTimeInMilliseconds: 350,
    showEmojis: false,
    showStickers: false,
  ).then((value) {
    if (value != null) {
      gif = value;
    }
  });

  return gif;
}

String socialvFormatTime(int timestamp) {
  int difference = DateTime.now().millisecondsSinceEpoch - timestamp;
  String result;

  if (difference < 60000) {
    result = countSeconds(difference);
  } else if (difference < 3600000) {
    result = countMinutes(difference);
  } else if (difference < 86400000) {
    result = countHours(difference);
  } else if (difference < 604800000) {
    result = countDays(difference);
  } else if (difference / 1000 < 2419200) {
    result = countWeeks(difference);
  } else if (difference / 1000 < 31536000) {
    result = countMonths(difference);
  } else
    result = countYears(difference);

  return result != language.justNow.capitalizeFirstLetter() ? result + ' ${language.ago.toLowerCase()}' : result;
}

String countSeconds(int difference) {
  int count = (difference / 1000).truncate();
  return count > 1 ? count.toString() + ' ${language.second}' : '${language.justNow.capitalizeFirstLetter()}';
}

String countMinutes(int difference) {
  int count = (difference / 60000).truncate();
  return count.toString() + (count > 1 ? ' ${language.minutes}' : ' ${language.minute}');
}

String countHours(int difference) {
  int count = (difference / 3600000).truncate();
  return count.toString() + (count > 1 ? ' ${language.hours}' : ' ${language.hour}');
}

String countDays(int difference) {
  int count = (difference / 86400000).truncate();
  return count.toString() + (count > 1 ? ' ${language.days}' : ' ${language.day}');
}

String countWeeks(int difference) {
  int count = (difference / 604800000).truncate();
  if (count > 3) {
    return '${language.oneMonth}';
  }
  return count.toString() + (count > 1 ? ' ${language.weeks}' : ' ${language.week}');
}

String countMonths(int difference) {
  int count = (difference / 2628003000).round();
  count = count > 0 ? count : 1;
  if (count > 12) {
    return '${language.oneYear}';
  }
  return count.toString() + (count > 1 ? ' ${language.months}' : ' ${language.month}');
}

String countYears(int difference) {
  int count = (difference / 31536000000).truncate();
  return count.toString() + (count > 1 ? ' ${language.years}' : ' ${language.year}');
}

void initializeOneSignal() async {
  OneSignal.shared.setAppId(getStringAsync(ONESIGNAL_APP_ID, defaultValue: ONESIGNAL_APP_ID)).then((value) async {
    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      //
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      event.complete(event.notification);
    });

    OneSignal.shared.consentGranted(true);
    OneSignal.shared.promptUserForPushNotificationPermission();

    final status = await OneSignal.shared.getDeviceState();

    log('--------------------------------');
    log(status?.userId.validate());
    if (status!.userId.validate().isNotEmpty) setValue(SharePreferencesKey.ONE_SIGNAL_PLAYER_ID, status.userId.validate());
  });
}

String getPostContent(String? postContent) {
  String content = '';

  content = postContent
      .validate()
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('[embed]', '<embed>')
      .replaceAll('[/embed]', '</embed>')
      .replaceAll('[caption]', '<caption>')
      .replaceAll('[/caption]', '</caption>')
      .replaceAll('[blockquote]', '<blockquote>')
      .replaceAll('[/blockquote]', '</blockquote>')
      .replaceAll('\t', '')
      .replaceAll('\n', '');

  return content;
}

Future<void> activeUser() async {
  await updateActiveStatus().then((value) {
    Future.delayed(Duration(minutes: updateActiveStatusDuration), () {
      activeUser();
    });
  }).catchError((e) {
    log('Error: ${e.toString()}');
    Future.delayed(Duration(minutes: updateActiveStatusDuration), () {
      activeUser();
    });
  });
}

Future<void> getNotificationCount() async {
  await notificationCount().then((value) {
    appStore.setNotificationCount(value.notificationCount.validate());
    messageStore.setMessageCount(value.unreadMessagesCount.validate());
    Future.delayed(Duration(minutes: updateActiveStatusDuration), () {
      getNotificationCount();
    });
  }).catchError((e) {
    log('Error: ${e.toString()}');
    Future.delayed(Duration(minutes: updateActiveStatusDuration), () {
      getNotificationCount();
    });
  });
}

String getAvatarUrlFromUserId(String userId) {
  String avatar = '';
  List<MemberResponse> memberList = appStore.allMemberList;
  for (MemberResponse member in memberList) {
    if (member.id.toString() == userId) {
      avatar = member.avatarUrls?.full.validate() ?? '';
      break;
    }
  }
  return avatar;
}

TrtcUserInfo getUserInfoFromUserId(String userId) {
  String name = '';
  List<MemberResponse> memberList = appStore.allMemberList;
  for (MemberResponse member in memberList) {
    if (member.id.toString() == userId) {
      name = member.name ?? '';
      break;
    }
  }
  return TrtcUserInfo(userId: userId, userName: name);
}
