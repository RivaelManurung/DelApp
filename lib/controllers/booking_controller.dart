import 'dart:convert';
import 'package:delapp/constants/constants.dart';
import 'package:delapp/models/BookingRuangan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Ruangan {
  final int id;
  final String namaRuangan;

  Ruangan({
    required this.id,
    required this.namaRuangan,
  });

  factory Ruangan.fromJson(Map<String, dynamic> json) {
    return Ruangan(
      id: json['id'],
      namaRuangan: json['nama_ruangan'],
    );
  }
}

class BookingState {
  // ignore: non_constant_identifier_names
  final rencana_peminjaman = Rx<DateTime?>(null);
  // ignore: non_constant_identifier_names
  final rencana_berakhir = Rx<DateTime?>(null);
  final ruangan = Rx<Ruangan?>(null);
}

class BookingRuanganController extends GetxController {
  final BookingState state = BookingState();
  RxList<BookingRuanganModel> bookings = RxList<BookingRuanganModel>([]);
  RxList<Ruangan> ruangans = RxList<Ruangan>([]);
  final isLoading = false.obs;
  final box = GetStorage();

  Rx<DateTime?> get rencana_peminjaman => state.rencana_peminjaman;
  Rx<DateTime?> get rencana_berakhir => state.rencana_berakhir;
  Rx<Ruangan?> get ruangan => state.ruangan;
  final selectedRuangan = Rx<Ruangan?>(null);

  @override
  void onInit() {
    super.onInit();
    getAllBookings();
    getRuangans();
  }

  Future getAllBookings() async {
    try {
      // ignore: invalid_use_of_protected_member
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

  Future getRuangans() async {
    try {
      // ignore: invalid_use_of_protected_member
      ruangans.value.clear();
      isLoading.value = true;

      var response = await http.get(
        Uri.parse('${url}ruangans'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        final List<dynamic> responseData =
            json.decode(response.body)['ruangans'];
        ruangans.assignAll(responseData.map((data) => Ruangan.fromJson(data)));
      } else {
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future createBooking({
    required String namaKegiatan,
    required DateTime rencana_peminjaman,
    required DateTime rencana_berakhir,
    required int ruanganId,
  }) async {
    try {
      var data = {
        'nama_kegiatan': namaKegiatan,
        'rencana_peminjaman': rencana_peminjaman.toIso8601String(),
        'rencana_berakhir': rencana_berakhir.toIso8601String(),
        'ruangan_id': ruanganId.toString(),
      };

      var response = await http.post(
        Uri.parse('${url}booking/store'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 201) {
        print(json.decode(response.body));
        getAllBookings();
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

  Future deleteBooking(int id) async {
    try {
      var response = await http.delete(
        Uri.parse('${url}booking/delete/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        print('Booking berhasil dihapus');
        getAllBookings();
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
  Future<Ruangan?> getRuanganById(int id) async {
  try {
    var response = await http.get(
      Uri.parse('${url}ruangan/$id'),
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

}
