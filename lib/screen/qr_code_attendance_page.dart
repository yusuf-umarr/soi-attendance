import 'dart:async';
import 'dart:developer';
import 'package:attendancewithfingerprint/database/db_helper.dart';
import 'package:attendancewithfingerprint/model/attendance.dart';
import 'package:attendancewithfingerprint/model/settings.dart';
import 'package:attendancewithfingerprint/screen/main_menu_page.dart';
import 'package:attendancewithfingerprint/utils/strings.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_fall/trust_fall.dart';
import '../utils/utils.dart';

class QrAttendancePage extends StatefulWidget {
  final String? query;
  final String? title;
  const QrAttendancePage({super.key, this.query, this.title});

  @override
  QrAttendancePageState createState() => QrAttendancePageState();
}

class QrAttendancePageState extends State<QrAttendancePage> {
  DbHelper dbHelper = DbHelper();
  Utils utils = Utils();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _barcode = "";
  late Settings settings;
  String _isAlreadyDoSettings = 'loading';
  late ProgressDialog pr;

  // String
  String? getUrl,
      getKey,
      getQrId,
      getQuery,
      getPath = 'api/attendance/apiSaveAttendance',
      mAccuracy,
      getPathArea = 'api/area/index',
      token;
  String? email, userName;

  dynamic getId;
  dynamic _value; //
  // dynamic _value = ""; // to bypass==================
  bool? _isMockLocation, clickButton = false;

  // Geolocation
  late Position _currentPosition;
  final Geolocator geoLocator = Geolocator();
  late dynamic subscription;
  double setAccuracy = 200.0;

  bool isQrCodeValide = false;

  // Arr area
  List? dataArea = [];
  // List? dataAreas = [
  //   {"id": "01", "name": "area1"},
  //   {"id": "02", "name": "area2"},
  //   {"id": "03", "name": "area3"},
  // ];

  @override
  void initState() {
    super.initState();
    getPref();
  }

  Future<void> scan() async {
    try {
      final barcode = await BarcodeScanner.scan();
      // The value of Qr Code
      // Return the json data
      // We need replaceAll because Json from web use single-quote ({' '}) not double-quote ({" "})
      final newJsonData = barcode.rawContent;
      // final data = jsonDecode(newJsonData);
      // Check the type of barcode
      if (newJsonData != null) {
        // Decode the json data form QR

        if (newJsonData == "https://me-qr.com/9cVf1EtD") {
          setState(() {
            isQrCodeValide = true;
          });

          log("barcode successs");

          checkMockIsNull();
        } else {
          log("errro one res==xxxxxxx========x========x==========x=====:$newJsonData");

          utils.showAlertDialog(
            formatBarcodeWrong,
            "Error",
            AlertType.error,
            _scaffoldKey,
            isAnyButton: false,
          );
        }

        // log("getKey:$getKey");

        // // Set the url and key
        // settings = Settings(url: getUrl, key: getKey);
        // // Insert the settings
        // insertSettings(settings);
      } else {
        utils.showAlertDialog(
          formatBarcodeWrong,
          "Error",
          AlertType.error,
          _scaffoldKey,
          isAnyButton: false,
        );
      }
    } on PlatformException catch (e) {
      setState(() {
        _isAlreadyDoSettings = 'no';
      });
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        _barcode = barcodePermissionCamClose;
        utils.showAlertDialog(
          _barcode,
          "Warning",
          AlertType.warning,
          _scaffoldKey,
          isAnyButton: false,
        );
      } else {
        // log("erro 3 res==xxxxxxx========x========x==========x=====:");

        _barcode = '$barcodeUnknownError $e';
        utils.showAlertDialog(
          _barcode,
          "Error",
          AlertType.error,
          _scaffoldKey,
          isAnyButton: false,
        );
      }
    } catch (e) {
      // log("erro 4 res==xxxxxxx========x========x==========x=====:");

      _barcode = '$barcodeUnknownError : $e';
      if (kDebugMode) {
        print(_barcode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // Show progress
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.normal,
    );
    // Style progress
    pr.style(
      message: attendanceSending,
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: const CircularProgressIndicator(),
      elevation: 10.0,
      padding: const EdgeInsets.all(10.0),
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
      ),
      messageTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 19.0,
        fontWeight: FontWeight.w600,
      ),
    );

    // Init the query
    getQuery = widget.query;

    // Check if user use fake gps
    // checkMockIsNull();

