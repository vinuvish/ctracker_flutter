import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../models_providers/theme_provider.dart';

typedef Null ValueChangeCallback(List<String> value);
typedef Null OnSavedChangeCallback(List<String> value);

class ZFormFieldBottomSheetMulti extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final Color containerColor;
  final Function validator;
  final GestureTapCallback onTap;
  final String initialValue;
  final String labelText;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChangeCallback onSaved;
  final ValueChangeCallback onChanged;
  final Widget suffix;
  final bool isEnabled;
  final bool obscureText;
  final bool readyOnly;
  final int maxLength;
  final int maxLines;
  final bool isDarkMode;
  final AutovalidateMode autovalidateMode;

  ZFormFieldBottomSheetMulti({
    Key key,
    @required this.items,
    @required this.labelText,
    this.controller,
    this.onChanged,
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
    this.selectedItems,
  }) : super(key: key);

  _ZFormFieldBottomSheetMultiState createState() =>
      _ZFormFieldBottomSheetMultiState();
}

class _ZFormFieldBottomSheetMultiState
    extends State<ZFormFieldBottomSheetMulti> {
  TextEditingController valueController;
  FocusNode _focus = new FocusNode();
  List<String> selectedItems = [];
  Color sheetColor;
  @override
  void initState() {
    super.initState();
    selectedItems = widget.selectedItems;
    valueController = widget.controller ??
        TextEditingController.fromValue(
            TextEditingValue(text: widget.selectedItems.join(',')));
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
    sheetColor = themeProvider.isThemeModeLight ? Colors.white : Colors.black;
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
                  widget.onSaved(selectedItems);
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
                    _showModalBottomSheet();
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
                  if (widget.isEnabled) _showModalBottomSheet();
                },
                child: Icon(Icons.arrow_drop_down),
              ),
              right: 6,
            )
          ],
        )
      ]),
    );
  }

  void _showModalBottomSheet() {
    Get.bottomSheet(StatefulBuilder(
        builder: (BuildContext context, StateSetter setModelState) {
      return Container(
        decoration: BoxDecoration(
            color: sheetColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: ListView(
          children: [
            for (var item in widget.items)
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CheckboxListTile(
                    value: (selectedItems.contains(item)),
                    title: Text(item),
                    onChanged: (v) {
                      if (!selectedItems.contains(item)) {
                        selectedItems.add(item);
                      } else {
                        selectedItems.remove(item);
                      }
                      widget.onChanged(selectedItems);

                      valueController.text = selectedItems.join(',');

                      setModelState(() {});
                    },
                  ),
                  Divider(height: 0, color: Colors.black12)
                ],
              ),
            if (Platform.isIOS) SizedBox(height: 22)
          ],
        ),
      );
    }));
  }
}
