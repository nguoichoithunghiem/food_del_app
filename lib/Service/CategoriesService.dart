import 'package:mongo_dart/mongo_dart.dart';
import 'package:food_del/DB/Constant.dart'; // Import constant chứa MongoDB URL và collection
import 'dart:async';

class CategoriesService {
  // Kết nối với MongoDB
  static Future<Db> _connect() async {
    Db db = await Db.create(MONGO_URL); // Kết nối đến MongoDB
    await db.open();
    return db;
  }

  // Lấy danh sách category từ MongoDB
  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      // Kết nối với cơ sở dữ liệu MongoDB
      Db db = await _connect();

      // Lấy collection "categories" từ MongoDB
      DbCollection categoriesCollection = db.collection(COLLECTION_CATEGORY);

      // Lấy tất cả các category từ collection "categories"
      var categories = await categoriesCollection.find().toList();

      await db.close(); // Đóng kết nối với MongoDB

      return categories; // Trả về danh sách category
    } catch (e) {
      throw Exception("Failed to load categories: $e");
    }
  }
}
