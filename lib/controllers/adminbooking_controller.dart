import 'dart:convert';

import 'package:delapp/constants/constants.dart';
import 'package:delapp/controllers/booking_controller.dart';
import 'package:delapp/models/BookingRuangan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AdminBookingController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;

  final box = GetStorage();

  RxList<BookingRuanganModel> bookings = RxList<BookingRuanganModel>([]);

  @override
  void onInit() {
    super.onInit();
    getAllBookings();
  }

  Future getAllBookings() async {
    try {
      bookings.value.clear();
      isLoading.value = true;

      var response = await http.get(
        Uri.parse('${url}bookings'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        final List<dynamic> responseData =
            json.decode(response.body)['bookings'];
        bookings.assignAll(responseData
            .map((data) => BookingRuanganModel.fromJson(data))
            .toList());
      } else {
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future<Ruangan?> getRuanganById(int id) async {
    try {
      var response = await http.get(
        Uri.parse(
            '$url/ruangan/$id'), 
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body)['ruangan'];
        return Ruangan.fromJson(responseData);
      } else {
        print(json.decode(response.body));
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> updateBookingStatus(int bookingId, String newStatus) async {
    try {
      var response = await http.put(
        Uri.parse('${url}booking/$bookingId/update-status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: jsonEncode({
          'status': newStatus,
        }),
      );

      if (response.statusCode == 200) {
        print('Booking updated successfully');
        getAllBookings();
      } else {
        print('Error updating booking: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
