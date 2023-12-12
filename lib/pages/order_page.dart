import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_venturo/c_order.dart';
import 'package:test_venturo/config/style.dart';
import 'package:test_venturo/fetch.dart';
import 'package:test_venturo/models/menu.dart';
import 'package:test_venturo/models/order.dart';
import 'package:test_venturo/pages/edit_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final cOrder = Get.put(COrder());

  final controllerVoucher = TextEditingController();
  final noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cOrder.getList();
    });

    _focusNode.addListener(() {
      onFocusChange();
    });
    super.initState();
  }

  void onFocusChange() {
    setState(() {
      _isFocused = !_isFocused;
    });
  }

  void redeemVoucher() async {
    await cOrder.redeemVoucher(controllerVoucher.text);
  }

  void checkout(List<Item> items) async {
    bool yes = await FetchOrder.order(cOrder.voucher.nominal!.toString(),
        cOrder.subtotal.value.toString(), items);
    if (yes) {
      Get.snackbar('Berhasil', "Pesanan anda sedang diproses");
    } else {
      Get.snackbar('Server Trouble', "pastikan jaringan anda");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: GetBuilder<COrder>(builder: (_) {
        if (_.loading) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            )),
          );
        }
        if (_.listData.isEmpty) {
          return const Text('Not Found');
        }

        return RefreshIndicator(
          onRefresh: () => cOrder.getList(),
          child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _.listData.length,
              itemBuilder: (context, index) {
                return listMenu(_.listData[index]);
              }),
        );
      })),
      bottomNavigationBar: Container(
        height: 270,
        padding: const EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Obx(() {
              double total = cOrder.subtotal.value;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (cOrder.listItem.isNotEmpty) ...[
                      Text(
                          'Total pesanan (${cOrder.listItem.length} Menu) : '),
                    ] else ...[
                      const Text(
                          'Total pesanan : '),
                    ],
                    Text(
                      'Rp. $total',
                      style: TextStyle(color: kPrimaryColor),
                    ),
                  ],
                ),
              );
            }),
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.airplane_ticket,
                        color: kPrimaryColor,
                      ),
                      const Text('Redeem Voucher :'),
                    ],
                  ),
                  Obx(() {
                    return TextButton(
                      onPressed: () {
                        _showModalBottomSheet();
                      },
                      child: cOrder.voucher.kode == null
                          ? const Text(
                              'Input voucher >',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                              textAlign: TextAlign.center,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  cOrder.voucher.kode.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Rp. ${cOrder.voucher.nominal.toString()}',
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    );
                  })
                ],
              ),
            ),
            Container(
              height: 90,
              padding:
                  const EdgeInsets.only(top: 7, bottom: 3, right: 10, left: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: kPrimaryColor,
                        
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Pembayaran'),
                          const SizedBox(
                            height: 7,
                          ),
                          Obx(() {
                            if (cOrder.subtotal.value >=
                                cOrder.voucher.nominal!.toDouble()) {
                              double total = cOrder.subtotal.value -
                                  cOrder.voucher.nominal!.toDouble();
                              return Text('Rp $total');
                            } else {
                              return const Text('Rp 0');
                            }
                          }),
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      List<Item> listItems = cOrder.listItem.map((menu) {
                        return Item(menu.id, menu.harga, 'no');
                      }).toList();

                      if (cOrder.listItem.isNotEmpty) {
                        checkout(listItems);
                      }
                      Timer(const Duration(seconds: 2), () {
                        Get.to(() => const EditPage());
                      });
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: cOrder.listItem.isEmpty
                            ? Colors.grey[300]
                            : kPrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      'Pesan sekarang',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile listMenu(Menu data) {
    String price = data.harga.toString();
    return ListTile(
      leading: Image.network(
        data.gambar,
        height: 75,
        width: 75,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.nama),
          Text('Rp. $price', style: TextStyle(color: kPrimaryColor)),
          TextFormField(
            controller: noteController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.notes),
              fillColor: Colors.white,
              hintText: 'note',
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                cOrder.addToCart(data);
              });
            },
            icon: const Icon(
              Icons.add,
              size: 20,
            ),
          ),
          Obx(() => Text(
                '${cOrder.listItem.where((item) => item.id == data.id).length}',
                style: const TextStyle(fontSize: 12),
              )),
          IconButton(
            onPressed: () {
              setState(() {
                cOrder.removeFromCart(data);
              });
            },
            icon: const Icon(Icons.remove, size: 20),
          ),
        ],
      ),
    );
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        double modalHeight = MediaQuery.of(context).size.height * 0.5;
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        return SizedBox(
          height: _isFocused ? modalHeight + keyboardHeight : modalHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.airplane_ticket,
                      color: kPrimaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Punya kode voucher?',
                      style: TextStyle(color: Colors.black, fontSize: 23),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                const Text('Masukan kode voucher disini ',
                    style: TextStyle(color: Colors.black, fontSize: 12)),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: controllerVoucher,
                    decoration: const InputDecoration(
                      hintText: "puas",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      redeemVoucher();
                      Get.back();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      'Validasi Voucher',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }
}
