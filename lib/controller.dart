import 'package:fiver/modals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class OrderProvider with ChangeNotifier {
  late MyJsonResponse jsonResponse;
  final String bearer =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvbjFjMy5za2ludXBob3JpYS5jb20iLCJpYXQiOjE2MzI1MDAxOTAsIm5iZiI6MTYzMjUwMDE5MCwiZXhwIjoxNjM1MDkyMTkwLCJkYXRhIjp7InVzZXIiOnsiaWQiOiIzMzQifX19.O4w-kiQjcAEVc3uxeDhuWnWlR8lG8OIEZ-0-JG8OVgs";
  final String url = "https://n1c3.skinuphoria.com/wp-json/skinuphoria/v2/orders/customer?start=0&length=10&sort=desc&sort_by=date";
  final String reviewUrl = "https://n1c3.skinuphoria.com/wp-json/skinuphoria/v1/orders/customer-complete-item-status";

  Future<MyJsonResponse> fetchAndSetOrders() async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-type': 'application/json', 'Accept': 'application/json', "Authorization": "Bearer $bearer"},
      );
      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      print(extractedData);
      jsonResponse = new MyJsonResponse(
        code: extractedData['code'],
        message: extractedData['message'],
        data: MyData(status: extractedData['data']['status'], total: extractedData['data']['total'], orders: (extractedData['data']['orders'] as List<dynamic>).map((e) => Orders(
          item_terms: (e['item_terms'] as List<dynamic>).map((e1) => ItemTerms(
            label: e1['label'],
            value: e1['value']
          )).toList(),
          order_fees:  (e['order_fees'] as List<dynamic>).map((e2) =>OrderFee(
            total: e2['total'],
            name: e2['name'],
            tax: e2['tax'],
          ) ).toList(),
          customer_id:  e['customer_id'],
          customer_name:  e['customer_name'],
          delivery_date_limit:  e['delivery_date_limit'],
          item_id:  e['item_id'],
          item_image:  e['item_image'],
          item_name:  e['item_name'],
          item_note_seller:  e['item_note_seller'],
          item_qty:  e['item_qty'],
          item_status:  e['item_status'],
          item_steam_profile:  e['item_steam_profile'],
          item_subtotal:  e['item_subtotal'],
          item_tax:  e['item_tax'],
          item_total:  e['item_total'],
          order_currency:  e['order_currency'],
          order_date:  e['order_date'],
          order_date_text:  e['order_date_text'],
          order_discount:  e['order_discount'],
          order_id:  e['order_id'],
          order_shipping:  e['order_shipping'],
          order_shipping_tax:  e['order_shipping_tax'],
          order_tax:  e['order_tax'],
          order_total:  e['order_total'],
          paid_date:  e['paid_date'],
          payment_method:  e['payment_method'],
          payment_method_icon:  e['payment_method_icon'],
          payment_method_title:  e['payment_method_title'],
          payment_status:  e['payment_status'],
          payment_url:  e['payment_url'],
          product_id:  e['product_id'],
          reference:  e['reference'],
          vendor_id:  e['vendor_id'],
          vendor_name:  e['vendor_name'],
        )).toList()),
      );
      print('\n\n\n\n\n\n\n\n\n');
      print('Code ${jsonResponse.code} message ${jsonResponse.message} Total ${jsonResponse.data.total} Status ${jsonResponse.data.status}');
      jsonResponse.data.orders.forEach((element) {
        print(element.product_id);
        print(element.item_name);
      });
      notifyListeners();
      return jsonResponse;

    } catch (error) {
      print('Some Thing went wrong $error');
      return  jsonResponse;
    }
  }

  Future<bool> reviewProduct(int orderId, int itemId,int rate, String message) async{
    try{
      final response = await http.post(
        Uri.parse(reviewUrl),
        body: json.encode({
          "order_id":orderId,
          "item_id":itemId,
          "rate": rate,
          "review_message":message
        }),
        headers: {'Content-type': 'application/json', 'Accept': 'application/json', "Authorization": "Bearer $bearer"},
      );

      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;
      print(extractedData);
      if(extractedData['code']=="success"){
        return true;
      }
      return false;


    }catch(error){
      print('error $error');
      return false;
    }
  }

  List<Orders> groupByItemStatus(){
    List<Orders> ord=[];
    jsonResponse.data.orders.forEach((element) {
      bool val=false;
      ord.forEach((inside) {
        if(inside.item_status==element.item_status){
          val=true;
        }
      });
      if(!val){
        ord.add(element);
      }
    });
    return ord;
  }
  List<Orders> getOrderById(Orders order){
    List<Orders> ord=[];
    jsonResponse.data.orders.forEach((element) {
      if(element.item_status==order.item_status){
        ord.add(element);
      }
    });
    return ord;
  }

}
