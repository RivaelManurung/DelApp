// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';
IzinKeluarModel postModelFromJson(String str) => IzinKeluarModel.fromJson(json.decode(str));

String postModelToJson(IzinKeluarModel data) => json.encode(data.toJson());

class IzinKeluarModel {
  IzinKeluarModel({
    this.id,
    this.userId,
    this.content,
    this.rencana_berangkat,
    this.rencana_kembali,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? content;
  DateTime? rencana_berangkat;
  DateTime? rencana_kembali;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory IzinKeluarModel.fromJson(Map<String, dynamic> json) => IzinKeluarModel(
        id: json["id"],
        userId: json["user_id"],
        content: json["content"],
        rencana_berangkat: DateTime.parse(json["rencana_berangkat"]),
        rencana_kembali: DateTime.parse(json["rencana_kembali"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "content": content,
        "rencana_berangkat" : rencana_berangkat!.toIso8601String(),
        "rencana_kembali" : rencana_kembali!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
       };
}
