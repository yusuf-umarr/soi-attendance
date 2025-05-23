import 'package:attendancewithfingerprint/auth_check.dart';
import 'package:attendancewithfingerprint/provider/auth_token_provider.dart';
import 'package:attendancewithfingerprint/provider/home_provider.dart';
import 'package:attendancewithfingerprint/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => AuthTokenProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    storeLogin();
    checkUpdate();
    super.initState();
  }

  bool usedAppBefore = false;

  final upgrader = Upgrader();

  void checkUpdate() {
    upgrader.initialize().then((value) {
      if (upgrader.isUpdateAvailable()) {
      }
    });
  }

  Future<void> storeLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    usedAppBefore = prefs.getBool("usedAppBefore") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: mainTitle,
      theme: ThemeData.light().copyWith(
        textSelectionTheme: Theme.of(context).textSelectionTheme.copyWith(
              cursorColor: Colors.white,
            ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF0E67B4),
        ),
      ),
      home:const AuthCheckScreen(),
    );
  }
}

//com.soiworkers.app

//com. soi.attendance.app