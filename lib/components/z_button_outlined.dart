import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models_providers/theme_provider.dart';

class ZButtonOutlined extends StatelessWidget {
  final BorderSide borderSide;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final GestureTapCallback onTap;
  final String text;
  final TextStyle textStyle;
  final bool isUpperCaseText;
  final double height;
  final double width;
  final ShapeBorder shapeBorder;

  ZButtonOutlined({
    @required this.text,
    @required this.onTap,
    this.padding,
    this.margin,
    this.textStyle,
    this.borderSide,
    this.width,
    this.height,
    this.isUpperCaseText = true,
    this.shapeBorder,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color textColor = themeProvider.isThemeModeLight ? Colors.black : Colors.white;
    return Container(
      height: height ?? 38,
      width: width ?? null,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: OutlineButton(
        borderSide: borderSide ?? BorderSide(width: 1.5, color: textColor),
        shape: shapeBorder ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Text(
          isUpperCaseText ? text.toUpperCase() : text,
          style: textStyle ?? null,
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          onTap();
        },
      ),
    );
  }
}
