import 'package:food_del/DB/MongoDB.dart';
import 'package:food_del/Models/ReviewModel.dart';
import 'package:food_del/Models/orderModel.dart';
import 'package:food_del/Models/userModel.dart';
import 'package:food_del/Service/cart_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

class OrderService {
  final CartService cartService;

  OrderService({required this.cartService});

  // Phương thức tạo một đơn hàng mới từ giỏ hàng
  Order createOrder({
    required User user,
    required String userPhone,
    required String userAddress,
    required String note,
  }) {
    String orderId =
        ObjectId().toHexString(); // Tạo ID đơn hàng sử dụng ObjectId
    double totalPrice = cartService.getTotal(); // Tính tổng tiền
    DateTime orderDate = DateTime.now(); // Lấy ngày hiện tại

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
      orderDate: orderDate,
    );

    return order;
  }

  // Phương thức lưu đơn hàng vào MongoDB
  Future<void> saveOrder(Order order) async {
    try {
      await MongoDatabase.ordersCollection.insertOne(order.toMap());
      print("Đơn hàng đã được lưu thành công vào MongoDB.");
    } catch (e) {
      print("Lỗi khi lưu đơn hàng: $e");
    }
  }

  // Phương thức lấy lịch sử đơn hàng của người dùng bằng userId
  Future<List<Order>> getOrderHistory(String userId) async {
    try {
      var result = await MongoDatabase.ordersCollection
          .find({'userId': userId}).toList();

      return result.map((orderData) => Order.fromMap(orderData)).toList();
    } catch (e) {
      print("Lỗi khi lấy lịch sử đơn hàng: $e");
      return [];
    }
  }

  // Phương thức hủy đơn hàng và cập nhật trạng thái thành 'canceled'
  Future<void> cancelOrder(String orderId) async {
    try {
      var result =
          await MongoDatabase.ordersCollection.findOne({'orderId': orderId});

      if (result == null) {
        print("Không tìm thấy đơn hàng.");
        return;
      }

      // Cập nhật trạng thái của đơn hàng thành 'canceled'
      var updatedOrder = {...result};
      updatedOrder['status'] = 'canceled';

      // Lưu lại đơn hàng đã cập nhật vào MongoDB
      await MongoDatabase.ordersCollection.updateOne(
        where.eq('orderId', orderId),
        modify.set('status', 'canceled'),
      );

      print("Đơn hàng đã được hủy thành công.");
    } catch (e) {
      print("Lỗi khi hủy đơn hàng: $e");
    }
  }

  // Phương thức áp dụng mã giảm giá cho đơn hàng và tính lại tổng tiền
  Future<double> applyCoupon(String couponCode) async {
    try {
      var coupon = await MongoDatabase.couponsCollection
          .findOne({'code': couponCode, 'active': true});

      if (coupon == null) {
        print("Mã giảm giá không hợp lệ hoặc đã hết hạn.");
        return 0.0;
      }

      DateTime expiryDate = coupon['expiryDate'] is DateTime
          ? coupon['expiryDate']
          : DateTime.parse(coupon['expiryDate']);

      DateTime currentDate = DateTime.now();

      if (expiryDate.isBefore(currentDate)) {
        print("Mã giảm giá đã hết hạn.");
        return 0.0;
      }

      double discountValue = coupon['discountValue'].toDouble();
      String discountType = coupon['discountType'];

      double discountAmount = 0.0;

      if (discountType == 'percentage') {
        discountAmount = discountValue / 100;
      } else if (discountType == 'amount') {
        discountAmount = discountValue;
      }

      return discountAmount;
    } catch (e) {
      print("Lỗi khi áp dụng mã giảm giá: $e");
      return 0.0;
    }
  }

  // Phương thức tính tổng tiền sau khi áp dụng giảm giá
  double applyDiscountToTotal(double totalPrice, double discountAmount) {
    if (discountAmount < 1) {
      return totalPrice * (1 - discountAmount);
    } else {
      return totalPrice - discountAmount;
    }
  }

  // Phương thức cập nhật đơn hàng sau khi áp dụng giảm giá
  Future<void> updateOrderWithDiscount(Order order, String couponCode) async {
    double discountAmount = await applyCoupon(couponCode);

    if (discountAmount > 0) {
      order.totalPrice = applyDiscountToTotal(order.totalPrice, discountAmount);
    }

    await saveOrder(order);

    print("Đơn hàng đã được cập nhật với giảm giá và lưu vào MongoDB.");
  }

  // Phương thức đánh giá món ăn
  Future<void> addReview({
    required String userId,
    required String foodName,
    required String userName,
    required double rating,
    required String comment,
  }) async {
    try {
      // Kiểm tra nếu món ăn đã được đánh giá bởi người dùng này chưa
      var existingReview = await MongoDatabase.reviewsCollection
          .findOne({'userId': userId, 'foodName': foodName});

      if (existingReview != null) {
        print("Bạn đã đánh giá món ăn này rồi.");
        return; // Nếu đã đánh giá, không cho phép thêm đánh giá nữa
      }

      String reviewId = ObjectId().toHexString(); // Tạo ID đánh giá
      DateTime reviewDate = DateTime.now(); // Lấy thời gian hiện tại

      Review review = Review(
        reviewId: reviewId,
        userId: userId,
        foodName: foodName,
        userName: userName,
        rating: rating,
        comment: comment,
        reviewDate: reviewDate,
      );

      // Lưu đánh giá vào MongoDB
      await MongoDatabase.saveReview(review);
      print("Đánh giá đã được thêm thành công.");
    } catch (e) {
      print("Lỗi khi thêm đánh giá: $e");
    }
  }

  // Phương thức lấy tất cả đánh giá của món ăn
  Future<List<Review>> getReviews(String foodName) async {
    try {
      var result = await MongoDatabase.reviewsCollection
          .find({'foodName': foodName}).toList();

      return result.map((reviewData) => Review.fromMap(reviewData)).toList();
    } catch (e) {
      print("Lỗi khi lấy đánh giá món ăn: $e");
      return [];
    }
  }
}
