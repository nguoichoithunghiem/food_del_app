import 'package:mongo_dart/mongo_dart.dart';
import 'package:food_del/DB/Constant.dart'; // Assumes you have constants defined like MONGO_URL, COLLECTION_USER, COLLECTION_FOOD

class MongoDatabase {
  static Db? _db;
  static DbCollection? _usersCollection;
  static DbCollection? _foodsCollection;
  static DbCollection? _categoriesCollection;

  // Kết nối MongoDB
  static Future<Db> connect() async {
    if (_db == null) {
      _db = await Db.create(MONGO_URL); // Tạo kết nối mới với MONGO_URL
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
    _usersCollection ??= _db!.collection(
        COLLECTION_USER); // Nếu chưa khởi tạo, khởi tạo usersCollection
    return _usersCollection!;
  }

  // Getter cho foodsCollection
  static DbCollection get foodsCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _foodsCollection ??= _db!.collection(
        COLLECTION_FOOD); // Nếu chưa khởi tạo, khởi tạo foodsCollection
    return _foodsCollection!;
  }

  // Getter cho categoriesCollection
  static DbCollection get categoriesCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _categoriesCollection ??= _db!.collection(
        COLLECTION_CATEGORY); // Nếu chưa khởi tạo, khởi tạo categoriesCollection
    return _categoriesCollection!;
  }
}
