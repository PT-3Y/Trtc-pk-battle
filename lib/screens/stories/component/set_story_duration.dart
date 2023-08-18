import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:socialv/main.dart';

class SetStoryDuration extends StatefulWidget {
  final Function(int)? onTap;
  final int initialValue;

  const SetStoryDuration({required this.onTap, required this.initialValue});

  @override
  State<SetStoryDuration> createState() => _SetStoryDurationState();
}

class _SetStoryDurationState extends State<SetStoryDuration> {
  int current = 3;

  @override
  void initState() {
    super.initState();

    current = widget.initialValue;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Colors.transparent, Colors.white, Colors.transparent],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: NumberPicker(
                minValue: 1,
                maxValue: 30,
                value: current,
                onChanged: (val) {
                  current = val;
                  setState(() {});
                },
                axis: Axis.horizontal,
                itemWidth: 50,
                selectedTextStyle: primaryTextStyle(color: context.primaryColor, size: 24),
                textStyle: secondaryTextStyle(),
              ),
            ).expand(),
            8.width,
            Text('seconds', style: primaryTextStyle()),
          ],
        ),
        16.height,
        Row(
          children: [
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultAppButtonRadius),
                )),
              ),
              onPressed: () {
                finish(context, false);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.close, color: textPrimaryColorGlobal, size: 20),
                  6.width,
                  Text(language.cancel, style: primaryTextStyle()),
                ],
              ).fit(),
            ).expand(),
            16.width,
            AppButton(
              elevation: 0,
              color: context.primaryColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, color: Colors.white, size: 20),
                  6.width,
                  Text(language.set, style: boldTextStyle(color: Colors.white)),
                ],
              ).fit(),
              onTap: () {
                widget.onTap!.call(current);
              },
            ).expand(),
          ],
        ),
      ],
    );
  }
}
