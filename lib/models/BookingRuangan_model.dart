class BookingRuanganModel {
  BookingRuanganModel({
    this.id,
    this.userId,
    this.namaKegiatan,
    this.rencana_peminjaman,
    this.rencana_berakhir,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.ruanganId,
  });

  int? id;
  int? userId;
  String? namaKegiatan;
  DateTime? rencana_peminjaman;
  DateTime? rencana_berakhir;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status; // Menambahkan status booking (misal: "pending", "approved", "rejected")
  int? ruanganId; // ID ruangan yang di-book

  factory BookingRuanganModel.fromJson(Map<String, dynamic> json) => BookingRuanganModel(
        id: json["id"],
        userId: json["user_id"],
        namaKegiatan: json["nama_kegiatan"],
        rencana_peminjaman: DateTime.parse(json["rencana_peminjaman"]),
        rencana_berakhir: DateTime.parse(json["rencana_berakhir"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        status: json["status"],
        ruanganId: json["ruangan_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "nama_kegiatan": namaKegiatan,
        "rencana_peminjaman": rencana_peminjaman!.toIso8601String(),
        "rencana_berakhir": rencana_berakhir!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "status": status,
        "ruangan_id": ruanganId,
      };
}
