class IzinKeluarModel {
  IzinKeluarModel({
    this.id,
    this.userId,
    this.content,
    this.rencanaBerangkat,
    this.rencanaKembali,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? content;
  DateTime? rencanaBerangkat;
  DateTime? rencanaKembali;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory IzinKeluarModel.fromJson(Map<String, dynamic> json) => IzinKeluarModel(
        id: json["id"],
        userId: json["user_id"],
        content: json["content"],
        rencanaBerangkat: DateTime.parse(json["rencana_berangkat"]),
        rencanaKembali: DateTime.parse(json["rencana_kembali"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "content": content,
        "rencana_berangkat": rencanaBerangkat!.toIso8601String(),
        "rencana_kembali": rencanaKembali!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
