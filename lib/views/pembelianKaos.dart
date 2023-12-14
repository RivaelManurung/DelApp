// ignore: file_names
import 'package:delapp/controllers/pembelianKaos_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PembelianKaosPage extends StatefulWidget {
  const PembelianKaosPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PembelianKaosPageState createState() => _PembelianKaosPageState();
}

class _PembelianKaosPageState extends State<PembelianKaosPage> {
  final PembelianKaosController izinBermalamController =
      Get.put(PembelianKaosController());
  final TextEditingController contentController = TextEditingController();
  final TextEditingController rencanaBerangkatController =
      TextEditingController();
  final TextEditingController rencanaKembaliController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    izinBermalamController.getAllIzinBermalams();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFEDECF2),
        body: ListView(
          children: [
            const ItemAppBar(),
            const Image(
              image: AssetImage("images/baju-del.jpg"),
              width: 200,
              fit: BoxFit.cover,
            ),
            Container(
              height: 75,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kaos berkerah Institut Teknologi Del - Putih',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Rp103.000',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: SizedBox(
            height: 70.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(300,
                        40)), // Sesuaikan lebar dan tinggi sesuai kebutuhan
                    backgroundColor: MaterialStateProperty.all(const Color(
                        0xFF4C53A5)), // Ganti warna latar sesuai kebutuhan
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10.0)),
                      ),
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 410,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(
                                        Icons.close,
                                      ),
                                    ),
                                    const Text(
                                      'Varian Kaos',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _showImageDialog(context);
                                        },
                                        child: Image.asset(
                                          "images/single-baju-del.png",
                                          width: 100,
                                        ),
                                      ),
                                    ),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rp103.000',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text('stok: 67')
                                      ],
                                    )
                                  ],
                                ),
                                const Divider(),
                                const YourSegmentedButton(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                            onPressed: () {

                                              // logic
                                              

                                            },
                                            child: const Text('Beli')),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Beli Sekarang',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ), // Ganti warna sesuai kebutuhan
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class ItemAppBar extends StatelessWidget {
  const ItemAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              navigator?.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Color(0xFF4C53A5),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Pembelian Kaos',
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C53A5)),
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.favorite,
            size: 30,
            color: Colors.red,
          )
        ],
      ),
    );
  }
}

// screen ukuran baju
class YourSegmentedButton extends StatefulWidget {
  const YourSegmentedButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _YourSegmentedButtonState createState() => _YourSegmentedButtonState();
}

class _YourSegmentedButtonState extends State<YourSegmentedButton> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Ukuran',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Transform.scale(
              scale: 1.2, // Sesuaikan nilai scale sesuai kebutuhan
              child: CupertinoSegmentedControl<int>(
                children: const {
                  0: Text('S'),
                  1: Text('M'),
                  2: Text('L'),
                  3: Text('XL'),
                  4: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('XXL')),
                },
                onValueChanged: (int newValue) {
                  setState(() {
                    selectedIndex = newValue;
                  });
                },
                groupValue: selectedIndex,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ukuran yang dipilih:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            getSelectedSize(),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  String getSelectedSize() {
    switch (selectedIndex) {
      case 0:
        return 'S';
      case 1:
        return 'M';
      case 2:
        return 'L';
      case 3:
        return 'XL';
      case 4:
        return 'XXL';
      default:
        return '';
    }
  }
}

void _showImageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Tutup dialog saat gambar diklik
          },
          child: SizedBox(
            width: 300, // Atur ukuran sesuai kebutuhan Anda
            height: 300,
            child: Image.asset(
              "images/single-baju-del.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    },
  );
}
