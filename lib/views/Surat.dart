import 'package:flutter/material.dart';
import 'package:delapp/controllers/surat_controller.dart';
import 'package:delapp/views/widgets/surat_data.dart';
import 'package:get/get.dart';
import 'widgets/post_field.dart';

class SuratPage extends StatefulWidget {
  const SuratPage({super.key});

  @override
  State<SuratPage> createState() => _SuratPageState();
}

class _SuratPageState extends State<SuratPage> {
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
                PostFIeld(
                  hintText: 'Apa yang kamu inginkan?',
                  controller: _textController,
                ),
                // const SizedBox(
                //   height: ,
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () async {
                    await _suratController.createSurats(
                      content: _textController.text.trim(),
                    );
                    _textController.clear();
                    _suratController.getAllSurats();
                  },
                  child: Obx(() {
                    return _suratController.isLoading.value
                        ? const CircularProgressIndicator()
                        : Text('Ajukan Surat');
                  }),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text('History surat'),
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
                          itemCount: _suratController.surats.value.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: SuratData(
                                surat: _suratController.surats.value[index],
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
