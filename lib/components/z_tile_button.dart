import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ZTileButton extends StatelessWidget {
  final IconData icon;
  final IconData leadingIcon;
  final BorderRadius borderRadius;
  final Color color;
  final GestureTapCallback onTap;
  final Color shadowColor;
  final double elevation;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final String name;
  ZTileButton(
      {Key key,
      @required this.name,
      this.icon,
      this.leadingIcon,
      this.borderRadius,
      this.color,
      this.onTap,
      this.shadowColor,
      this.elevation,
      this.margin,
      this.padding})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: color ?? null,
      elevation: elevation ?? 1,
      shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(5)),
      child: InkWell(
        borderRadius: borderRadius ?? BorderRadius.circular(5),
        onTap: onTap ?? null,
        child: Container(
          padding: padding ?? EdgeInsets.all(12),
          child: Row(
            children: [
              if (icon != null) Icon(icon),
              SizedBox(
                width: 10,
              ),
              Text(name),
              Spacer(),
              if (leadingIcon != null) Icon(leadingIcon)
            ],
          ),
        ),
      ),
    );
  }
}
