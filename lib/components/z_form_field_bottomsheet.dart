import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../models_providers/theme_provider.dart';

typedef Null ValueChangeCallback(String value);
typedef Null OnSavedChangeCallback(String value);

class ZTextFormFieldBottomSheet extends StatefulWidget {
  final List<dynamic> items;
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

  ZTextFormFieldBottomSheet({
    Key key,
    @required this.items,
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

  _ZTextFormFieldBottomSheetState createState() =>
      _ZTextFormFieldBottomSheetState();
}

class _ZTextFormFieldBottomSheetState extends State<ZTextFormFieldBottomSheet> {
  String _selectedVal;
  TextEditingController valueController;
  FocusNode _focus = new FocusNode();
  @override
  void initState() {
    super.initState();
    _selectedVal =
        widget.initialValue ?? widget.items.isNotEmpty ? widget.items[0] : '';

    valueController = widget.controller ??
        TextEditingController.fromValue(
            TextEditingValue(text: widget.initialValue ?? _selectedVal));
    valueController.addListener(() {
      if (widget.onValueChanged != null)
        widget.onValueChanged(valueController.text);
    });
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final textColor =
        themeProvider.isThemeModeLight ? Colors.black87 : Colors.white70;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${widget.labelText}',
            textScaleFactor: 1.0,
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            TextFormField(
                autovalidateMode:
                    widget.autovalidateMode ?? AutovalidateMode.disabled,
                maxLength: widget.maxLength ?? null,
                maxLines: widget.maxLines ?? 1,
                enabled: widget.isEnabled ?? true,
                readOnly: true,
                focusNode: _focus,
                onSaved: (String value) {
                  widget.onSaved(value);
                },
                style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                    color: textColor),
                keyboardType: widget.keyboardType ?? TextInputType.text,
                textCapitalization:
                    widget.textCapitalization ?? TextCapitalization.none,
                obscureText: widget.obscureText ?? false,
                controller: valueController,
                onTap: () {
                  if (widget.isEnabled) {
                    _showModalBottomSheet(context: context);
                  }
                },
                validator: widget.validator ??
                    (String value) {
                      if (value.isEmpty) return 'This field is required';
                      return null;
                    },
                decoration: InputDecoration(filled: _focus.hasFocus)),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  if (widget.isEnabled) _showModalBottomSheet(context: context);
                },
                child: Icon(
                  Icons.arrow_drop_down,
                ),
              ),
              right: 6,
            )
          ],
        )
      ]),
    );
  }

  void _showModalBottomSheet({context}) {
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: ListView(
        children: [
          for (var item in widget.items)
            Column(
              children: <Widget>[
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      item,
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  onTap: () {
                    _selectedVal = item;
                    valueController.text = item;
                    widget.onValueChanged(_selectedVal);
                    Get.back();
                  },
                ),
                Divider(height: 0, color: Colors.black12)
              ],
            ),
          if (Platform.isIOS) SizedBox(height: 22)
        ],
      ),
    ));
  }
}
