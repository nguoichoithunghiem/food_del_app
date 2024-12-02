class User {
  String? email;
  String? userName;
  String? phone;
  String? address;
  String? password;

  User({this.email, this.userName, this.phone, this.address, this.password});

  // Chuyển đổi từ Map sang đối tượng User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      userName: map['userName'],
      phone: map['phone'],
      address: map['address'],
      password: map['password'],
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
    };
  }
}