    return SizedBox(
      key: _scaffoldKey,
      child: Center(
        // margin: const EdgeInsets.all(40.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 20.0),
              child: Column(
                children: [
                  // Text(
                  //   "Select Area",
                  //   style: GoogleFonts.quicksand(
                  //     color: Colors.white,
                  //     fontSize: 16.0,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  DropdownButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Colors.black,
                    ),
                    hint: Text(
                      "Select area",
                      style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    items: dataArea!.map((item) {
                      return DropdownMenuItem(
                        value: item['id'].toString(),
                        child: Text(item['name'].toString()),
                      );
                    }).toList(),
                    onChanged: (dynamic newVal) {
                      setState(() {
                        _value = newVal;
                      });
                    },
                    value: _value,
                    isExpanded: true,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),

            Container(
              margin: const EdgeInsets.all(20.0),
              width: double.infinity,
              height: 60.0,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    clickButton = true;
                  });

                  scan();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003D84),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  buttonScan,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),

            Text(
              '$attendanceAccurateInfo $mAccuracy $attendanceOnGps',
              style: GoogleFonts.quicksand(
                color: Colors.grey[800],
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
            // ElevatedButton(
            //   onPressed: () {
            // setState(() {
            //   clickButton = true;
            // });

            // scan();
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: const Color(0xFF003D84),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(18.0),
            //     ),
            //   ),
            //   child: const Text(buttonScan),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> getPref() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      getId = preferences.getInt("id") ?? "";
      userName = preferences.getString("name") ?? "";
      email = preferences.getString("email") ?? "";
      token = preferences.getString("token") ?? "";
    });

