import 'package:delapp/controllers/izinBermalam_controller.dart';
import 'package:delapp/models/izinBermalam_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IzinBermalamPage extends StatefulWidget {
  @override
  _IzinBermalamPageState createState() => _IzinBermalamPageState();
}

class _IzinBermalamPageState extends State<IzinBermalamPage> {
  final IzinBermalamController izinBermalamController =
      Get.put(IzinBermalamController());

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izin Bermalam'),
      ),
      body: Obx(
        () => izinBermalamController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: izinBermalamController.izins.value.length,
                itemBuilder: (context, index) {
                  var izin = izinBermalamController.izins.value[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        izin.content ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'Rencana Berangkat:',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '${izin.rencanaBerangkat?.toLocal() ?? 'Not specified'}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Rencana Kembali:',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '${izin.rencanaKembali?.toLocal() ?? 'Not specified'}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
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
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(IzinBermalamModel izin) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus izin bermalam ini?'),
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
      title: 'Tambah Izin Bermalam',
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

  void _deleteIzin(IzinBermalamModel izin) {
    // Pastikan izin.id tidak null sebelum memanggil fungsi hapus
    if (izin.id != null) {
      // Panggil fungsi hapus izin di controller
      izinBermalamController.deleteIzinBermalam(izin.id!);

      // Tampilkan notifikasi berhasil dihapus
      Get.snackbar(
        'Berhasil',
        'Izin bermalam berhasil dihapus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh data setelah penghapusan izin
      izinBermalamController.getAllIzinBermalams();
    } else {
      // Handle jika izin.id null (optional)
      print('ID izin null, tidak dapat menghapus izin.');
    }
  }

  void _submitForm() {
    DateTime rencanaBerangkat = DateTime.parse(rencanaBerangkatController.text);
    DateTime rencanaKembali = DateTime.parse(rencanaKembaliController.text);

    izinBermalamController.createIzinBermalams(
      content: contentController.text,
      rencanaBerangkat: rencanaBerangkat,
      rencanaKembali: rencanaKembali,
    );

    // Tampilkan notifikasi berhasil ditambahkan
    Get.snackbar(
      'Berhasil',
      'Izin bermalam berhasil ditambahkan',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Refresh data setelah penambahan izin
    izinBermalamController.getAllIzinBermalams();

    // Bersihkan nilai pada controller setelah submit
    contentController.clear();
    rencanaBerangkatController.clear();
    rencanaKembaliController.clear();
  }
}
