import 'package:delapp/views/IzinKeluar.dart';
import 'package:flutter/material.dart';
import 'package:delapp/views/home.dart';
import 'package:delapp/views/surat.dart';

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

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
            ),ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IzinKeluarPage()),
                );
              },
              child: Text('Pindah ke Halaman Izin Keluar'),
            ),
            // Tambahkan tombol untuk menu lainnya di sini
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Main(),
  ));
}
