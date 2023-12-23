// adminizinKeluar_controller.dart

import 'dart:convert';

import 'package:delapp/constants/constants.dart';
import 'package:delapp/models/izinKeluar_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AdminIzinKeluarController extends GetxController {
  RxList<IzinKeluarModel> izins = <IzinKeluarModel>[].obs;

  final isLoading = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    getAllIzinKeluarsAdmin();
    super.onInit();
  }

  Future<void> getAllIzinKeluarsAdmin() async {
  try {
    izins.value.clear();
    isLoading.value = true;

    var response = await http.get(
      Uri.parse('${url}baak/izinsadmin'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      },
    );

    if (response.statusCode == 200) {
      isLoading.value = false;
      List<dynamic>? responseData = json.decode(response.body)['bookings'];
      if (responseData != null) {
        izins.assignAll(responseData.map((data) => IzinKeluarModel.fromJson(data)));
      }
    } else {
      isLoading.value = false;
      print('Error: ${json.decode(response.body)}');
    }
  } catch (e) {
    isLoading.value = false;
    print('Error: $e');
  }
}


  Future<void> updateIzinApprovalStatus(
      IzinKeluarModel izin, String selectedStatus) async {
    try {
      var data = {
        'status': izin.status,
      };

      var response = await http.put(
        Uri.parse('${url}izinkeluar/${izin.id}/status/${izin.status}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        print('Status izin berhasil diperbarui');
        getAllIzinKeluarsAdmin();
      } else {
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      print('Error updating izin approval status: $error');
    }
  }
}
