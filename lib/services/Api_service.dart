import 'dart:convert';
// import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:evamp_saanga/Models/CustomersList.dart';
import 'package:evamp_saanga/res/Api_links.dart';

class ApiServices {
  final Dio _dio = Dio();
  late ItemData itemData;
  Future<ItemData> getItemsList(String? token, String? email) async {
    print('this is okkkkkkkkk${token}  ${email}');
    var formData = {
      'email': email,
      'token': token,
    };
    try {
      var response = await _dio.post(getitemUrl,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(formData));
      print(formData);
      print(response.data.toString());
      if (response.statusCode == 200) {
        itemData = await ItemData.fromJson(response.data);
        print('This is showing the Item Data ${itemData}');
        return itemData;
      } else {
        throw Exception('Failed to load album');
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      throw Exception('Failed to load album');
    }
  }
}
