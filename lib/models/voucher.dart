class Voucher {
    int? id;
    String? kode;
    String? gambar;
    int? nominal;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;

    Voucher({
        this.id,
        this.kode,
        this.gambar,
        this.nominal = 0,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        id: json["id"],
        kode: json["kode"],
        gambar: json["gambar"],
        nominal: json["nominal"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "kode": kode,
        "gambar": gambar,
        "nominal": nominal,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}