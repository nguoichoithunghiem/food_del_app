import 'package:food_del/DB/Constant.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:food_del/Models/orderModel.dart';
import 'package:food_del/Models/cart_item.dart'; // Đảm bảo import model CartItem

class MongoDatabase {
  static Db? _db;
  static DbCollection? _usersCollection;
  static DbCollection? _foodsCollection;
  static DbCollection? _categoriesCollection;
  static DbCollection? _ordersCollection;
  static DbCollection? _orderDetailsCollection;

  // Kết nối MongoDB
  static Future<Db> connect() async {
    if (_db == null) {
      _db = await Db.create(MONGO_URL);
      await _db!.open();
      print("DB connected");
    }
    return _db!;
  }

  // Getter cho usersCollection
  static DbCollection get usersCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _usersCollection ??= _db!.collection(COLLECTION_USER);
    return _usersCollection!;
  }

  // Getter cho foodsCollection
  static DbCollection get foodsCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _foodsCollection ??= _db!.collection(COLLECTION_FOOD);
    return _foodsCollection!;
  }

  // Getter cho categoriesCollection
  static DbCollection get categoriesCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _categoriesCollection ??= _db!.collection(COLLECTION_CATEGORY);
    return _categoriesCollection!;
  }

  // Getter cho ordersCollection
  static DbCollection get ordersCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _ordersCollection ??= _db!.collection(COLLECTION_ORDER);
    return _ordersCollection!;
  }

  // Getter cho orderDetailsCollection
  static DbCollection get orderDetailsCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _orderDetailsCollection ??= _db!.collection(COLLECTION_ORDERDETAIL);
    return _orderDetailsCollection!;
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
}
