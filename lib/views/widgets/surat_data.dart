import 'package:flutter/material.dart';
import 'package:delapp/controllers/surat_controller.dart';
import 'package:delapp/models/surat_model.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SuratData extends StatefulWidget {
  const SuratData({
    super.key,
    required this.surat,
  });

  final SuratModel surat;

  @override
  State<SuratData> createState() => _SuratDataState();
}

class _SuratDataState extends State<SuratData> {
  final SuratController _suratController = Get.put(SuratController());
  bool likedPost = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.surat.user!.name!,
            style: GoogleFonts.poppins(),
          ),
          Text(
            widget.surat.user!.email!,
            style: GoogleFonts.poppins(
              fontSize: 10,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.surat.content!,
          ),
        ],
      ),
    );
  }
}
