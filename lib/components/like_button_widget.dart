import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';

import '../utils/app_constants.dart';

class LikeButtonWidget extends StatefulWidget {
  final VoidCallback onPostLike;
  final bool isPostLiked;
  final Key? key;

  const LikeButtonWidget({this.key, required this.onPostLike, required this.isPostLiked});

  @override
  State<LikeButtonWidget> createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  bool _isLiked = false;
  AnimationController? _controller;

  @override
  void initState() {
    _isLiked = widget.isPostLiked;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null) {
      _scale = 1 - _controller!.value;
    }
    return Listener(
      key: widget.key,
      onPointerDown: (details) {
        _controller?.forward();
      },
      onPointerUp: (details) {
        _controller?.reverse();
      },
      child: Transform.scale(
        scale: _scale,
        child: Image.asset(
          _isLiked ? ic_heart_filled : ic_heart,
          height: _isLiked ? 20 : 22,
          width: 22,
          fit: BoxFit.fill,
          color: _isLiked ? Colors.red : context.iconColor,
        ).onTap(() async {
          if (!appStore.isLoading) {
            ifNotTester(() async {
              _isLiked = !_isLiked;
              setState(() {});
              await Future.delayed(Duration.zero);
              widget.onPostLike.call();
            });
          }
        }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
      ),
    );
  }
}
