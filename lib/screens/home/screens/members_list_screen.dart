import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/home/components/member_list_component.dart';
import 'package:socialv/screens/home/components/member_suggestion_list_component.dart';
import 'package:socialv/screens/settings/screens/coupon_list_screen.dart';
import 'package:socialv/screens/settings/screens/settings_screen.dart';
import 'package:socialv/utils/app_constants.dart';

// ignore: must_be_immutable
class MembersListScreen extends StatefulWidget {
  bool isSuggested;

  MembersListScreen({this.isSuggested = false});

  @override
  State<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text(widget.isSuggested.validate() ?language.suggestions:language.allMembers, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              useMaterial3: false,
            ),
            child: PopupMenuButton(
              enabled: !appStore.isLoading,
              position: PopupMenuPosition.under,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
              onSelected: (val) async {
                if (val == 1 && widget.isSuggested) {
                  widget.isSuggested = false;
                  setState(() {});
                } else if (val == 2 && !widget.isSuggested) {
                  widget.isSuggested = true;
                  setState(() {});
                }
              },
              icon: Icon(Icons.more_horiz),
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(
                  value: 1,
                  child: Text(language.allMembers),
                  textStyle: secondaryTextStyle(color: !widget.isSuggested ? appColorPrimary : null),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text(language.suggestions),
                  textStyle: secondaryTextStyle(color: widget.isSuggested ? appColorPrimary : null),
                ),
              ],
            ),
          ),
        ],
      ),
      body: widget.isSuggested ? MemberSuggestionListComponent() : MemberListComponent(),
    );
  }
}
