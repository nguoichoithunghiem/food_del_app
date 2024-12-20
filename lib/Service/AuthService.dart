import 'package:food_del/DB/MongoDB.dart';
import 'package:food_del/Models/userModel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:crypto/crypto.dart'; // Dùng để mã hóa mật khẩu
import 'dart:convert'; // Dùng để chuyển đổi mật khẩu thành byte

class AuthService {
  static User? _currentUser; // Trường tĩnh lưu trữ người dùng hiện tại

  // Getter để truy cập thông tin người dùng hiện tại
  static User? get currentUser => _currentUser;

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
        userId: '', // userId sẽ được gán khi MongoDB tạo bản ghi mới
      );

      // Thêm người dùng mới vào cơ sở dữ liệu MongoDB
      final result =
          await MongoDatabase.usersCollection!.insertOne(newUser.toMap());

      if (result.isSuccess) {
        newUser.userId =
            result.document!['_id'].toString(); // Lấy _id MongoDB làm userId
        return true;
      }
      return false;
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
        // Chuyển đổi từ Map sang đối tượng User và thêm userId
        User user = User.fromMap(userMap);

        // Chuyển _id từ MongoDB thành chuỗi ID mà không có ObjectId(...)
        user.userId =
            userMap['_id'].toHexString(); // Sử dụng toHexString để lấy chuỗi ID

        // Kiểm tra xem userId có hợp lệ không (không phải là null hoặc rỗng)
        if (user.userId.isNotEmpty) {
          // Lưu thông tin người dùng vào _currentUser khi đăng nhập thành công
          _currentUser = user;

          // In ra log ID của người dùng khi đăng nhập thành công
          print("Login successful! User ID: ${user.userId}");

          return user; // Trả về đối tượng User nếu đăng nhập thành công
        } else {
          print("User ID is not valid.");
          return null; // Nếu userId không hợp lệ, trả về null
        }
      } else {
        print("Invalid email or password.");
        return null; // Nếu không tìm thấy người dùng hoặc sai mật khẩu
      }
    } catch (e) {
      print("Error during login: $e");
      return null; // Xử lý lỗi trong quá trình đăng nhập
    }
  }

  // Đăng xuất người dùng
  static void logout() {
    _currentUser = null; // Đặt lại _currentUser khi người dùng đăng xuất
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

  // Lấy thông tin người dùng theo userId
  static Future<User?> getUserInfo(String userId) async {
    try {
      // Tìm người dùng theo userId trong cơ sở dữ liệu
      final userMap = await MongoDatabase.usersCollection!
          .findOne(where.eq('_id', ObjectId.fromHexString(userId)));

      if (userMap != null) {
        // Chuyển đổi từ Map sang đối tượng User
        User user = User.fromMap(userMap);

        // Chuyển _id từ MongoDB thành chuỗi ID
        user.userId = userMap['_id'].toHexString();

        return user; // Trả về đối tượng User
      } else {
        print("User not found.");
        return null; // Nếu không tìm thấy người dùng, trả về null
      }
    } catch (e) {
      print("Error fetching user info: $e");
      return null; // Xử lý lỗi nếu có
    }
  }

  static Future<bool> updateUserInfo(
      String userId, String userName, String phone, String address) async {
    try {
      // Cập nhật thông tin trong cơ sở dữ liệu (ví dụ MongoDB)
      var result = await MongoDatabase.usersCollection!.updateOne(
        where.eq('_id', ObjectId.fromHexString(userId)),
        modify
            .set('userName', userName)
            .set('phone', phone)
            .set('address', address),
      );

      return result.isAcknowledged;
    } catch (e) {
      print("Error during update user info: $e");
      return false;
    }
  }
}
