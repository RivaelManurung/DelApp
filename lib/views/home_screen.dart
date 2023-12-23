import 'package:delapp/views/IzinBermalam.dart';
import 'package:delapp/views/IzinKeluar.dart';
import 'package:delapp/views/Surat.dart';
import 'package:delapp/views/booking.dart';
import 'package:delapp/views/pembelianKaos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:delapp/views/IzinBermalam.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApps());
}

class MyApps extends StatelessWidget {
  const MyApps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _navigateToPage(String pageTitle) {
    switch (pageTitle) {
      case 'Izin Keluar':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IzinKeluarPage()),
        );
        break;

      case 'Request surat':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SuratPage()), // Navigate to Request Surat Page
        );
        break;

      case 'Booking ruangan':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BookingPage()), // Navigate to Request Surat Page
        );
        break;

      case 'Izin Bermalam':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IzinBermalamPage()),
        );
        break;

      case 'Pembelian Kaos':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PembelianKaosPage()),
        );
        break;
        case 'Booking ruangan':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookingPage()), // Navigate to Request Surat Page
        );
        break;
        case 'Izin Bermalam':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IzinBermalamPage()),
        );
        break;

      case 'Pembelian Kaos':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PembelianKaosPage()),
        );
        break;
      // Add cases for other dashboard items here
    }
  }

  Widget itemDashboard(String title, IconData iconData, Color background) =>
      GestureDetector(
        onTap: () => _navigateToPage(title),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 5),
                  color: Theme.of(context).primaryColor.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 5),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, color: Colors.white)),
              const SizedBox(height: 8),
              Text(title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text('Hello Selamat Datang', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(200))),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  itemDashboard('Izin Keluar', CupertinoIcons.arrow_right_square, Colors.deepOrange),
                  itemDashboard('Request surat', CupertinoIcons.envelope, Colors.green),
                  itemDashboard('Booking ruangan', CupertinoIcons.house, Colors.purple),
                  itemDashboard('Izin Bermalam', CupertinoIcons.chat_bubble_2, Colors.brown),
                  itemDashboard('Pembelian Kaos', CupertinoIcons.add_circled, Colors.teal),
                  itemDashboard('Logout', CupertinoIcons.question_circle, Colors.blue),

                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}



