import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider(this._themeMode) {
    checkPlatformBrightness();
  }

  Brightness _brightness;
  Brightness get brightness => _brightness;

  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  bool _isThemeModeLight = true;
  bool get isThemeModeLight => _isThemeModeLight;

  set themeMode(ThemeMode tm) {
    this._themeMode = tm;

    Themes.setThemeModeHive(tm);
    checkPlatformBrightness();

    notifyListeners();
  }

  void checkPlatformBrightness() {
    final __brightness = WidgetsBinding.instance.window.platformBrightness;

    if (_themeMode == ThemeMode.system) {
      _brightness = __brightness;

      if (__brightness == Brightness.light) {
        _isThemeModeLight = true;
      } else {
        _isThemeModeLight = false;
      }
    }

    if (_themeMode == ThemeMode.light) {
      _brightness = Brightness.light;
      _isThemeModeLight = true;
    }

    if (_themeMode == ThemeMode.dark) {
      _brightness = Brightness.dark;
      _isThemeModeLight = false;
    }

    notifyListeners();
  }
}

class Themes {
  static ThemeData light() => _baseTheme(ThemeData.light());

  static ThemeData dark() => _baseTheme(ThemeData.dark());

  static ThemeData _baseTheme(ThemeData themeData) {
    bool isDark = themeData.brightness == Brightness.dark;
    BorderRadius borderRadius = BorderRadius.circular(4);

    Color disabledBorderColor = isDark ? Colors.black12 : Color(0xFFE6E7EA);
    Color enabledBorderColor = isDark ? Colors.white38 : Color(0xFFE8EBF7);
    Color errorBorderColor = isDark ? Color(0xFFE20000) : Color(0xFFE20000);
    Color focusedBorderColor = isDark ? Colors.white : Color(0xFF5A7EFF);
    Color focusedErrorBorderColor =
        isDark ? Color(0xFFE20000) : Color(0xFF5C00E4);

    IconThemeData primaryIconTheme =
        IconThemeData(color: isDark ? Colors.white : Colors.black);

    Color scaffoldBackgroundColor =
        isDark ? Color(0xFF1E1F28) : Colors.grey[100];

    Color textColor = isDark ? Colors.grey[100] : Colors.black;
    String headlineFontFamily = 'Lato';
    TextTheme textTheme = themeData.textTheme.apply(
        fontFamily: 'Lato',
        displayColor: isDark ? Colors.grey[200] : Colors.black);

    return themeData.copyWith(
      canvasColor: isDark ? Colors.grey[900] : Colors.grey[100],
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      buttonColor: Color(0xFF6C63FF),
      accentColor: isDark ? Colors.white : Colors.black87,
      primaryIconTheme: primaryIconTheme,
      appBarTheme: AppBarTheme(
          elevation: 0.5,
          color: scaffoldBackgroundColor,
          textTheme: textTheme.copyWith(
            headline6: textTheme.headline6.copyWith(
                fontFamily: headlineFontFamily,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor),
          )),
      cupertinoOverrideTheme: CupertinoThemeData().copyWith(
        barBackgroundColor: scaffoldBackgroundColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: CupertinoTextThemeData().copyWith(primaryColor: textColor),
      ),
      textTheme: textTheme.copyWith(
        bodyText1: textTheme.bodyText1
            .copyWith(fontWeight: FontWeight.normal, fontSize: 15),
        bodyText2: textTheme.bodyText2.copyWith(),
        button: textTheme.button
            .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
        caption: textTheme.caption.copyWith(),
        headline1: textTheme.headline1.copyWith(
            fontFamily: headlineFontFamily,
            fontWeight: FontWeight.bold,
            color: textColor),
        headline2: textTheme.headline2.copyWith(
            fontFamily: headlineFontFamily,
            fontWeight: FontWeight.bold,
            color: textColor),
        headline3: textTheme.headline3.copyWith(
            fontFamily: headlineFontFamily,
            fontWeight: FontWeight.bold,
            color: textColor),
        headline4: textTheme.headline4.copyWith(
            fontFamily: headlineFontFamily,
            fontWeight: FontWeight.bold,
            color: textColor),
        headline5: textTheme.headline5.copyWith(
            fontFamily: headlineFontFamily,
            fontWeight: FontWeight.bold,
            color: textColor),
        headline6: textTheme.headline6.copyWith(
            fontFamily: headlineFontFamily,
            fontWeight: FontWeight.bold,
            color: textColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
          fillColor: isDark ? Colors.white10 : Color(0xFFF9FBFF),
          suffixStyle:
              TextStyle(color: isDark ? Colors.white54 : Colors.black54),
          labelStyle:
              TextStyle(color: isDark ? Colors.white54 : Colors.black54),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: enabledBorderColor, width: 1.5),
              borderRadius: borderRadius),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: focusedBorderColor, width: 1.5),
              borderRadius: borderRadius),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: errorBorderColor, width: 1.5),
              borderRadius: borderRadius),
          focusedErrorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: focusedErrorBorderColor, width: 1.5),
              borderRadius: borderRadius),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: disabledBorderColor, width: 1.5),
              borderRadius: borderRadius),
          isDense: true),
    );
  }

  static Brightness getBrightness() {
    return WidgetsBinding.instance.window.platformBrightness;
  }

  static setThemeModeHive(ThemeMode tm) async {
    final settings = await Hive.openBox('settings');

    if (tm == ThemeMode.system) {
      settings.put('themeMode', 'system');
    }
    if (tm == ThemeMode.light) {
      settings.put('themeMode', 'light');
    }
    if (tm == ThemeMode.dark) {
      settings.put('themeMode', 'dark');
    }

    setStatusNavigationBarColor();
  }

  static Future<ThemeMode> getThemeModeHive() async {
    final settings = await Hive.openBox('settings');
    String themeModeStr = settings.get('themeMode') ?? 'light';

    if (themeModeStr == 'light') {
      return ThemeMode.light;
    }
    if (themeModeStr == 'dark') {
      return ThemeMode.dark;
    }

    return ThemeMode.system;
  }

  static void setStatusNavigationBarColor() async {
    final brightness = WidgetsBinding.instance.window.platformBrightness;

    bool isThemeModeSystem = await getThemeModeHive() == ThemeMode.system;
    bool isThemeModeLight = await getThemeModeHive() == ThemeMode.light;
    bool isThemeModeDark = await getThemeModeHive() == ThemeMode.dark;

    Color systemNavigationBarColorDark = Colors.black;
    Color systemNavigationBarColorLight = Colors.grey.shade200;

    if (isThemeModeSystem && brightness == Brightness.light) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: systemNavigationBarColorLight,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    }

    if (isThemeModeSystem && brightness == Brightness.dark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: systemNavigationBarColorDark,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }

    if (isThemeModeLight) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: systemNavigationBarColorLight,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.black,
      ));
    }

    if (isThemeModeDark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: systemNavigationBarColorDark,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.black,
      ));
    }
  }
}
