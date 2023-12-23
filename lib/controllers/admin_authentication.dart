import 'dart:convert';

import 'package:delapp/constants/constants.dart';
import 'package:delapp/views/Surat.dart';
import 'package:delapp/views/admin/home_screen_admin.dart';
import 'package:delapp/views/home_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminAuthenticationController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;

  final box = GetStorage();

  Future login({
    required String name,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'name': name,
        'password': password,
      };

      var response = await http.post(
        Uri.parse('${url}baak/login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);
        Get.offAll(() => MyAppsAdmin());
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;

      print(e.toString());
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      await http.post(
        Uri.parse('${url}baak/logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    }

    // Remove the token from local storage
    prefs.remove('token');
  }
}
