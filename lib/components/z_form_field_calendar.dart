import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

typedef Null ValueChangeCallback(DateTime value);
typedef Null OnSavedChangeCallback(DateTime value);

class ZTextFormFieldCalendar extends StatefulWidget {
  final AutovalidateMode autovalidateMode;
  final Color containerColor;
  final DateTime initialValue;
  final Function validator;
  final GestureTapCallback onTap;
  final String labelText;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChangeCallback onSaved;
  final ValueChangeCallback onValueChanged;
  final bool isEnabled;
  final bool isNumberCurrencyInput;
  final bool obscureText;
  final bool readyOnly;
  final bool isTimeOnly;
  final int maxLength;
  final int maxLines;

  ZTextFormFieldCalendar({
    @required this.labelText,
    Key key,
    this.autovalidateMode,
    this.containerColor,
    this.controller,
    this.initialValue,
    this.isEnabled = true,
    this.isNumberCurrencyInput = false,
    this.keyboardType,
    this.maxLength,
    this.maxLines,
    this.obscureText,
    this.onSaved,
    this.onTap,
    this.onValueChanged,
    this.readyOnly = false,
    this.isTimeOnly = false,
    this.textCapitalization,
    this.validator,
  }) : super(key: key);

  @override
  _ZTextFormFieldCalendarState createState() => _ZTextFormFieldCalendarState();
}

class _ZTextFormFieldCalendarState extends State<ZTextFormFieldCalendar> {
  TextEditingController valueController;
  DateTime _date = DateTime.now();
  DateTime _firstDate = DateTime(DateTime.now().day);
  DateTime _lastDate = DateTime(DateTime.now().year + 2);
  FocusNode _focus = new FocusNode();

  TimeOfDay _time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) _date = widget.initialValue;
    valueController = widget.controller ?? TextEditingController.fromValue(TextEditingValue(text: dateFormatStr(widget.initialValue)));
    _onFocusChange();
  }

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        children: <Widget>[
          TextFormField(
              autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.disabled,
              maxLength: widget.maxLength ?? null,
              maxLines: widget.maxLines ?? 1,
              enabled: widget.isEnabled ?? true,
              readOnly: true,
              onTap: () async {
                if (widget.isTimeOnly) {
                  updateTimeValues();
                } else {
                  updateDateValues();
                }
              },
              onSaved: (String value) {
                widget.onSaved(_date);
              },
              focusNode: _focus,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
              keyboardType: widget.keyboardType ?? TextInputType.text,
              textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
              obscureText: widget.obscureText ?? false,
              controller: valueController,
              validator: widget.validator ??
                  (String value) {
                    if (value.isEmpty) {
                      return 'fieldRequired';
                    }
                    return null;
                  },
              decoration: InputDecoration(filled: _focus.hasFocus)),
          Positioned(
            right: 10,
            top: 11,
            child: GestureDetector(
              child: Icon(Icons.calendar_today_outlined, color: Colors.grey),
              onTap: () async {
                if (widget.isTimeOnly) {
                  updateTimeValues();
                } else {
                  updateDateValues();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void updateDateValues() async {
    DateTime dayNow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    var day = await showDatePicker(useRootNavigator: true, context: context, initialDate: dayNow, firstDate: _firstDate, lastDate: _lastDate);

    var time = await showTimePicker(initialTime: TimeOfDay.now(), useRootNavigator: true, context: context);

    FocusScope.of(context).requestFocus(new FocusNode());
    if (day != null && time != null) {
      DateTime dateTime = DateTime(day.year, day.month, day.day, time.hour, time.minute);
      _date = dateTime;
      valueController.text = dateFormatStr(_date);
      setState(() {});
    }
  }

  void updateTimeValues() async {
    var result = await showTimePicker(
      initialTime: TimeOfDay.now(),
      useRootNavigator: true,
      context: context,
    );
    FocusScope.of(context).requestFocus(new FocusNode());
    if (result != null) {
      _time = result;
      valueController.text = timeFormatStr(_time);
      setState(() {});
    }
  }

  dateFormatStr(DateTime dateTime) {
    if (dateTime == null) return '';
    return DateFormat("MMM dd, yyyy 'at' h:mm a").format(dateTime);
  }

  timeFormatStr(TimeOfDay dateTime) {
    if (dateTime == null) return '';
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute).format(context).toString();
  }
}
