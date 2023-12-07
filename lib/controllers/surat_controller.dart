import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:forumapp/constants/constants.dart';
import 'package:forumapp/models/surat_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class SuratController extends GetxController {
  Rx<List<SuratModel>> surats = Rx<List<SuratModel>>([]);
  final isLoading = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    getAllSurats();
    super.onInit();
  }

  Future getAllSurats() async {
    try {
      surats.value.clear();
      isLoading.value = true;
      var response = await http.get(Uri.parse('${url}surats'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['surats'];
        for (var item in content) {
          surats.value.add(SuratModel.fromJson(item));
        }
      } else {
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future createSurats({
    required String content,
  }) async {
    try {
      var data = {
        'content': content,
      };

      var response = await http.post(
        Uri.parse('${url}surat/store'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 201) {
        print(json.decode(response.body));
      } else {
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
