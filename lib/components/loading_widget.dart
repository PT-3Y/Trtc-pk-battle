import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/app_constants.dart';

class LoadingWidget extends StatelessWidget {
  final bool isBlurBackground;

  const LoadingWidget({this.isBlurBackground = true});

  @override
  Widget build(BuildContext context) {
    return isBlurBackground
        ? SizedBox(
            height: context.height(),
            width: context.width(),
            child: SpinKitFadingCircle(
              size: 40,
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appColorPrimary,
                  ),
                );
              },
            ),
          )
        : SpinKitFadingCircle(
            size: 40,
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColorPrimary,
                ),
              );
            },
          );
  }
}

class ThreeBounceLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      size: 30,
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: appColorPrimary,
          ),
        );
      },
    );
  }
}
