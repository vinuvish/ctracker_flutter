import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/* ------------------------- NOTE NUMBER ------------------------- */
class ZModelNumber {
  static num toNum(val) {
    if (val is num) return val;
    return 0;
  }

  static num toPrecision(num val, int fractionDigits) {
    num mod = pow(10, fractionDigits);
    return ((val * mod).round() / mod);
  }

  static double parseDouble(val) {
    if (val is num) return val.toDouble();
    return 0.0;
  }

  static int parseInt(val) {
    if (val is num) return val.toInt();
    return 0;
  }
}

/* ------------------------- NOTE STRING ------------------------- */
class ZModelString {
  static String toStr(val) {
    if (val is String) return val;
    return '';
  }

  static int parseInt(val) => int.tryParse(val) ?? 0;

  static double parseDouble(val) => double.tryParse(val) ?? 0.0;
}

/* ------------------------- NOTE Bool ------------------------- */

class ZModelBool {
  static bool toBool(val, {bool defaultVal}) {
    if (val is bool) return val;
    return defaultVal ?? false;
  }
}

/* ------------------------- NOTE List ------------------------- */
class ZModelLists {
  static List<String> toListStrings(val) {
    if (val is List &&
        val.every((element) => element is String) &&
        val.every((element) => element != ''))
      return (val.every((element) => element is String)) ? List.from(val) : [];
    return [];
  }
}

class ZModelDateTime {
  static String toDateTimeStr(dynamic date, {DateTime defaultDateTime}) {
    if (date == null) {
      String timeFormattedDate = DateFormat('MMM d,y hh:mm aaa')
          .format(defaultDateTime ?? DateTime.now());
      String timeFormatted = timeFormattedDate;
      return timeFormatted;
    }

    DateTime dateTime = toDateTime(date);
    String timeFormattedDate = DateFormat('MMM d,y hh:mm aaa').format(dateTime);
    String timeFormatted = timeFormattedDate;
    return timeFormatted;
  }

  static DateTime toDateTime(dynamic date, {DateTime defaultDateTime}) {
    if (date is DateTime) return date;

    if (date is Timestamp) return date.toDate();

    return defaultDateTime ?? DateTime.now();
  }
}

class ZModelMoney {
  static final oCcy = new NumberFormat("#,##0.00", "en_US");

  static String to(num value) {
    if (value is num) {
      return oCcy.format(value);
    }

    return '0.00';
  }
}

class ZModelStatus {
  static String getStatus(num value) {
    switch (value) {
      case 1:
        return 'Created';
      case 2:
        return 'Transferred';
      case 3:
        return 'Received';
      case 4:
        return 'Completed';
        break;
      default:
        return 'Created';
    }
  }

  static String nextStatus(String status) {
    if (status.toLowerCase() == 'transferred') {
      return 'Received';
    } else
      return 'Transferred';
  }
}
