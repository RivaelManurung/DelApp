import 'package:delapp/controllers/izinKeluar_controller.dart';
import 'package:flutter/material.dart';
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
                  return ListTile(
                    title: Text(izin.content ?? ''),
                    subtitle: Text(
                      'Rencana Berangkat: ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      // Tambahkan logika untuk menangani ketika item diklik
                    },
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

  void _submitForm() {
    DateTime rencanaBerangkat =
        DateTime.parse(rencanaBerangkatController.text);
    DateTime rencanaKembali =
        DateTime.parse(rencanaKembaliController.text);

    izinKeluarController.createIzinKeluars(
      content: contentController.text,
      rencanaBerangkat: rencanaBerangkat,
      rencanaKembali: rencanaKembali,
    );

    // Bersihkan nilai pada controller setelah submit
    contentController.clear();
    rencanaBerangkatController.clear();
    rencanaKembaliController.clear();
  }
}
