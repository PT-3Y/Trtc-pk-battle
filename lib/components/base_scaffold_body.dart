import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';

class Body extends StatelessWidget {
  final Widget child;
  final bool showLoader;

  const Body({Key? key, required this.child, this.showLoader = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      height: context.height(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          Observer(builder: (_) => LoadingWidget().center().visible(appStore.isLoading && showLoader)),
        ],
      ),
    );
  }
}
