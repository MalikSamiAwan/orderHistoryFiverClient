
 import 'package:flutter/material.dart';

class MyConstants{
  static const primaryColor = const Color(0xff3e1041);
  static const pageTitleColor = const Color(0xffb3534b);
  static const greenColor = const Color(0xff00b73b);
  static const blackBgColor = const Color(0xff151515);
  static const textColor = const Color(0xff968d96);
  static const redButton = const Color(0xffe00914);
  static const button1 = const Color(0xff904996);
  static const color6 = const Color(0xff);
}

class MyJsonResponse{
  late String code;
  late String message;
  late MyData data;

  MyJsonResponse({
    this.code="Fail",
    this.message="Failed",
    required this.data,
});

  MyJsonResponse.fromMap(
      var map
      ){
    this.code=map['code'];
    this.message=map['message'];
    this.data=map['data'];
  }

  Map<String, dynamic> toMap(){
    var map=Map<String,dynamic>();
    map['code']=this.code;
    map['message']=this.message;
    map['data']=this.data;
    return map;
  }

}

class MyData{
  late int status;
  late List<Orders> orders;
  late int total;
  MyData({
    this.status=400,
    required this.orders,
    this.total=-1
});

  MyData.fromMap(
      var map
      ){
    this.status=map['status'];
    this.orders=(map['orders'] as List).map((e) => Orders.fromMap(e)).toList();
    this.total=map['total'];
  }

  Map<String, dynamic> toMap(){
    var map=Map<String,dynamic>();
    map['status']=this.status;
    map['orders']=this.orders.map((e) => e.toMap()).toList();
    map['total']=this.total;
    return map;
  }

}

class Orders{
  late int order_id;
  late int customer_id;
  late String customer_name;
  late String vendor_id;
  late String vendor_name;
  late String order_date;
  late String order_date_text;
  late String delivery_date_limit;
  late String paid_date;
  late String reference;
  late String payment_url;
  late String order_currency;
  late String order_discount;
  late String order_shipping;
  late String order_shipping_tax;
  late String order_tax;
  late List<OrderFee> order_fees;
  late String order_total;
  late String payment_method;
  late String payment_method_title;
  late String payment_method_icon;
  late String payment_status;
  late int item_id;
  late String item_name;
  late String item_status;
  late String item_note_seller;
  late String item_steam_profile;
  late int item_qty;
  late String item_subtotal;
  late String item_tax;
  late String item_total;
  late String item_image;
  late List<ItemTerms> item_terms;
  late int product_id;

  Orders({
    this.order_id=-1,
    this.customer_id=-1,
    this.customer_name="",
    this.vendor_id="",
    this.vendor_name="",
    this.order_date="",
    this.order_date_text="",
    this.delivery_date_limit="",
    this.paid_date="",
    this.reference="",
    this.payment_url="",
    this.order_currency="",
    this.order_discount="",
    this.order_shipping="",
    this.order_shipping_tax="",
    this.order_tax="",
    required this.order_fees,
    this.order_total="",
    this.payment_method="",
    this.payment_method_title="",
    this.payment_method_icon="",
    this.payment_status="",
    this.item_id=-1,
    this.item_name="",
    this.item_status="",
    this.item_note_seller="",
    this.item_steam_profile="",
    this.item_qty=-1,
    this.item_subtotal="",
    this.item_tax="",
    this.item_total="",
    this.item_image="",
    required this.item_terms,
    this.product_id=-1,
});

