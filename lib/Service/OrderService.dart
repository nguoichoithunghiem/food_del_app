import 'package:food_del/DB/MongoDB.dart';
import 'package:food_del/Models/orderModel.dart';
import 'package:food_del/Models/userModel.dart';
import 'package:food_del/Service/cart_service.dart';
import 'package:mongo_dart/mongo_dart.dart'; // Import mongo_dart để sử dụng ObjectId

class OrderService {
  final CartService cartService;

  OrderService({required this.cartService});

  // Tạo một Order mới từ giỏ hàng
  Order createOrder(
      {required User user,
      required String userPhone,
      required String userAddress,
      required String note}) {
    String orderId = ObjectId()
        .toHexString(); // Tạo ID đơn hàng sử dụng ObjectId của MongoDB
    double totalPrice = cartService.getTotal();

    // Tạo một Order mới từ thông tin giỏ hàng và thông tin người dùng
    Order order = Order(
      orderId: orderId, // Gán orderId là ObjectId đã tạo
      userId: user.userId, // Lấy userId từ đối tượng User
      userName: user.userName, // Lấy userName từ đối tượng User
      userPhone: userPhone, // Số điện thoại người dùng
      userAddress: userAddress, // Địa chỉ người dùng
      items: cartService.items, // Danh sách sản phẩm trong giỏ hàng
      totalPrice: totalPrice, // Tổng giá trị đơn hàng
      status: 'pending', // Trạng thái đơn hàng mặc định là "pending"
      note: note, // Ghi chú về đơn hàng
    );

    return order;
  }

  // Lưu đơn hàng vào MongoDB
  Future<void> saveOrder(Order order) async {
    await MongoDatabase.saveOrder(order); // Lưu đơn hàng vào cơ sở dữ liệu
  }
}
