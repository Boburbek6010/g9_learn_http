import 'dart:convert';

import 'package:http/http.dart';

class NetworkService{

  // baseUrl
  // static const String baseUrl = "dummyjson.com";
  static const String baseUrl = "6554a27063cafc694fe6bbeb.mockapi.io";

  // api
  // static const String apiGetAllProducts = "/products";
  // static const String apiDeleteProduct = "/products/";

  static const String apiGetAllData = "/art";
  static const String apiDeleteData = "/art/";

  // methods

  static Future<String> GET(String api)async{
    Uri url = Uri.https(baseUrl, api);
    Response response = await get(url);
    if(response.statusCode == 200 || response.statusCode == 201){
      return response.body;
    }else{
      return "Error statusCode of ${response.statusCode}";
    }
  }

  static Future<String> POST(String api, Map<String, dynamic> body)async{
    Uri url = Uri.https(baseUrl, api);
    Response response = await post(url, body: jsonEncode(body));
    if(response.statusCode == 200 || response.statusCode == 201){
      return response.body;
    }else{
      return "Error statusCode of ${response.statusCode}";
    }
  }

  static Future<String> DELETE(String api, int id)async{
    Uri url = Uri.https(baseUrl, api+id.toString());
    Response response = await delete(url);
    if(response.statusCode == 200 || response.statusCode == 201){
      return response.statusCode.toString();
    }else{
      return "Error statusCode of ${response.statusCode}";
    }
  }


}