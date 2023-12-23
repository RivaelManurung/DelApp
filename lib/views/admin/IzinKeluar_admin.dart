import 'package:delapp/controllers/adminizinKeluar_controller.dart';
import 'package:delapp/models/izinKeluar_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class IzinKeluarPageAdmin extends StatefulWidget {
  @override
  _IzinKeluarPageAdminState createState() => _IzinKeluarPageAdminState();
}

class _IzinKeluarPageAdminState extends State<IzinKeluarPageAdmin> {
  final AdminIzinKeluarController adminIzinKeluarController =
      Get.put(AdminIzinKeluarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Izin Keluar'),
        backgroundColor: Colors.blue,
      ),
      body: Obx(
        () => adminIzinKeluarController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : _buildList(),
      ),
    );
  }

  Widget _buildList() {
    final List<IzinKeluarModel> izins =
        adminIzinKeluarController.izins.value ?? [];

    if (izins.isEmpty) {
      return Center(
        child: Text('No Izin Keluar available.'),
      );
    }

    return ListView.builder(
      itemCount: izins.length,
      itemBuilder: (context, index) {
        var izin = izins[index];
        return _buildListItem(izin);
      },
    );
  }

  Widget _buildListItem(IzinKeluarModel izin) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showApprovalDialog(izin, 'accepted');
                  },
                  child: Text('Setujui'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showApprovalDialog(izin, 'rejected');
                  },
                  child: Text('Tolak'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ],
            ),
          ],
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

  Future<void> _showApprovalDialog(
      IzinKeluarModel izin, String status) async {
    try {
      await adminIzinKeluarController.updateIzinApprovalStatus(izin, status);
    } catch (error) {
      print('Error updating izin approval status: $error');
    }
  }
}
