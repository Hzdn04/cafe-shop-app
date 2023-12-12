// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:test_venturo/fetch.dart';
import 'package:test_venturo/models/menu.dart';
import 'package:test_venturo/models/order.dart';
import 'package:test_venturo/models/voucher.dart';

class COrder extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _voucher = Voucher().obs;
  Voucher get voucher => _voucher.value;
  void clearVoucher() {
    _voucher.value = Voucher();
  }

  Future<void> redeemVoucher(String vouc) async {
    _voucher.value = (await FetchOrder.voucher(vouc))!;
    update();
  }

  final _listData = <Menu>[].obs;
  List<Menu> get listData => _listData.value;

  final _listItem = <Menu>[].obs;
  List<Menu> get listItem => _listItem.value;

  void clearItem() {
    _listItem.value = <Menu>[];
  }

  var subtotal = 0.0.obs;

  void addToCart(Menu menu) {
    listItem.add(menu);
    updateSubtotal();
  }

  void removeFromCart(Menu menu) {
    listItem.remove(menu);
    updateSubtotal();
  }

  void updateSubtotal() {
    double newSubtotal = listItem.fold(0, (sum, item) => sum + item.harga);
    subtotal.value = newSubtotal;
  }

  void clearSubTotal() {
    subtotal = 0.0.obs;
  }

  Future<List<Menu>?> getList() async {
    _listData.value = await FetchOrder.getMenus();
    update();

    return _listData.value;
  }

  // ===================== Checkout Area =======================

  final _listOrder = <Order>[].obs;
  List<Order> get listOrder => _listOrder.value;

  final _listCO = <Item>[].obs;
  List<Item> get listCO => _listCO.value;

  checkout() {}
}
