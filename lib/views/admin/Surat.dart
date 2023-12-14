import 'package:delapp/controllers/surat_controller.dart';
import 'package:delapp/views/widgets/post_field.dart';
import 'package:delapp/views/widgets/surat_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuratPageAdmin extends StatefulWidget {
  const SuratPageAdmin({Key? key});

  @override
  State<SuratPageAdmin> createState() => _SuratPageAdminState();
}

class _SuratPageAdminState extends State<SuratPageAdmin> {
  final SuratController _suratController = Get.put(SuratController());
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Surat'),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () async {
              await _suratController.getAllSurats();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                const SizedBox(
                  height: 30,
                ),
                Text('Pending Surat Requests'),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return _suratController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _suratController.pendingSurats.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: SuratData(
                                surat: _suratController.pendingSurats[index],
                              ),
                            );
                          },
                        );
                }),
                const SizedBox(
                  height: 20,
                ),
                Text('Approved Surats'),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return _suratController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _suratController.approvedSurats.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: SuratData(
                                surat:
                                    _suratController.approvedSurats[index],
                              ),
                            );
                          },
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
