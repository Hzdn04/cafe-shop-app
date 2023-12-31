import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:test_venturo/pages/order_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp( 
      debugShowCheckedModeBanner: false,
      home: OrderPage(),
    );
  }
}
