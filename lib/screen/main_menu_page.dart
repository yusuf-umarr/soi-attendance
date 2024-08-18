import 'dart:developer';

import 'package:attendancewithfingerprint/provider/home_provider.dart';
import 'package:attendancewithfingerprint/screen/check_in_page.dart';
import 'package:attendancewithfingerprint/screen/login_page.dart';
import 'package:attendancewithfingerprint/screen/report_page.dart';
import 'package:attendancewithfingerprint/utils/single_menu.dart';
import 'package:attendancewithfingerprint/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'about_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Menu();
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<Menu> {
  String? getName = "";

  @override
  void initState() {
    _getPermission();
    getPref();
    super.initState();
  }

  // bool isPermission = false;

  Future<void> _getPermission() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isPermission = prefs.getBool("isPermission") ?? false;

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!isPermission) {
        permissionDialog(context: context);
      }
    });
  }

  // checkPermission(HomeProvider val) {
  //   if (val.isPermission) {
  //     // log("permissioj successful");
  //     getPermissionAttendance();
  //   } else {
  //     log("permissioj denied");
  //   }
  // }

  _checkPermission(HomeProvider val) {
    if (val.isPermission) {
      // log("permissioj successful");
      // newStartTime();
      _determinePosition();
      // getPermissionAttendance();
    } else {
      log("permission denied");
    }
  }

  // Future<void> getPermissionAttendance() async {
  //   await [
  //     Permission.camera,
  //     Permission.location,
  //     Permission.locationWhenInUse,
  //   ].request().then((value) {
  //     _determinePosition();
  //   });
  // }

  Future<Position> _determinePosition() async {
    if (context.watch<HomeProvider>().permissionEnum != PermissionEnum.done) {
      Future.delayed(const Duration(seconds: 1), () {
        context.read<HomeProvider>().setpermissionEnum(PermissionEnum.loading);
      });
    }
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      getSnackBar('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        getSnackBar('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      getSnackBar(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    context.read<HomeProvider>().setpermissionEnum(PermissionEnum.done);

    return Geolocator.getCurrentPosition();
  }

  // Show snackBar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> getSnackBar(
    String messageSnackBar,
  ) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(messageSnackBar)));
  }

  // Function sign out
  Future<void> _signOut() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("status");
      preferences.remove("email");
      preferences.remove("name");
      preferences.remove("password");
      preferences.remove("id");

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  Future<void> getPref() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      getName = preferences.getString("name");
      log("getName:$getName");
    });
  }

  String fingerPrint = "images/fingerPrint.png";
  String qrCode = "images/qr-code.png";

  @override
  Widget build(BuildContext context) {
    _checkPermission(context.watch<HomeProvider>());
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F4F8),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(bottom: 40.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E67B4),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage('images/logo_trans.png'),
                        height: size.height * 0.1,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$mainMenuTitleHi ${getName!},",
                            style: GoogleFonts.quicksand(
                              fontSize: 13.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            mainMenuWelcome,
                            style: GoogleFonts.quicksand(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Please, ensure that you mark\nyour attendance",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        // Container(
                        //   height: 100,
                        //   width: 100,
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.blue),
                        //   ),
                        //   child: Image.asset(
                        //     _isFingerPrint ? fingerPrint : qrCode,
                        //     height: 100,
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 20,
                        // ),

                        // CustomSwitch(
                        //   value: _isFingerPrint,
                        //   onChanged: (bool val) {
                        //     setState(() {
                        //       _isFingerPrint = val;
                        //     });
                        //   },
                        // ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: SingleMenu(
                                icon: FontAwesomeIcons.userClock,
                                menuName: mainMenuCheckIn,
                                color: Colors.blue,
                                action: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const CheckInPage(
                                      query: 'in',
                                      title: mainMenuCheckInTitle,
                                    ),
                                    // ? const FingerPrintAttendancePage(
                                    // query: 'in',
                                    // title: mainMenuCheckInTitle,
                                    //   )
                                    // : const QrAttendancePage(
                                    // name: 'Check-In',
                                    // query: 'in',
                                    //   ),
                                  ),
                                ),
                                decName: mainMenuCheckInDec,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: SingleMenu(
                                icon: FontAwesomeIcons.solidClock,
                                menuName: mainMenuCheckOut,
                                color: Colors.teal,
                                action: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const CheckInPage(
                                      query: 'out',
                                      title: mainMenuCheckOutDec,
                                    ),

                                    //  _isFingerPrint
                                    //     ? const FingerPrintAttendancePage(
                                    //         query: 'out',
                                    //         title: mainMenuCheckOutTitle,
                                    //       )
                                    //     : const QrAttendancePage(
                                    //         name: 'Check-Out',
                                    //         query: 'out',
                                    //       ),
                                  ),
                                ),
                                decName: mainMenuCheckOutDec,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Column(
                          children: [
                            singleMenuCard(
                              color: Colors.yellow[700]!,
                              name: mainMenuReport,
                              action: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ReportPage(),
                                ),
                              ),
                            ),
                            singleMenuCard(
                              color: Colors.purple,
                              icon: FontAwesomeIcons.userLarge,
                              name: mainMenuAbout,
                              action: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>  AboutPage(),
                                ),
                              ),
                            ),
                            singleMenuCard(
                              color: Colors.red[300]!,
                              icon: FontAwesomeIcons.userLarge,
                              name: mainMenuLogout,
                              action: () => _signOut(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } //  color: Colors.yellow[700],

  Card singleMenuCard({
    Color color = Colors.yellow,
    IconData icon = FontAwesomeIcons.calendar,
    String name = "",
    Function()? action,
  }) {
    return Card(
      child: ListTile(
        onTap: action,
        leading: Container(
          width: 30.0,
          height: 30.0,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 15.0,
            color: Colors.white,
          ),
        ),
        title: Text(
          name,
          style: GoogleFonts.quicksand(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          color: Colors.black,
        ),
      ),
    );
  }

  Future permissionDialog({
    BuildContext? context,
  }) =>
      showDialog(
        context: context!,
        barrierDismissible: true,
        builder: (context) {
          // debugPrint("error is here");
          return StatefulBuilder(
            builder: (context, setState) {
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 15,
                                top: 15,
                              ),
                              child: const Text(
                                  "The SOI Attendance app collects location data to enable the attendance feature work accurately. Please allow the application access your location only when you are to have your attendance recorded. Thank you"),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<HomeProvider>()
                                      .setEnablePermission(false);
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "DENY",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<HomeProvider>()
                                      .setEnablePermission(true);
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "ALLOW",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
}
