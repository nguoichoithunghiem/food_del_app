import 'package:food_del/DB/Constant.dart';
import 'package:food_del/Models/ReviewModel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:food_del/Models/orderModel.dart';
import 'package:food_del/Models/WishlistItem.dart'; // Import WishlistItem model

class MongoDatabase {
  static Db? _db;
  static DbCollection? _usersCollection;
  static DbCollection? _foodsCollection;
  static DbCollection? _categoriesCollection;
  static DbCollection? _ordersCollection;
  static DbCollection? _orderDetailsCollection;
  static DbCollection? _wishlistsCollection; // Thêm collection wishlists
  static DbCollection? _couponsCollection; // Thêm collection coupons
  static DbCollection? _reviewsCollection;

  // Kết nối MongoDB
  static Future<Db> connect() async {
    if (_db == null) {
      _db = await Db.create(MONGO_URL);
      await _db!.open();
      print("DB connected");
    }
    return _db!;
  }

  // Getter cho các collections
  static DbCollection get usersCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _usersCollection ??= _db!.collection(COLLECTION_USER);
    return _usersCollection!;
  }

  static DbCollection get foodsCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _foodsCollection ??= _db!.collection(COLLECTION_FOOD);
    return _foodsCollection!;
  }

  static DbCollection get categoriesCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _categoriesCollection ??= _db!.collection(COLLECTION_CATEGORY);
    return _categoriesCollection!;
  }

  static DbCollection get ordersCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _ordersCollection ??= _db!.collection(COLLECTION_ORDER);
    return _ordersCollection!;
  }

  static DbCollection get orderDetailsCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _orderDetailsCollection ??= _db!.collection(COLLECTION_ORDERDETAIL);
    return _orderDetailsCollection!;
  }

  static DbCollection get wishlistsCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _wishlistsCollection ??= _db!.collection(COLLECTION_WISHLIST);
    return _wishlistsCollection!;
  }

  static DbCollection get couponsCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _couponsCollection ??= _db!.collection(
        COLLECTION_COUPON); // COLLECTION_COUPONS là tên collection coupon trong MongoDB
    return _couponsCollection!;
  }

  // Kiểm tra mã giảm giá hợp lệ
  static Future<Map<String, dynamic>?> checkCoupon(String code) async {
    try {
      var result = await couponsCollection.findOne({
        'code': code,
        'active': true, // Kiểm tra mã giảm giá còn hoạt động hay không
        'expiryDate': {
          '\$gte': DateTime.now()
              .toIso8601String(), // Kiểm tra mã giảm giá chưa hết hạn
        }
      });

      return result; // Nếu có coupon hợp lệ, trả về thông tin coupon
    } catch (e) {
      print("Error checking coupon: $e");
      return null;
    }
  }

  // Lưu đơn hàng vào MongoDB
  static Future<void> saveOrder(Order order) async {
    try {
      // Lưu đơn hàng vào ordersCollection
      await ordersCollection.insertOne(order.toMap());
      print("Order saved to orders collection");

      // Lưu các chi tiết đơn hàng vào orderDetailsCollection
      for (var item in order.items) {
        await orderDetailsCollection.insertOne({
          'orderId': order.orderId,
          'foodName': item.foodName,
          'foodImage': item.foodImage,
          'foodPrice': item.price,
          'quantity': item.quantity,
        });
        print("Order detail saved for ${item.foodName}");
      }
    } catch (e) {
      print("Error saving order: $e");
    }
  }

  // Thêm món ăn vào wishlist
  static Future<void> addToWishlist(String userId, String foodId,
      String foodName, String foodImage, double foodPrice) async {
    try {
      var wishlistItem = WishlistItem(
        userId: userId,
        foodId: foodId,
        foodName: foodName,
        foodImage: foodImage,
        foodPrice: foodPrice,
      );

      // Kiểm tra xem món ăn đã có trong wishlist của người dùng chưa
      var existingItem = await wishlistsCollection.findOne({
        'userId': userId,
        'foodId': foodId,
      });

      if (existingItem == null) {
        // Nếu chưa có, thêm vào wishlist
        await wishlistsCollection.insertOne(wishlistItem.toMap());
        print("Added to wishlist");
      } else {
        print("Item already in wishlist");
      }
    } catch (e) {
      print("Error adding to wishlist: $e");
    }
  }

  // Lấy danh sách wishlist của người dùng
  static Future<List<WishlistItem>> getWishlist(String userId) async {
    try {
      var result = await wishlistsCollection.find({'userId': userId}).toList();
      return result.map((item) => WishlistItem.fromMap(item)).toList();
    } catch (e) {
      print("Error getting wishlist: $e");
      return [];
    }
  }

  // Xóa món ăn khỏi wishlist
  static Future<void> removeFromWishlist(String userId, String foodId) async {
    try {
      // Tìm và xóa món ăn khỏi wishlist của người dùng dựa trên userId và foodId
      var result = await wishlistsCollection.deleteOne({
        'userId': userId,
        'foodId': foodId,
      });

      if (result.isAcknowledged) {
        print("Item removed from wishlist");
      } else {
        print("Item not found in wishlist");
      }
    } catch (e) {
      print("Error removing from wishlist: $e");
    }
  }

  static DbCollection get reviewsCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _reviewsCollection ??= _db!.collection(
        COLLECTION_REVIEW); // Make sure you define COLLECTION_REVIEW in your constants
    return _reviewsCollection!;
  }

  // Lưu đánh giá vào MongoDB
  static Future<void> saveReview(Review review) async {
    try {
      await reviewsCollection.insertOne(review.toMap());
      print("Review saved successfully.");
    } catch (e) {
      print("Error saving review: $e");
    }
  }
}
