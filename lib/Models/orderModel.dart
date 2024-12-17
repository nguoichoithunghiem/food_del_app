import 'package:food_del/Models/cart_item.dart';

class Order {
  final String orderId;
  final String userId; // ID của người dùng
  final String userName; // Tên người dùng
  final String userPhone; // Số điện thoại người dùng
  final String userAddress; // Địa chỉ người dùng
  final List<CartItem> items; // Danh sách sản phẩm trong giỏ hàng
  final double totalPrice; // Tổng giá trị đơn hàng
  final String
      status; // Trạng thái đơn hàng: "pending", "confirmed", "shipping", "completed", "cancelled"
  final String note; // Ghi chú về đơn hàng

  // Constructor để khởi tạo đơn hàng
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

  // Phương thức chuyển Order thành Map để lưu trữ vào MongoDB hoặc gửi qua API
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'userAddress': userAddress,
      'items': items
          .map((item) => item.toMap())
          .toList(), // Chuyển các CartItem thành Map
      'totalPrice': totalPrice,
      'status': status,
      'note': note,
    };
  }

  // Tạo Order từ Map khi nhận dữ liệu từ MongoDB hoặc API
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhone: map['userPhone'] ?? '',
      userAddress: map['userAddress'] ?? '',
      items: List<CartItem>.from(
          map['items']?.map((item) => CartItem.fromMap(item)) ?? []),
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      status: map['status'] ?? 'pending',
      note: map['note'] ?? '',
    );
  }
}
