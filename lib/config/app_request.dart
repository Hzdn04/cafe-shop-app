import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:d_method/d_method.dart';

class AppRequest {
  static Future<Map?> get(String url) async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      DMethod.printTitle('try $url', response.body);
      // print(headers);

      Map responseBody = jsonDecode(response.body);

      // print(response);
      return responseBody;
    } catch (e) {
      DMethod.printTitle('catch', e.toString());
      return null;
    }
  }

  static Future<Map?> post(String url, Object? body,
      ) async {
    try {
      http.Response response =
          await http.post(Uri.parse(url), body: body);
      DMethod.printTitle('try $url', response.body);

      Map responseBody = jsonDecode(response.body);

      // print(response.statusCode);
      return responseBody;
    } catch (e) {
      DMethod.printTitle('catch', e.toString());
      return null;
    }
  }

  // static Future<Map?> delete(String url,
  //     {Map<String, String>? headers}) async {
  //   try {
  //     http.Response response =
  //         await http.delete(Uri.parse(url), headers: headers);
  //     DMethod.printTitle('try $url', response.body);

  //     Map responseBody = jsonDecode(response.body);

  //     // print(response.statusCode);
  //     return responseBody;
  //   } catch (e) {
  //     DMethod.printTitle('catch', e.toString());
  //     return null;
  //   }
  // }
  
}
