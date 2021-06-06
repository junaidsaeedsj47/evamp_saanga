import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:evamp_saanga/Models/UserInfo.dart';
import 'package:evamp_saanga/res/Api_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio();
  late UserInfo _userInfo;

  Future loginWithCredentials(
    String username,
    String password,
  ) async {
    var formData = {
      'userEmail': username,
      'password': password,
    };
    try {
      var response = await _dio.post(profileUrl,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(formData));
      print(username + password);
      print(response.data.toString());
      if (response.statusCode == 200) {
        setuser(username, password);
        print('Here is the username & password${username + password}');
        return true;
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  void setuserInfo(var response) {
    _userInfo = userInfoFromJson(response.data.toString());
    print('This is showing the user info ${_userInfo}');
  }

  void setuser(String username, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('name', username);
    sharedPreferences.setString('password', password);
  }

  Future<UserInfo> fetchAlbum() async {
    var formData = {
      'userEmail': await getusername(),
      'password': await getuserpassword(),
    };
    try {
      var response = await _dio.post(profileUrl,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(formData));
      print(formData);
      print(response.data.toString());
      if (response.statusCode == 200) {
        _userInfo = await UserInfo.fromJson(response.data);
        print('This is showing the user info ${_userInfo}');
        return _userInfo;
      } else {
        throw Exception('Failed to load album');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      throw Exception('Failed to load album');
    }
  }

  Future getusername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var user = await sharedPreferences.getString('name') ?? '';
    print(user);
    if (user == '') {
      return null;
    } else {
      return user;
    }
  }

  Future getuserpassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var pass = await sharedPreferences.getString('password') ?? '';
    if (pass == '') {
      return null;
    } else {
      return pass;
    }
  }

  Future logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
