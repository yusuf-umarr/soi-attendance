import 'package:attendancewithfingerprint/provider/auth_token_provider.dart';
import 'package:attendancewithfingerprint/screen/login_page.dart';
import 'package:attendancewithfingerprint/screen/scan_qr_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: Provider.of<AuthTokenProvider>(context, listen: false)
            .validateToken()
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final bool isTokenValid = snapshot.data ?? false;

            if (isTokenValid) {
              return const LoginPage();
            } else {
              return const ScanQrPage();
            }
          }
        },
      ),
    );
  }
}
