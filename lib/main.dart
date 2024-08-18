import 'dart:developer';
import 'package:attendancewithfingerprint/provider/home_provider.dart';
import 'package:attendancewithfingerprint/screen/login_page.dart';
import 'package:attendancewithfingerprint/screen/scan_qr_page.dart';
import 'package:attendancewithfingerprint/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => HomeProvider()),
  ], child: const MyApp(),),);
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
    checkUpdate();
    super.initState();
  }

  final upgrader = Upgrader();

  void checkUpdate() {
    upgrader.initialize().then((value) {
      if (upgrader.isUpdateAvailable()) {
        log('=upgrade is available==-${upgrader.currentAppStoreVersion}');
      }
    });
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
          // change the appbar color
          primary: const Color(0xFF0E67B4),
        ),
      ),
      home: const LoginPage(),
      // home: const ScanQrPage(),
    );
  }
}
