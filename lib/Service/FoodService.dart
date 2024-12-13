import 'package:mongo_dart/mongo_dart.dart';
import 'package:food_del/DB/Constant.dart'; // Import constant chứa MongoDB URL và collection
import 'dart:async';

class FoodService {
  // Kết nối với MongoDB
  static Future<Db> _connect() async {
    try {
      Db db = await Db.create(
          MONGO_URL); // Kết nối với MongoDB bằng URL đã được cấu hình
      await db.open();
      return db;
    } catch (e) {
      throw Exception("Failed to connect to database: $e");
    }
  }

  // Lấy tất cả món ăn từ MongoDB
  static Future<List<Map<String, dynamic>>> getFoods() async {
    try {
      Db db = await _connect();
      DbCollection foodsCollection = db.collection(COLLECTION_FOOD);

      // Lấy tất cả món ăn từ collection "foods"
      var foods = await foodsCollection.find().toList();

      await db.close(); // Đóng kết nối với database

      return foods; // Trả về danh sách món ăn
    } catch (e) {
      throw Exception("Failed to load foods: $e");
    }
  }

  // Lấy danh sách món ăn theo tên (Tìm kiếm món ăn theo tên)
  static Future<List<Map<String, dynamic>>> getFoodsByName(String name) async {
    try {
      Db db = await _connect();
      DbCollection foodsCollection = db.collection(COLLECTION_FOOD);

      // Sử dụng where.match để tìm kiếm chuỗi trong foodName
      var foods = await foodsCollection
          .find(
              where.match('foodName', name)) // Sử dụng tên mà không cần RegExp
          .toList();

      await db.close();

      return foods;
    } catch (e) {
      throw Exception("Failed to load foods by name: $e");
    }
  }

  // Lọc món ăn theo danh mục (Tìm kiếm món ăn theo tên danh mục)
  static Future<List<Map<String, dynamic>>> getFoodsByCategory(
      String categoryName) async {
    try {
      Db db = await _connect();
      DbCollection foodsCollection = db.collection(COLLECTION_FOOD);

      // Tìm món ăn có danh mục trùng với tên danh mục đã chọn
      var foods = await foodsCollection
          .find(where.eq(
              'foodCategory', categoryName)) // So sánh chính xác tên danh mục
          .toList();

      await db.close();

      return foods; // Trả về danh sách món ăn theo danh mục
    } catch (e) {
      throw Exception("Failed to load foods by category: $e");
    }
  }

  // Lọc món ăn theo tên và danh mục (Kết hợp cả hai điều kiện)
  static Future<List<Map<String, dynamic>>> getFoodsByNameAndCategory(
      String name, String categoryName) async {
    try {
      Db db = await _connect();
      DbCollection foodsCollection = db.collection(COLLECTION_FOOD);

      // Lọc món ăn theo cả tên và danh mục
      var foods = await foodsCollection
          .find(where
              .eq('foodName', name) // Tìm kiếm món ăn theo tên
              .eq('foodCategory',
                  categoryName)) // Tìm kiếm món ăn theo danh mục
          .toList();

      await db.close();

      return foods; // Trả về danh sách món ăn phù hợp với cả tên và danh mục
    } catch (e) {
      throw Exception("Failed to load foods by name and category: $e");
    }
  }
}
