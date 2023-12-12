import 'package:get/get.dart';
import 'package:test_venturo/config/api.dart';
import 'package:test_venturo/config/app_request.dart';
import 'package:test_venturo/models/menu.dart';
import 'package:test_venturo/models/order.dart';
import 'package:test_venturo/models/voucher.dart';

class FetchOrder {
  static Future<List<Menu>> getMenus() async {
    String url = Api.menu;

    Map? responseBody = await AppRequest.get(url);

    if (responseBody == null) return [];

    if (responseBody['status_code'] == 200) {
      List list = responseBody['datas'];
      return list.map((e) => Menu.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<Voucher?> voucher(String code) async {
    String url = '${Api.voucher}?kode=$code';

    Map? responseBody = await AppRequest.get(url);

    if (responseBody == null) return null;

    if (responseBody['status_code'] == 200) {
      Map<String, dynamic> data = responseBody['datas'];
      return Voucher.fromJson(data);
    } else if (responseBody['status_code'] == 204) {
      Get.snackbar('Incorrect', "Vocher tidak ditemukan");
      return Voucher();
    } else {
      Get.snackbar('Server Trouble', "pastikan jaringan anda");
      return Voucher();
    }
  }

  static Future<bool> order(String diskon, String pesanan, List<Item> items) async {
    String url = Api.order;

    Map? responseBody = await AppRequest.post(url, {
      'nominal_diskon': diskon,
      'nominal_pesanan': pesanan,
      'items': items
    });

    if (responseBody == null) return false;

    if (responseBody['status_code'] == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> cancel(String id) async {
    String url = '${Api.order}/cancel/$id';

    Map? responseBody = await AppRequest.post(url, {});

    if (responseBody == null) return;

    if (responseBody['status_code'] == 200) {
      Get.snackbar('Berhasil', "Pesanan anda akan dicancel");
    } else if (responseBody['status_code'] == 204) {
      Get.snackbar('Incorrect', "Data tidak ditemukan");
    } else {
      Get.snackbar('Server Trouble', "pastikan jaringan anda");
    }
  }
}
