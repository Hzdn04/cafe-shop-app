class Menu {
  Menu({
    this.id,
    this.nama,
    this.harga,
    this.tipe,
    this.gambar,
  });

  int? id;
  String? nama;
  int? harga;
  String? tipe;
  String? gambar;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["id"],
        nama: json["nama"],
        harga: json["harga"],
        tipe: json["tipe"],
        gambar: json["gambar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "harga": harga,
        "tipe": tipe,
        "gambar": gambar,
      };
}
