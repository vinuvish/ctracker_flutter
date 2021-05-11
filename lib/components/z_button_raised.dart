import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ZButtonRaised extends StatelessWidget {
  final GestureTapCallback onTap;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color backgroundColor;
  final String text;
  final double elevation;
  final double width;
  final double height;
  final ShapeBorder shapeBorder;
  final bool isUpperCaseText;
  final TextStyle textStyle;
  final bool isLoading;

  ZButtonRaised({
    @required this.onTap,
    @required this.text,
    this.backgroundColor,
    this.elevation,
    this.height,
    this.isUpperCaseText = true,
    this.margin,
    this.padding,
    this.shapeBorder,
    this.textStyle,
    this.width,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: height ?? 42,
      width: width ?? double.infinity,
      child: RaisedButton(
        padding: padding ?? null,
        shape: shapeBorder ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: elevation ?? null,
        color: backgroundColor ?? Theme.of(context).buttonColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              Row(children: [
                Center(
                    child: SpinKitFadingCircle(color: Colors.white, size: 25)),
                SizedBox(width: 5)
              ]),
            if (!isLoading)
              Text(isUpperCaseText ? text.toUpperCase() : text,
                  textScaleFactor: 1.0,
                  style: textStyle ??
                      TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          if (!isLoading) onTap();
        },
      ),
    );
  }
}
