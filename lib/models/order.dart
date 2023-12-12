class Order {
  String? nominalDiskon;
  String? nominalPesanan;
  List<Item>? items;

  Order({
    this.nominalDiskon,
    this.nominalPesanan,
    this.items,
  });

  Map<String, dynamic> toJson() => {
        "nominal_diskon": nominalDiskon,
        "nominal_pesanan": nominalPesanan,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  int? id;
  int? harga;
  String? catatan;

  Item(
    int id,
    int harga,
    String s,
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "harga": harga,
        "catatan": catatan,
      };
}
