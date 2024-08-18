import 'package:attendancewithfingerprint/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});


bool isIOS() {
  return Platform.isIOS;
}

bool isAndroid() {
  return Platform.isAndroid;
}

  // final Uri _url = Uri.parse('https://zealightlabs.com');



  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(_url)) {
  //     throw Exception('Could not launch $_url');
  //   }
  // }

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
              onTap: () {
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
