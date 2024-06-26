import 'package:flutter/material.dart';
import 'package:running_app/utils/constants.dart';

class EventLeaderboardText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final fontWeight;

  EventLeaderboardText({
    this.fontSize,
    this.fontWeight,
    this.color,
    required this.text,
    Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? TColor.PRIMARY_TEXT,
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight),
      // overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}