import 'package:food_del/DB/MongoDB.dart';
import 'package:food_del/Models/orderModel.dart';
import 'package:food_del/Models/userModel.dart';
import 'package:food_del/Service/cart_service.dart';
import 'package:mongo_dart/mongo_dart.dart'; // Import mongo_dart để sử dụng ObjectId

class OrderService {
  final CartService cartService;

  OrderService({required this.cartService});

  // Tạo một Order mới từ giỏ hàng
  Order createOrder({
    required User user,
    required String userPhone,
    required String userAddress,
    required String note,
  }) {
    String orderId = ObjectId()
        .toHexString(); // Tạo ID đơn hàng sử dụng ObjectId của MongoDB
    double totalPrice = cartService.getTotal();

    Order order = Order(
      orderId: orderId,
      userId: user.userId,
      userName: user.userName,
      userPhone: userPhone,
      userAddress: userAddress,
      items: cartService.items,
      totalPrice: totalPrice,
      status: 'pending',
      note: note,
    );

    return order;
  }

  // Lưu đơn hàng vào MongoDB
  Future<void> saveOrder(Order order) async {
    await MongoDatabase.saveOrder(order); // Lưu đơn hàng vào cơ sở dữ liệu
  }

  // Xem lịch sử đơn hàng của người dùng bằng userId
  Future<List<Order>> getOrderHistory(String userId) async {
    try {
      var result = await MongoDatabase.ordersCollection
          .find({'userId': userId}).toList(); // Truy vấn theo userId

      // Chuyển đổi dữ liệu từ MongoDB thành danh sách Order
      return result.map((orderData) => Order.fromMap(orderData)).toList();
    } catch (e) {
      print("Error fetching order history: $e");
      return [];
    }
  }
}
