import 'package:delapp/controllers/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final BookingRuanganController controller =
      Get.put(BookingRuanganController());

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Booking Ruangan'),
        backgroundColor: Colors.indigo,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: controller.bookings.length,
                itemBuilder: (context, index) {
                  var booking = controller.bookings[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8.w),
                    child: ListTile(
                      title: Text(
                        booking.namaKegiatan ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rencana Peminjaman: ${booking.rencana_peminjaman?.toLocal()}',
                          ),
                          Text(
                            'Rencana Kembali: ${booking.rencana_berakhir?.toLocal()}',
                          ),
                          FutureBuilder<Ruangan?>(
                            future: controller
                                .getRuanganById(booking.ruanganId ?? 0),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  'Ruangan: Loading...',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Ruangan: Error',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                );
                              } else {
                                final ruangan = snapshot.data;
                                return Text(
                                  'Ruangan: ${ruangan?.namaRuangan ?? "Tidak Ada Ruangan"}',
                                  style: TextStyle(
                                    color: Colors.green,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showDeleteConfirmationDialog(booking.id ?? 0);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBookingDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  _showAddBookingDialog(BuildContext context) {
    TextEditingController namaKegiatanController = TextEditingController();
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Booking Ruangan'),
          content: Column(
            children: [
              TextField(
                controller: namaKegiatanController,
                decoration: InputDecoration(
                  labelText: 'Nama Kegiatan',
                  icon: Icon(Icons.event),
                ),
              ),
              SizedBox(height: 10.h),
              DropdownButton<Ruangan>(
                value: controller.selectedRuangan.value,
                onChanged: (Ruangan? value) {
                  controller.selectedRuangan.value = value;
                },
                items: controller.ruangans.map((Ruangan ruangan) {
                  return DropdownMenuItem<Ruangan>(
                    value: ruangan,
                    child: Text(ruangan.namaRuangan),
                  );
                }).toList(),
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null &&
                      pickedDate != controller.rencana_peminjaman.value) {
                    selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (selectedTime != null) {
                      controller.rencana_peminjaman.value = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );
                    }
                  }
                },
                child: Text('Pilih Rencana Berangkat'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                ),
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null &&
                      pickedDate != controller.rencana_berakhir.value) {
                    selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (selectedTime != null) {
                      controller.rencana_peminjaman.value = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );
                    }
                  }
                },
                child: Text('Pilih Rencana Kembali'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (namaKegiatanController.text.isNotEmpty &&
                    controller.selectedRuangan.value != null) {
                  controller.createBooking(
                    namaKegiatan: namaKegiatanController.text,
                    rencana_peminjaman:
                        controller.rencana_peminjaman.value ?? DateTime.now(),
                    rencana_berakhir:
                        controller.rencana_berakhir.value ?? DateTime.now(),
                    ruanganId: controller.selectedRuangan.value?.id ?? 1,
                  );
                  Navigator.pop(context);
                } else {
                  Fluttertoast.showToast(
                    msg: "Nama kegiatan dan ruangan harus diisi!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  showDeleteConfirmationDialog(int bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus booking ini?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                controller.deleteBooking(bookingId);
                Navigator.pop(context);
              },
              child: Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Tidak'),
            ),
          ],
        );
      },
    );
  }
}
