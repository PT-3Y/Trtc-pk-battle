class CourseOrders {
  CourseOrders({
      this.id, 
      this.orderNumber, 
      this.orderItems, 
      this.orderStatus,});

  CourseOrders.fromJson(dynamic json) {
    id = json['id'];
    orderNumber = json['order_number'];
    if (json['order_items'] != null) {
      orderItems = [];
      json['order_items'].forEach((v) {
        orderItems?.add(OrderItems.fromJson(v));
      });
    }
    orderStatus = json['order_status'];
  }
  num? id;
  String? orderNumber;
  List<OrderItems>? orderItems;
  String? orderStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['order_number'] = orderNumber;
    if (orderItems != null) {
      map['order_items'] = orderItems?.map((v) => v.toJson()).toList();
    }
    map['order_status'] = orderStatus;
    return map;
  }

}

class OrderItems {
  OrderItems({
      this.id, 
      this.name, 
      this.regularPrice, 
      this.salePrice, 
      this.quantity,});

  OrderItems.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    quantity = json['quantity'];
  }
  String? id;
  String? name;
  String? regularPrice;
  String? salePrice;
  String? quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['regular_price'] = regularPrice;
    map['sale_price'] = salePrice;
    map['quantity'] = quantity;
    return map;
  }

}