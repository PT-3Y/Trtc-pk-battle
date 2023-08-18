import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/base_scaffold_body.dart';

class AppScaffold extends StatelessWidget {
  final String? appBarTitle;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  final Widget child;
  final Color? scaffoldBackgroundColor;
  final Widget? bottomNavigationBar;

  AppScaffold({this.appBarTitle, required this.child, this.actions, this.scaffoldBackgroundColor, this.bottomNavigationBar, this.onBack});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (onBack != null) {
          onBack?.call();
        } else {
          finish(context);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle.validate(), style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.iconColor),
            onPressed: () {
              if (onBack != null) {
                onBack?.call();
              } else {
                finish(context);
              }
            },
          ),
          actions: actions,
        ),
        backgroundColor: scaffoldBackgroundColor ?? context.scaffoldBackgroundColor,
        body: Body(child: child),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
