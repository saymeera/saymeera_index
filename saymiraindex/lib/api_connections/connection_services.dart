import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models_class/auth_models/login_model.dart';
import '../models_class/auth_models/send_otp_model.dart';
import 'connection_urls.dart';

class ConnectionServices {



  static Future<dynamic> registerUser(
      Map<String, String> fields,
      File? profileImg,
      String apiurl,
      BuildContext context,
      ) async {

    try {

      print("register_req $fields");
      print("register_url ${ConnectionUrls.baseApiUrl}$apiurl");

      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${ConnectionUrls.baseApiUrl}$apiurl"),
      );

      /// HEADERS (optional but recommended)
      request.headers.addAll({
        "Accept": "application/json",
      });

      /// ADD TEXT FIELDS
      request.fields.addAll(fields);

      /// ✅ ADD FILE ONLY IF EXISTS
      if (profileImg != null) {

        request.files.add(
          await http.MultipartFile.fromPath(
            'profileImg',
            profileImg.path,
          ),
        );

        print("PROFILE IMAGE ADDED");
      }

      /// SEND
      var response = await request.send();

      var responseData = await http.Response.fromStream(response);

      print("register_status ${response.statusCode}");
      print("register_res ${responseData.body}");

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 404) {

        if (responseData.body.isEmpty) {
          throw Exception("Empty response from server");
        }

        /// 👉 Create model if you have one
        return responseData.body;

      } else {

        throw Exception(
            "Server Error ${response.statusCode}: ${responseData.body}");
      }

    } catch (e) {

      print("register Exception: $e");

      rethrow;
    }
  }



  static Future<OtpResponseModel> sendOtp(
      var jsondata,
      String apiurl,
      BuildContext context,
      ) async {
    try {
      // var data = {
      //   "mobile": mobile,
      // };

      print("login_req $jsondata");
      print("login_url ${ConnectionUrls.baseApiUrl}$apiurl");

      final response = await http.post(
        Uri.parse("${ConnectionUrls.baseApiUrl}$apiurl"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(jsondata),
      );

      print("login_statuscode ${response.statusCode}");
      print("login_res ${response.body}");

      // 🔴 IMPORTANT: Check status before parsing
      if (response.statusCode == 200 || response.statusCode == 201|| response.statusCode == 404) {
        // Extra safety check
        if (response.body.isEmpty) {
          throw Exception("Empty response from server");
        }

        return otpResponseModelFromJson(response.body);
      } else {
        // Server returned error
        throw Exception(
          "Server Error ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      print("sendOtp Exception: $e");

      // Optional: show dialog in trading app style
      // DialogUtils.showError(context, "Server error. Please try again.");

      rethrow;
    }
  }

  static Future<OtpResponseModel> verifyOtp(
      var jsondata,
      String apiurl,
      BuildContext context,
      ) async {
    try {
      // var data = {
      //   "mobile": mobile,
      // };

      print("verifyOtp_req $jsondata");
      print("verifyOtp_url ${ConnectionUrls.baseApiUrl}$apiurl");

      final response = await http.post(
        Uri.parse("${ConnectionUrls.baseApiUrl}$apiurl"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(jsondata),
      );

      print("verifyOtp_statuscode ${response.statusCode}");
      print("verifyOtp_res ${response.body}");

      // 🔴 IMPORTANT: Check status before parsing
      if (response.statusCode == 200 || response.statusCode == 201|| response.statusCode == 404) {
        // Extra safety check
        if (response.body.isEmpty) {
          throw Exception("Empty response from server");
        }

        return otpResponseModelFromJson(response.body);
      } else {
        // Server returned error
        // throw Exception(
        //   "Server Error ${response.statusCode}: ${response.body}",
        // );

        return otpResponseModelFromJson(response.body);
      }
    } catch (e) {
      print("sendOtp Exception: $e");

      // Optional: show dialog in trading app style
      // DialogUtils.showError(context, "Server error. Please try again.");

      rethrow;
    }
  }

}