import 'package:food_del/DB/MongoDB.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:crypto/crypto.dart'; // Dùng để mã hóa mật khẩu
import 'dart:convert'; // Dùng để chuyển đổi mật khẩu thành byte

class AuthService {
  // Đăng ký người dùng mới
  static Future<bool> signUp({
    required String userName,
    required String email,
    required String phone,
    required String address,
    required String password,
    String role = 'user', // Vai trò mặc định là 'user'
  }) async {
    try {
      // Kiểm tra xem email đã tồn tại trong cơ sở dữ liệu chưa
      final userExists = await MongoDatabase.usersCollection!
          .findOne(where.eq('email', email));
      if (userExists != null) {
        print("Email already exists");
        return false; // Nếu email đã tồn tại
      }

      // Kiểm tra role hợp lệ (chỉ cho phép 'user' hoặc 'admin')
      if (role != 'user' && role != 'admin') {
        print("Invalid role. Must be 'user' or 'admin'");
        return false; // Nếu role không hợp lệ
      }

      // Mã hóa mật khẩu trước khi lưu vào cơ sở dữ liệu
      String hashedPassword = _hashPassword(password);

      // Tạo đối tượng User từ các thông tin đầu vào
      User newUser = User(
        email: email,
        userName: userName,
        phone: phone,
        address: address,
        password: hashedPassword, // Lưu mật khẩu đã mã hóa
        role: role, // Thiết lập role cho người dùng
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
      if (userMap != null && _checkPassword(password, userMap['password'])) {
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

  // Mã hóa mật khẩu bằng SHA-256
  static String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Chuyển mật khẩu thành byte
    var digest = sha256.convert(bytes); // Mã hóa bằng SHA-256
    return digest.toString(); // Trả về mật khẩu đã mã hóa
  }

  // Kiểm tra mật khẩu khi đăng nhập
  static bool _checkPassword(String enteredPassword, String storedPassword) {
    return _hashPassword(enteredPassword) == storedPassword;
  }
}

class User {
  String? email;
  String? userName;
  String? phone;
  String? address;
  String? password;
  String role; // Vai trò của người dùng

  // Khởi tạo với giá trị mặc định cho role là 'user'
  User({
    this.email,
    this.userName,
    this.phone,
    this.address,
    this.password,
    this.role = 'user', // Mặc định là 'user'
  });

  // Chuyển đổi từ Map sang đối tượng User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      userName: map['userName'],
      phone: map['phone'],
      address: map['address'],
      password: map['password'],
      role: map['role'] ??
          'user', // Nếu không có role trong map thì mặc định là 'user'
    );
  }

  // Chuyển đổi từ đối tượng User sang Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'userName': userName,
      'phone': phone,
      'address': address,
      'password': password,
      'role': role, // Lưu role vào Map
    };
  }
}
