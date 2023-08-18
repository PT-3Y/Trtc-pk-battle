import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/app_constants.dart';

class NoDataLottieWidget extends StatelessWidget {
  const NoDataLottieWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(no_data, height: 130);
  }
}

class EmptyPostLottieWidget extends StatelessWidget {
  const EmptyPostLottieWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(add_post, height: 100,repeat: true);
  }
}
