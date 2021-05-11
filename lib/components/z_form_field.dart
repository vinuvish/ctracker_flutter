import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models_providers/theme_provider.dart';

typedef Null ValueChangeCallback(String value);
typedef Null OnSavedChangeCallback(String value);

class ZTextFormField extends StatefulWidget {
  final Color containerColor;
  final Function validator;
  final GestureTapCallback onTap;
  final String initialValue;
  final String labelText;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChangeCallback onSaved;
  final ValueChangeCallback onValueChanged;
  final Widget suffix;
  final bool isEnabled;
  final bool obscureText;
  final bool readyOnly;
  final int maxLength;
  final int maxLines;
  final bool isDarkMode;
  final AutovalidateMode autovalidateMode;

  ZTextFormField({
    Key key,
    @required this.labelText,
    this.controller,
    this.onValueChanged,
    this.isEnabled = true,
    this.onSaved,
    this.keyboardType,
    this.textCapitalization,
    this.validator,
    this.containerColor,
    this.initialValue,
    this.obscureText,
    this.maxLength,
    this.maxLines,
    this.readyOnly = false,
    this.onTap,
    this.suffix,
    this.isDarkMode = false,
    this.autovalidateMode,
  }) : super(key: key);

  @override
  _ZTextFormFieldState createState() => _ZTextFormFieldState();
}

class _ZTextFormFieldState extends State<ZTextFormField> {
  TextEditingController valueController;
  FocusNode _focus = new FocusNode();
  @override
  void initState() {
    super.initState();
    valueController = widget.controller ?? TextEditingController.fromValue(TextEditingValue(text: widget.initialValue ?? ""));
    valueController.addListener(() {
      if (widget.onValueChanged != null) widget.onValueChanged(valueController.text);
    });
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final textColor = themeProvider.isThemeModeLight ? Colors.black87 : Colors.white70;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.labelText}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TextFormField(
              autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.disabled,
              maxLength: widget.maxLength ?? null,
              maxLines: widget.maxLines ?? 1,
              enabled: widget.isEnabled ?? true,
              readOnly: widget.readyOnly,
              focusNode: _focus,
              onTap: () {
                if (widget.onTap != null) widget.onTap();
              },
              onSaved: (String value) {
                widget.onSaved(value);
              },
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, height: 1.45, color: textColor),
              keyboardType: widget.keyboardType ?? TextInputType.text,
              textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
              obscureText: widget.obscureText ?? false,
              controller: valueController,
              validator: widget.validator ??
                  (String value) {
                    if (value.isEmpty) return 'This field is required';
                    return null;
                  },
              decoration: InputDecoration(filled: _focus.hasFocus)),
        ],
      ),
    );
  }
}
