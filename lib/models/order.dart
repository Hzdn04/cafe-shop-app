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
        "items": items?.map((item) => item.toJson()).toList(),
      };
}

class Item {
  final int id;
  final double harga;
  final String catatan;

  Item({required this.id, required this.harga, required this.catatan});

  Map<String, dynamic> toJson() => {
        "id": id,
        "harga": harga,
        "catatan": catatan,
      };
}
