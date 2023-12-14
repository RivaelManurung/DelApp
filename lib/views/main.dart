import 'package:delapp/controllers/authentication.dart';
import 'package:flutter/material.dart';
import 'package:delapp/views/IzinKeluar.dart';
import 'package:delapp/views/booking.dart';
import 'package:get/get.dart';
import 'package:delapp/views/home.dart';
import 'package:delapp/views/surat.dart';

class Main extends StatelessWidget {
  final AuthenticationController authController = Get.find();

  Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Pindah ke Halaman Home'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SuratPage()),
                );
              },
              child: Text('Pindah ke Halaman Surat'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IzinKeluarPage()),
                );
              },
              child: Text('Pindah ke Halaman Izin Keluar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingPage()),
                );
              },
              child: Text('Pindah ke Halaman Booking'),
            ),
            ElevatedButton(
              onPressed: () async {
                await authController.logout();
                // Setelah logout, kembali ke halaman login atau halaman lain yang sesuai
                Navigator.pushReplacementNamed(context, 'login');
              },
              child: Text('Logout'),
            ),
            // Tambahkan tombol untuk menu lainnya di sini
          ],
        ),
      ),
    );
  }
}

void main() {
  // Inisialisasi GetX
  WidgetsFlutterBinding.ensureInitialized();

  // Menambahkan instance AuthenticationController ke dalam container
  Get.put(AuthenticationController());

  runApp(MaterialApp(
    home: Main(),
  ));
}