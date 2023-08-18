class LmsOrderModel {
  String? orderDate;
  List<OrderItem>? orderItems;
  String? orderMethod;
  String? orderNumber;
  String? orderStatus;
  String? orderTotal;
  String? orderSubTotal;
  String? orderKey;

  LmsOrderModel({
    this.orderDate,
    this.orderItems,
    this.orderMethod,
    this.orderNumber,
    this.orderStatus,
    this.orderTotal,
    this.orderKey,
    this.orderSubTotal,
  });

  factory LmsOrderModel.fromJson(Map<String, dynamic> json) {
    return LmsOrderModel(
      orderDate: json['order_date'],
      orderItems: json['order_items'] != null ? (json['order_items'] as List).map((i) => OrderItem.fromJson(i)).toList() : null,
      orderMethod: json['order_method'],
      orderNumber: json['order_number'],
      orderStatus: json['order_status'],
      orderTotal: json['order_total'],
      orderKey: json['order_total'],
      orderSubTotal: json['order_subtotal'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_date'] = this.orderDate;
    data['order_method'] = this.orderMethod;
    data['order_number'] = this.orderNumber;
    data['order_status'] = this.orderStatus;
    data['order_total'] = this.orderTotal;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItem {
  String? id;
  String? name;
  String? quantity;
  String? regularPrice;
  String? salePrice;

  OrderItem({this.id, this.name, this.quantity, this.regularPrice, this.salePrice});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      regularPrice: json['regular_price'],
      salePrice: json['sale_price'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    return data;
  }
}
