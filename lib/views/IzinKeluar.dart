import 'package:delapp/models/izinKeluar_model.dart';
import 'package:flutter/material.dart';
import 'package:delapp/controllers/izinKeluar_controller.dart';
import 'package:get/get.dart';

class IzinKeluarPage extends StatefulWidget {
  @override
  _IzinKeluarPageState createState() => _IzinKeluarPageState();
}

class _IzinKeluarPageState extends State<IzinKeluarPage> {
  final IzinKeluarController izinKeluarController =
      Get.put(IzinKeluarController());
  final TextEditingController contentController = TextEditingController();
  final TextEditingController rencanaBerangkatController =
      TextEditingController();
  final TextEditingController rencanaKembaliController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    izinKeluarController.getAllIzinKeluars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Izin Keluar'),
      ),
      body: Obx(
        () => izinKeluarController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: izinKeluarController.izins.value.length,
                itemBuilder: (context, index) {
                  var izin = izinKeluarController.izins.value[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        izin.content ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Rencana Berangkat:',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '${izin.rencanaBerangkat?.toLocal() ?? 'Not specified'}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Rencana Kembali:',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '${izin.rencanaKembali?.toLocal() ?? 'Not specified'}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(izin);
                        },
                      ),
                      onTap: () {
                        // Handle item click
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(IzinKeluarModel izin) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus izin keluar ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _deleteIzin(izin);
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showFormDialog() async {
    DateTime? pickedRencanaBerangkat = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedRencanaBerangkat != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        pickedRencanaBerangkat = DateTime(
          pickedRencanaBerangkat.year,
          pickedRencanaBerangkat.month,
          pickedRencanaBerangkat.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        rencanaBerangkatController.text =
            pickedRencanaBerangkat.toLocal().toString();
      }
    }

    Get.defaultDialog(
      title: 'Tambah Izin Keluar',
      content: Column(
        children: [
          TextFormField(
            controller: contentController,
            decoration: InputDecoration(labelText: 'Content'),
          ),
          TextFormField(
            controller: rencanaBerangkatController,
            decoration: InputDecoration(labelText: 'Rencana Berangkat'),
            readOnly: true,
            onTap: () async {
              await _pickDateTime(rencanaBerangkatController);
            },
          ),
          TextFormField(
            controller: rencanaKembaliController,
            decoration: InputDecoration(labelText: 'Rencana Kembali'),
            readOnly: true,
            onTap: () async {
              await _pickDateTime(rencanaKembaliController);
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _submitForm();
              Get.back(); // Tutup dialog setelah submit
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateTime(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        controller.text = pickedDateTime.toLocal().toString();
      }
    }
  }

  void _deleteIzin(IzinKeluarModel izin) {
    // Pastikan izin.id tidak null sebelum memanggil fungsi hapus
    if (izin.id != null) {
      // Panggil fungsi hapus izin di controller
      izinKeluarController.deleteIzinKeluar(izin.id!);

      // Tampilkan notifikasi berhasil dihapus
      Get.snackbar(
        'Berhasil',
        'Izin keluar berhasil dihapus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh data setelah penghapusan izin
      izinKeluarController.getAllIzinKeluars();
    } else {
      // Handle jika izin.id null (optional)
      print('ID izin null, tidak dapat menghapus izin.');
    }
  }

  void _submitForm() {
    DateTime rencanaBerangkat = DateTime.parse(rencanaBerangkatController.text);
    DateTime rencanaKembali = DateTime.parse(rencanaKembaliController.text);

    izinKeluarController.createIzinKeluars(
      content: contentController.text,
      rencanaBerangkat: rencanaBerangkat,
      rencanaKembali: rencanaKembali,
    );

    // Tampilkan notifikasi berhasil ditambahkan
    Get.snackbar(
      'Berhasil',
      'Izin keluar berhasil ditambahkan',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Refresh data setelah penambahan izin
    izinKeluarController.getAllIzinKeluars();

    // Bersihkan nilai pada controller setelah submit
    contentController.clear();
    rencanaBerangkatController.clear();
    rencanaKembaliController.clear();
  }
}
