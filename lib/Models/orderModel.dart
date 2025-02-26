// orderModel.dart
import 'package:food_del/Models/cart_item.dart';

class Order {
  String orderId;
  String userId;
  String userName;
  String userPhone;
  String userAddress;
  List<CartItem> items;
  double totalPrice; // Đổi từ final thành bình thường
  String status;
  String note;

  Order({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userAddress,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.note,
  });

  // Phương thức khởi tạo từ Map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      userId: map['userId'],
      userName: map['userName'],
      userPhone: map['userPhone'],
      userAddress: map['userAddress'],
      items: List<CartItem>.from(
          map['items'].map((item) => CartItem.fromMap(item))),
      totalPrice: map['totalPrice'],
      status: map['status'],
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'userAddress': userAddress,
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'note': note,
    };
  }
}
