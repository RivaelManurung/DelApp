// admin_booking_page.dart

import 'package:delapp/controllers/adminbooking_controller.dart';
import 'package:delapp/controllers/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminBookingPage extends StatefulWidget {
  const AdminBookingPage({Key? key}) : super(key: key);

  @override
  _AdminBookingPageState createState() => _AdminBookingPageState();
}

class _AdminBookingPageState extends State<AdminBookingPage> {
  final AdminBookingController controller =
      Get.put(AdminBookingController()); // Use AdminBookingController

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin: Daftar Booking Ruangan'),
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
                                return Text('Ruangan: Loading...');
                              } else if (snapshot.hasError) {
                                print(
                                    'Error fetching ruangan: ${snapshot.error}');
                                return Text('Ruangan: Error');
                              } else if (snapshot.hasData &&
                                  snapshot.data != null) {
                                final ruangan = snapshot.data!;
                                print('Ruangan: ${ruangan.namaRuangan}');
                                return Text('Ruangan: ${ruangan.namaRuangan}');
                              } else {
                                print('Ruangan: Not available');
                                return Text('Ruangan: Not available');
                              }
                            },
                          ),
                          Text(
                            'Status: ${booking.status ?? "Belum Diproses"}',
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Add logic to approve booking
                              controller.updateBookingStatus(
                                booking.id ?? 0,
                                'approved',
                              );
                            },
                            child: Text('Approve'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Add logic to reject booking
                              controller.updateBookingStatus(
                                booking.id ?? 0,
                                'rejected',
                              );
                            },
                            child: Text('Reject'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
