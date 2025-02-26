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
    double totalPrice = cartService.getTotal(); // Tính tổng tiền ban đầu

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
    try {
      // Lưu đơn hàng vào MongoDB
      await MongoDatabase.ordersCollection.insertOne(order.toMap());
      print("Order saved successfully to MongoDB.");
    } catch (e) {
      print("Error saving order: $e");
    }
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

  // Áp dụng mã giảm giá cho đơn hàng và tính lại tổng tiền
  Future<double> applyCoupon(String couponCode) async {
    try {
      // Kiểm tra mã giảm giá trong MongoDB
      var coupon = await MongoDatabase.couponsCollection.findOne(
          {'code': couponCode, 'active': true}); // Tìm mã giảm giá hoạt động

      if (coupon == null) {
        print("Invalid or expired coupon.");
        return 0.0; // Không có giảm giá
      }

      // Lấy thời gian hết hạn của mã giảm giá từ MongoDB
      DateTime expiryDate = coupon['expiryDate'] is DateTime
          ? coupon['expiryDate'] // Nếu `expiryDate` đã là DateTime
          : DateTime.parse(coupon['expiryDate']); // Nếu là chuỗi thì parse lại

      DateTime currentDate = DateTime.now();

      // Kiểm tra xem mã giảm giá có hết hạn hay không
      if (expiryDate.isBefore(currentDate)) {
        print("Coupon has expired.");
        return 0.0; // Mã giảm giá đã hết hạn
      }

      // Lấy giá trị giảm giá và loại giảm giá từ coupon
      double discountValue = coupon['discountValue'].toDouble();
      String discountType =
          coupon['discountType']; // "percentage" hoặc "amount"

      double discountAmount = 0.0;

      // Áp dụng giảm giá theo phần trăm hoặc theo số tiền
      if (discountType == 'percentage') {
        // Giảm giá theo phần trăm
        discountAmount = discountValue / 100;
      } else if (discountType == 'amount') {
        // Giảm giá theo số tiền cố định
        discountAmount = discountValue;
      }

      return discountAmount;
    } catch (e) {
      print("Error applying coupon: $e");
      return 0.0; // Nếu có lỗi, không áp dụng giảm giá
    }
  }

  // Hàm tính lại tổng tiền sau khi áp dụng giảm giá
  double applyDiscountToTotal(double totalPrice, double discountAmount) {
    if (discountAmount < 1) {
      // Nếu là giảm giá phần trăm
      return totalPrice * (1 - discountAmount); // Tính giảm giá phần trăm
    } else {
      // Nếu là giảm giá số tiền cố định
      return totalPrice - discountAmount; // Trừ trực tiếp số tiền cố định
    }
  }

  // Cập nhật đơn hàng và lưu lại thông tin sau khi áp dụng mã giảm giá
  Future<void> updateOrderWithDiscount(Order order, String couponCode) async {
    // Áp dụng mã giảm giá
    double discountAmount = await applyCoupon(couponCode);

    // Cập nhật lại tổng tiền đơn hàng sau khi áp dụng giảm giá
    if (discountAmount > 0) {
      order.totalPrice = applyDiscountToTotal(order.totalPrice, discountAmount);
    }

    // Lưu đơn hàng đã cập nhật vào MongoDB
    await saveOrder(order);

    print("Order updated with discount and saved to MongoDB.");
  }
}