    // Get current loc
    _getCurrentLocation();
  }

  void _getCurrentLocation() {
    subscription = Geolocator.getPositionStream().listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });

        // log("lat:${_currentPosition.latitude}");
        // log("lon:${_currentPosition.longitude}");

        _getAccuracyFromLatLng(_currentPosition.accuracy);
      }
    });

    // Check fake gps
    checkMockLoc();
    // Do settings
    getSettings();
  }

  // Get address
  Future<void> _getAccuracyFromLatLng(double accuracy) async {
    final String strAccuracy = accuracy.toStringAsFixed(1);
    if (accuracy > setAccuracy) {
      mAccuracy = '$strAccuracy $attendanceNotAccurate';
    } else {
      mAccuracy = '$strAccuracy $attendanceAccurate';
    }
  }

  // Checking Mock (fake GPS)
  Future<void> checkMockLoc() async {
    try {
      _isMockLocation = await TrustFall.canMockLocation;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  // Get settings data
  Future<void> getSettings() async {
    final getSettings = await dbHelper.getSettings(1);
    setState(() {
         getUrl = "https://attendance.tbclekki.org";
      getKey = "Dlp0Oes2IdkBfH4u6lbAfmZlG93xzDPbb35Qm2W6";
      // getUrl = getSettings?.url;
      // getKey = getSettings?.key;
   
      
      getAreaApi();
    });
  }

  // Getting area via API
  Future<void> getAreaApi() async {
    pr.show();
    final uri = utils.getRealUrl(getUrl!, getPathArea);
    final Dio dio = contactServerViaDio();
    final response = await dio.get(uri);

    final data = response.data;

    if (data['message'] == 'success') {
      dataArea = data['area'] as List;
    } else {
      dataArea = [
        {"id": 0, "name": "No Data Area"}
      ];
    }

    setState(() {
      pr.hide();
    });
  }

  Dio contactServerViaDio() {
    final Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${token!}";
    return dio;
  }

  // Send data post via http
  Future<void> sendData() async {
    // log("sendData called:=====================");

    pr.show();

    //getKey:3k3u2oW2zX13xyPJiyBQwSE2QyFRvF0Cf2FbovqG

    // Get info for attendance
    // final dataKey = "3k3u2oW2zX13xyPJiyBQwSE2QyFRvF0Cf2FbovqG";
    final dataKey = getKey;
    final dataQuery = getQuery;

    // Add data to map
    final Map<String, dynamic> body = {
      'key': dataKey,
      'worker_id': getId,
      'q': dataQuery,
      'lat': _currentPosition.latitude,
      'longt': _currentPosition.longitude,
      'area_id': _value,
    };

    // Sending the data to server
    final uri = utils.getRealUrl(getUrl!, getPath);
    final Dio dio = contactServerViaDio();

    final FormData formData = FormData.fromMap(body);
    final response = await dio.post(uri, data: formData);

    final data = response.data;

    log("send data qr-code response:$data");

    // Show response from server via snackBar
    if (data['message'] == 'Success!') {
      log("send data successs");
      // Set the url and key
      final Attendance attendance = Attendance(
        date: data['date'].toString(),
        time: data['time'].toString(),
        location: data['location'].toString(),
        type: data['query'].toString(),
      );

      // Insert the settings
      insertAttendance(attendance);
      // log("send data successs and attence inserted ");

      // Hide the loading
      Future.delayed(Duration.zero).then((value) {
        if (mounted) {
          setState(() {
            subscription.cancel();
            pr.hide();
            Alert(
              context: _scaffoldKey.currentContext!,
              type: AlertType.success,
              title: "Success",
              desc: "$attendanceShowAlert-$dataQuery $attendanceSuccessMs",
              buttons: [
                DialogButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainMenuPage(),
                    ),
                    (Route<dynamic> route) => false,
                  ),
                  width: 120,
                  child: const Text(
                    okText,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            ).show();
          });
        }
      });
    } else if (data['message'] == 'cannot attend') {
      log("send data error 1");

      Future.delayed(Duration.zero).then((value) {
        setState(() {
          pr.hide();

          utils.showAlertDialog(
            outsideArea,
            "warning",
            AlertType.warning,
            _scaffoldKey,
            isAnyButton: true,
          );
        });
      });
    } else if (data['message'] == 'location not found') {
      log("send data error 2");

      Future.delayed(Duration.zero).then((value) {
        setState(() {
          pr.hide();

          utils.showAlertDialog(
            locationNotFound,
            "warning",
            AlertType.warning,
            _scaffoldKey,
            isAnyButton: true,
          );
        });
      });
    } else if (data['message'] == 'already check-in') {
      log("send data error 3");

      Future.delayed(Duration.zero).then((value) {
        setState(() {
          pr.hide();

          utils.showAlertDialog(
            alreadyCheckIn,
            "warning",
            AlertType.warning,
            _scaffoldKey,
            isAnyButton: true,
          );
        });
      });
    } else if (data['message'] == 'check-in first') {
      log("send data erro 4");

      Future.delayed(Duration.zero).then((value) {
        setState(() {
          pr.hide();

          utils.showAlertDialog(
            checkInFirst,
            "warning",
            AlertType.warning,
            _scaffoldKey,
            isAnyButton: true,
          );
        });
      });
    } else if (data['message'] == 'Error! Something Went Wrong!') {
      log("send data error 5");

      Future.delayed(Duration.zero).then((value) {
        setState(() {
          pr.hide();

          utils.showAlertDialog(
            attendanceErrorServer,
            "Error",
            AlertType.error,
            _scaffoldKey,
            isAnyButton: true,
          );
        });
      });
    } else {
      log("send data error 6");

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          pr.hide();
        });
      });

      Future.delayed(Duration(milliseconds: 500)).then((value) {
        // utils.showSnackBar(
        //   context,
        //   response.data["message"].toString(),
        // );

        setState(() {
          utils.showAlertDialog(
            response.data.toString(),
            "Error",
            AlertType.error,
            _scaffoldKey,
            isAnyButton: true,
          );
        });
      });
    }
  }

  Future<void> insertAttendance(Attendance object) async {
    await dbHelper.newAttendances(object);
  }

  // This function is about checking if the user uses Mock (Fake GPS) to make attendance
  Future<void> checkMockIsNull() async {
    log("checkMockIsNull===========");
    // Check if user click button attendance
    if (clickButton!) {
      // Check mock is already get status
      if (_isMockLocation == null) {
        Future.delayed(Duration.zero).then((value) {
          // Check if pr is showing or not
          if (!pr.isShowing()) {
            pr.show();
            pr.update(
              progress: 50.0,
              message: checkMock,
              progressWidget: Container(
                padding: const EdgeInsets.all(8.0),
                child: const CircularProgressIndicator(),
              ),
              maxProgress: 100.0,
              progressTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
              ),
              messageTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 19.0,
                fontWeight: FontWeight.w600,
              ),
            );
          }
        });
      } else if (_isMockLocation == true) {
        // If there user use mock location means uses fake gps
        // Will show warning alert
        Future.delayed(Duration.zero).then((value) {
          // Detect mock is true, mean user use fake gps
          setState(() {
            clickButton = false;
            if (pr.isShowing()) {
              pr.hide();
            }
          });

          utils.showAlertDialog(
            fakeGps,
            "warning",
            AlertType.warning,
            _scaffoldKey,
            isAnyButton: true,
          );
        });
      } else {
        // If user not use fake gps
        // Continue to check area location if already choosed
        Future.delayed(Duration.zero).then((value) async {
          setState(() {
            clickButton = false;
            if (pr.isShowing()) {
              pr.hide();
            }
          });

          // Check if area is not empty
          if (_value == null) {
            Future.delayed(Duration.zero).then((value) {
              setState(() {
                pr.hide();

                utils.showAlertDialog(
                  selectArea,
                  "warning",
                  AlertType.warning,
                  _scaffoldKey,
                  isAnyButton: true,
                );
              });
            });

            return;
          }
          //send data if everyrhing works fine
          await sendData();
        });
      }
    }
  }
}
