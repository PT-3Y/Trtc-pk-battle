import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/app_constants.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    localeLanguageList.forEach((element) {
      if (appStore.selectedLanguage == element.languageCode.validate()) {
        selectedIndex = localeLanguageList.indexOf(element);
        setState(() {});
      }
    });
  }

  Color? getSelectedColor(LanguageDataModel data) {
    if (appStore.selectedLanguage == data.languageCode.validate() && appStore.isDarkMode) {
      return Colors.white54;
    } else if (appStore.selectedLanguage == data.languageCode.validate() && !appStore.isDarkMode) {
      return appColorPrimary.withAlpha(40);
    } else {
      return null;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.appLanguage, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: localeLanguageList.length,
        itemBuilder: (context, index) {
          LanguageDataModel data = localeLanguageList[index];
          return Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            color: appStore.selectedLanguage == data.languageCode.validate() ? context.cardColor : context.scaffoldBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(data.flag.validate(), width: 20),
                    16.width,
                    Text(
                      '${data.name.validate()}',
                      style: boldTextStyle(
                          size: 14,
                          color: selectedIndex == index
                              ? context.iconColor
                              : appStore.isDarkMode
                                  ? bodyDark
                                  : bodyWhite),
                    ),
                  ],
                ),
                if (appStore.selectedLanguage == data.languageCode.validate()) Icon(Icons.check, color: appColorPrimary)
              ],
            ).onTap(
              () async {
                selectedIndex = index;
                setValue(SELECTED_LANGUAGE_CODE, data.languageCode);
                selectedLanguageDataModel = data;
                appStore.setLanguage(data.languageCode!, context: context);

                setState(() {});
                finish(context);
              },
            ),
          );
        },
      ),
    );
  }
}
