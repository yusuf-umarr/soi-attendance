import 'package:attendancewithfingerprint/screen/finger_print_attendance_page.dart';
import 'package:attendancewithfingerprint/screen/qr_code_attendance_page.dart';
import 'package:attendancewithfingerprint/utils/strings.dart';
import 'package:attendancewithfingerprint/widgets/custom_switch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckInPage extends StatefulWidget {
  final String? query;
  final String? title;
  const CheckInPage({super.key, this.query, this.title});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isFingerPrint = true;
  String fingerPrint = "images/fingerPrint.png";
  String qrCode = "images/qr-code.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child: Image.asset(
                _isFingerPrint ? fingerPrint : qrCode,
                height: 100,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomSwitch(
              value: _isFingerPrint,
              onChanged: (bool val) {
                setState(() {
                  _isFingerPrint = val;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Please select your venue in the drop-down below to ${_isFingerPrint ? "Check-${widget.query}" : "scan QR code"}",
              style: GoogleFonts.quicksand(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 40.0,
            ),
            if (_isFingerPrint)
              FingerPrintAttendancePage(
                query: widget.query,
                title: mainMenuCheckInTitle,
              )
            else
              QrAttendancePage(
                query: widget.query,
              )
          ],
        ),
      ),
    );
  }
}