  Orders.fromMap(
      var map
      ){
    this.order_id=map['order_id'];
    this.customer_id=map['customer_id'];
    this.customer_name=map['customer_name'];
    this.vendor_id=map['vendor_id'];
    this.vendor_name=map['vendor_name'];
    this.order_date=map['order_date'];
    this.order_date_text=map['order_date_text'];
    this.delivery_date_limit=map['delivery_date_limit'];
    this.paid_date=map['paid_date'];
    this.reference=map['reference'];
    this.payment_url=map['payment_url'];
    this.order_currency=map['order_currency'];
    this.order_discount=map['order_discount'];
    this.order_shipping=map['order_shipping'];
    this.order_shipping_tax=map['order_shipping_tax'];
    this.order_tax=map['order_tax'];
    this.order_fees=(map['order_fees'] as List).map((e) => OrderFee.fromMap(e)).toList();
    this.order_total=map['order_total'];
    this.payment_method=map['payment_method'];
    this.payment_method_title=map['payment_method_title'];
    this.payment_method_icon=map['payment_method_icon'];
    this.payment_status=map['payment_status'];
    this.item_id=map['item_id'];
    this.item_name=map['item_name'];
    this.item_status=map['item_status'];
    this.item_note_seller=map['item_note_seller'];
    this.item_steam_profile=map['item_steam_profile'];
    this.item_qty=map['item_qty'];
    this.item_subtotal=map['item_subtotal'];
    this.item_tax=map['item_tax'];
    this.item_total=map['item_total'];
    this.item_image=map['item_image'];
    this.item_terms=(map['item_terms'] as List).map((e) => ItemTerms.fromMap(e)).toList();
    this.product_id=map['product_id'];
  }

  Map<String, dynamic> toMap(){
    var map=Map<String,dynamic>();

    map['order_id']=this.order_id;
    map['customer_id']=this.customer_id;
    map['customer_name']=this.customer_name;
    map['vendor_id']=this.vendor_id;
    map['vendor_name']=this.vendor_name;
    map['order_date']=this.order_date;
    map['order_date_text']=this.order_date_text;
    map['delivery_date_limit']=this.delivery_date_limit;
    map['paid_date']=this.paid_date;
    map['reference']=this.reference;
    map['payment_url']=this.payment_url;
    map['order_currency']=this.order_currency;
    map['order_discount']=this.order_discount;
    map['order_shipping']=this.order_shipping;
    map['order_shipping_tax']=this.order_shipping_tax;
    map['order_tax']=this.order_tax;
    map['order_fees']=this.order_fees.map((e) => e.toMap()).toList();
    map['order_total']=this.order_total;
    map['payment_method']=this.payment_method;
    map['payment_method_title']= this.payment_method_title;
    map['payment_method_icon']=this.payment_method_icon;
    map['payment_status']=this.payment_status;
    map['item_id']=this.item_id;
    map['item_name']=this.item_name;
    map['item_status']=this.item_status;
    map['item_note_seller']=this.item_note_seller;
    map['item_steam_profile']=this.item_steam_profile;
    map['item_qty']=this.item_qty;
    map['item_subtotal']=this.item_subtotal;
    map['item_tax']=this.item_tax;
    map['item_total']=this.item_total;
    map['item_image']=this.item_image;
    map['item_terms']=this.item_terms.map((e) => e.toMap()).toList();
    map['product_id']=this.product_id;

    return map;
  }

}

class OrderFee{
  late String name;
  late String tax;
  late String total;

  OrderFee({
    this.name="",
    this.total="",
    this.tax=""
});


  OrderFee.fromMap(
      var map
      ){
    this.name=map['name'];
    this.tax=map['tax'];
    this.total=map['total'];
  }

  Map<String, dynamic> toMap(){
    var map=Map<String,dynamic>();
    map['name']=this.name;
    map['tax']=this.tax;
    map['total']=this.total;
    return map;
  }
}
class ItemTerms{
  late String label;
  late String value;
  ItemTerms({
    this.label="",
    this.value="",
});

  ItemTerms.fromMap(
      var map
      ){
    this.label=map['label'];
    this.value=map['value'];
  }

  Map<String, dynamic> toMap(){
    var map=Map<String,dynamic>();
    map['label']=this.label;
    map['value']=this.value;
    return map;
  }
}