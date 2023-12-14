import 'dart:convert';

import 'package:delapp/constants/constants.dart';
import 'package:delapp/views/home_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;

  final box = GetStorage();

  Future register({
    required String name,
    required String email,
    required String password,
    required String nomorKtp,
    required String nim,
    required String namaLengkap,
    required String nomorHandphone,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'name': name,
        'email': email,
        'password': password,
        'nomor_ktp': nomorKtp,
        'nim': nim,
        'nama_lengkap': namaLengkap,
        'nomor_handphone': nomorHandphone,
      };

      var response = await http.post(
        Uri.parse('${url}register'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 201) {
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);
        Get.offAll(() => const MyApps());
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // ignore: avoid_print
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      // ignore: avoid_print
      print(e.toString());
    }
  }

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
        Uri.parse('${url}login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);
        Get.offAll(() => const MyApps());
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // ignore: avoid_print
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;

      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      await http.post(
        // ignore: unnecessary_brace_in_string_interps
        Uri.parse('${url}/logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    }

    // Hapus token dari penyimpanan lokal
    prefs.remove('token');
  }
}
