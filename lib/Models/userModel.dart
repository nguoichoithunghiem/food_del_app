class User {
  String userId; // userId không cần phải là nullable nữa, vì nó phải có giá trị
  String email;
  String userName;
  String phone;
  String address;
  String password;
  String role; // Vai trò của người dùng

  // Constructor khởi tạo đầy đủ cho các thuộc tính
  User({
    required this.userId, // userId bắt buộc phải có
    required this.email,
    required this.userName,
    required this.phone,
    required this.address,
    required this.password,
    this.role = 'user', // Mặc định là 'user'
  });

  // Factory constructor để chuyển đổi từ Map sang đối tượng User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['_id'].toString(), // Gán _id MongoDB vào userId
      email: map['email'],
      userName: map['userName'],
      phone: map['phone'],
      address: map['address'],
      password: map['password'],
      role: map['role'] ?? 'user', // Nếu không có role thì mặc định là 'user'
    );
  }

  // Phương thức chuyển đổi từ đối tượng User sang Map (để lưu vào cơ sở dữ liệu)
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
