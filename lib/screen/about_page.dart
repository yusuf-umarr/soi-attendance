import 'package:attendancewithfingerprint/utils/strings.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  bool isIOS() {
    return Platform.isIOS;
  }

  bool isAndroid() {
    return Platform.isAndroid;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(aboutTitle),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Image(
              image: const AssetImage('images/logo.png'),
              height: size.height * 0.25,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                aboutAppName,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "Developed by Zealight Innovation Labs",
              style: GoogleFonts.quicksand(fontSize: 13.0, color: Colors.grey),
            ),
            InkWell(
              onTap: () async {
                await EasyLauncher.url(url: "https://zealightlabs.com/");
                if (isIOS()) {
                  // Code for iOS
                } else if (isAndroid()) {
                  //  _launchUrl();
                }
              },
              child: Text(
                "Visit zealightlabs",
                style:
                    GoogleFonts.quicksand(fontSize: 13.0, color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "SOI Attendance is an application designed for streamlined attendance management. Leveraging Geolocation and identity tracking tools such as Fingerprint and QR Code scanning, it ensures precise monitoring of subscriber attendance, thereby enhancing efficiency.",
              style: GoogleFonts.quicksand(fontSize: 15.0, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
