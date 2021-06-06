import 'dart:async';
import 'dart:ui';
import 'package:evamp_saanga/screen/ProfileDetail.dart';
import 'package:flutter/material.dart';
import 'package:evamp_saanga/screen/LoginScreen.dart';
import 'package:evamp_saanga/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getcurrentuserauth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Evamp & Saanga',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[400]),
                ),
              ],
            ),
          ),
        ));
  }

  void getcurrentuserauth() async {
    var user = await AuthService().getusername();
    var pass = await AuthService().getuserpassword();
    print("This is the ${user} ${pass}");

    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => user == null && pass == null
                    ? LoginScreen()
                    : ProfileDetail())));
  }
}

//   var response = await _dio
//       .post('http://192.168.10.50:8099/api/Account/login', data: formData);
//       print(username + password);
// var formData = FormData.fromMap({
//   'email': username,
//   'password': password,
// });
