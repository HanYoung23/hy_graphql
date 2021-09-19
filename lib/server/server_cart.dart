// import 'dart:convert';
// import 'dart:io';
// import 'package:flowing/constants/keys.dart';
// import 'package:flowing/functions/popup.dart';
// import 'package:flowing/server/server_auth.dart';
// import 'package:flowing/storage/storage.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// Future postServerCart(BuildContext context, String productId, String quantity,
//     String storeId) async {
//   String userToken = await storage.read(key: "access_token");
//   String responseStatus;

//   var url = Uri.parse('http://$serverUrl/v1/carts');

//   await http.post(url, headers: {
//     HttpHeaders.authorizationHeader: "Bearer $userToken",
//   }, body: {
//     'product_id': productId,
//     'quantity': quantity,
//   }).then((response) {
//     var res = jsonDecode(response.body);
//     print("🛒 post cart res : ${res["code"]}");
//     // print("🛒 post cart res : ${res}");

//     if (res["code"] == 201) {
//       storeUserData("cart_productId", productId);
//       storeUserData("cart_quantity", quantity);
//       // storeUserData("cart_isDelivery", "$isDelivery");
//       storeUserData("cart_storeId", storeId);
//       // cartPopUp(context);
//       responseStatus = "201";
//     } else {
//       String errorM = res["message"];
//       errorPopUp(context, "장바구니에 담지 못했습니다.", '$errorM');
//     }
//   });
//   return responseStatus;
// }

// Future getServerCart(Function setCart) async {
//   var url = Uri.parse('http://$serverUrl/v1/carts');
//   String userToken = await storage.read(key: "access_token");

//   await http.get(url, headers: {
//     HttpHeaders.authorizationHeader: "Bearer $userToken",
//   }).then((response) {
//     String responseString = response.body.toString();
//     var res = jsonDecode(responseString);
//     print('🛒 cart item response : ${response.statusCode}');
//     // print('🛒 cart item response : ${res["data"]}');
//     List cartItem = [];
//     if (response.statusCode == 200) {
//       for (int i = 0; i < res["data"].length; i++) {
//         int price = res["data"][i]["product"]["sale_price"];
//         int quantity = res["data"][i]["quantity"];

//         cartItem.add({
//           "storeName": "${res["data"][i]["product"]["store"]["name"]}",
//           "storeId": "${res["data"][i]["product"]["store"]["id"]}",
//           "title": "${res["data"][i]["product"]["title"]}",
//           "content": "${res["data"][i]["product"]["content"]}",
//           "salePrice": price,
//           "thumbnailUrl":
//               "${res["data"][i]["product"]["thumbnails"][0]["url"]}",
//           "quantity": quantity,
//           "cartId": res["data"][i]["id"],
//           "productId": res["data"][i]["product"]["id"]
//         });
//       }
//       setCart(cartItem);
//     }
//   });
// }

// Future deleteAllServerCart() async {
//   var url = Uri.parse('http://$serverUrl/v1/carts');
//   String userToken = await storage.read(key: "access_token");

//   await http.delete(url, headers: {
//     HttpHeaders.authorizationHeader: "Bearer $userToken",
//   }).then((response) {
//     print('🛒 cart delete all response : ${response.statusCode}');
//     deleteUserData("cart_storeId");
//   });
// }

// Future deleteServerCart(String cartId) async {
//   var url = Uri.parse('http://$serverUrl/v1/carts/$cartId');
//   String userToken = await storage.read(key: "access_token");

//   await http.delete(url, headers: {
//     HttpHeaders.authorizationHeader: "Bearer $userToken",
//   }).then((response) {
//     print('🛒 cart delete response : ${response.statusCode}');
//   });
// }

// Future patchServerCart(String cartId, String quantity) async {
//   var url = Uri.parse('http://$serverUrl/v1/carts/$cartId/quantity');
//   String userToken = await storage.read(key: "access_token");

//   await http.patch(url, headers: {
//     HttpHeaders.authorizationHeader: "Bearer $userToken",
//   }, body: {
//     'quantity': quantity,
//   }).then((response) {
//     print('🛒 cart patch response : ${response.statusCode}');
//   });
// }
