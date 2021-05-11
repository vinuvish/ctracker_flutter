import 'package:flutter/material.dart';

class ZButtonText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;

  final GestureTapCallback onTap;
  const ZButtonText(
      {Key key, @required this.text, @required this.onTap, this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(text, textScaleFactor: 1.0, style: textStyle ?? null)),
    );
  }
}
