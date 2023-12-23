import 'package:flutter/material.dart';
import 'package:delapp/models/izinKeluar_model.dart';
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
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Obx(
              () => izinKeluarController.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : _buildList(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: () {
        _showFormDialog();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Tambah Izin Keluar',
          style: TextStyle(fontSize: 18),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: izinKeluarController.izins.value.length,
      itemBuilder: (context, index) {
        var izin = izinKeluarController.izins.value[index];
        return _buildListItem(izin);
      },
    );
  }

  Widget _buildListItem(IzinKeluarModel izin) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Content', izin.content ?? 'Not specified'),
              SizedBox(height: 8),
              _buildInfoRow(
                'Rencana Berangkat',
                '${izin.rencanaBerangkat?.toLocal() ?? 'Not specified'}',
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                'Rencana Kembali',
                '${izin.rencanaKembali?.toLocal() ?? 'Not specified'}',
              ),
              SizedBox(height: 8),
              _buildInfoRow('Status', izin.status ?? 'Not specified'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(izin);
                    },
                    child: Text('Hapus'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
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
                Navigator.of(context).pop();
              },
              child: Text('Batal', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                _deleteIzin(izin);
                Navigator.of(context).pop();
              },
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
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
            decoration: InputDecoration(
              labelText: 'Content',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: rencanaBerangkatController,
            decoration: InputDecoration(
              labelText: 'Rencana Berangkat',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            readOnly: true,
            onTap: () async {
              await _pickDateTime(rencanaBerangkatController);
            },
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: rencanaKembaliController,
            decoration: InputDecoration(
              labelText: 'Rencana Kembali',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
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
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
      status: 'Pending', // Set the default status
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
