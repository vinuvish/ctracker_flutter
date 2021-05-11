import 'package:ctracker/models_providers/user_provider.dart';
import 'package:ctracker/pages/app/splash_screen_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

import 'app_utils/notification_init.dart';
import 'models_providers/auth_provider.dart';
import 'models_providers/admin_provider.dart';
import 'models_providers/navbar_provider.dart';
import 'models_providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  ThemeMode themeMode = await Themes.getThemeModeHive();

  runApp(ChangeNotifierProvider(
      create: (_) => ThemeProvider(themeMode), child: MyApp()));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.renderView.automaticSystemUiAdjustment = false;
    WidgetsBinding.instance.addObserver(this);

    NotificationService.init();
  }

  @override
  void didChangeDependencies() {
    Themes.setStatusNavigationBarColor();
    super.didChangeDependencies();
  }

  @override
  void didChangePlatformBrightness() {
    Themes.setStatusNavigationBarColor();
    Provider.of<ThemeProvider>(context, listen: false)
        .checkPlatformBrightness();
    super.didChangePlatformBrightness();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    Themes.setStatusNavigationBarColor();
    Provider.of<ThemeProvider>(context, listen: false)
        .checkPlatformBrightness();
    super.didChangeAppLifecycleState(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => NavbarProvider()),
        ChangeNotifierProvider(create: (context) => AdminProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'cTracker',
        theme: Themes.light(),
        darkTheme: Themes.dark(),
        themeMode: themeProvider.themeMode,
        home: SplashScreenPage(),
      ),
    );
  }
}
