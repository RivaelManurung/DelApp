import 'dart:convert';

import 'package:delapp/models/izinKeluar_model.dart';
import 'package:flutter/material.dart';
import 'package:delapp/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class IzinKeluarController extends GetxController {
  Rx<List<IzinKeluarModel>> izins = Rx<List<IzinKeluarModel>>([]);
  final isLoading = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    getAllIzinKeluars();
    super.onInit();
  }

  Future getAllIzinKeluars() async {
    try {
      izins.value.clear();
      isLoading.value = true;
      var response = await http.get(Uri.parse('${url}izins'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['izins'];
        for (var item in content) {
          izins.value.add(IzinKeluarModel.fromJson(item));
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

  Future createIzinKeluars({
    required String content,
    required DateTime rencanaBerangkat,
    required DateTime rencanaKembali,
  }) async {
    try {
      var data = {
        'content': content,
        'rencana_berangkat': rencanaBerangkat.toIso8601String(),
        'rencana_kembali': rencanaKembali.toIso8601String(),
      };

      var response = await http.post(
        Uri.parse('${url}izin/store'),
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
