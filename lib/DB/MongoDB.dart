import 'package:mongo_dart/mongo_dart.dart';
import 'package:food_del/DB/Constant.dart'; // Assuming you have some constants defined here, like MONGO_URL

class MongoDatabase {
  static Db? _db;
  static DbCollection?
      _usersCollection; // Define a static variable for usersCollection

  // Kết nối MongoDB
  static Future<Db> connect() async {
    if (_db == null) {
      _db = await Db.create(MONGO_URL);
      await _db!.open();
      print("DB connected");
    }
    return _db!;
  }

  // Getter for usersCollection
  static DbCollection? get usersCollection {
    if (_db == null) {
      throw Exception(
          "Database not connected. Please call MongoDatabase.connect() first.");
    }
    _usersCollection ??=
        _db!.collection(COLLECTION_USER); // Assuming COLLECTION_USER is defined
    return _usersCollection;
  }
}
