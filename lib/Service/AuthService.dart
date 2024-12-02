import 'package:food_del/DB/MongoDB.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:food_del/Models/UserModel.dart'; // Import User model

class AuthService {
  // Đăng ký người dùng mới
  static Future<bool> signUp({
    required String userName,
    required String email,
    required String phone,
    required String address,
    required String password,
  }) async {
    try {
      // Kiểm tra xem email đã tồn tại trong cơ sở dữ liệu chưa
      final userExists = await MongoDatabase.usersCollection!
          .findOne(where.eq('email', email));
      if (userExists != null) {
        print("Email already exists");
        return false; // Nếu email đã tồn tại
      }

      // Tạo đối tượng User từ các thông tin đầu vào
      User newUser = User(
        email: email,
        userName: userName,
        phone: phone,
        address: address,
        password: password,
      );

      // Thêm người dùng mới vào cơ sở dữ liệu MongoDB
      final result =
          await MongoDatabase.usersCollection!.insertOne(newUser.toMap());

      return result.isSuccess;
    } catch (e) {
      print("Error during sign up: $e");
      return false;
    }
  }

  // Đăng nhập người dùng
  static Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      // Tìm người dùng theo email trong cơ sở dữ liệu
      final userMap = await MongoDatabase.usersCollection!
          .findOne(where.eq('email', email));
      if (userMap != null && userMap['password'] == password) {
        // Chuyển đổi từ Map sang đối tượng User
        return User.fromMap(userMap);
      } else {
        return null; // Nếu không tìm thấy người dùng hoặc sai mật khẩu
      }
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }
}
