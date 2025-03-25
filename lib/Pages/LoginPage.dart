import 'package:flutter/material.dart';
import 'package:food_del/Service/AuthService.dart'; // Dịch vụ xác thực
import 'package:food_del/Pages/SignUpPage.dart'; // Trang đăng ký
import 'package:food_del/Pages/HomePage.dart'; // Trang chủ
import 'package:shared_preferences/shared_preferences.dart'; // Thư viện lưu trữ dữ liệu tạm thời

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;

  // Hàm đăng nhập
  void login() async {
    setState(() {
      isLoading = true; // Bật trạng thái tải
    });

    var user = await AuthService.login(email: email, password: password);

    setState(() {
      isLoading = false; // Tắt trạng thái tải khi xong
    });

    if (user != null) {
      // Lưu thông tin người dùng vào SharedPreferences
      saveUserDetails(user.userId, user.userName, user.email);

      // Chuyển đến trang chủ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } else {
      // Hiển thị thông báo lỗi nếu đăng nhập thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sai email hoặc mật khẩu')),
      );
    }
  }

  // Lưu thông tin người dùng vào SharedPreferences
  Future<void> saveUserDetails(
      String userId, String userName, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('userName', userName);
    await prefs.setString('userEmail', email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFF3131), // Màu đỏ cam
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    'Đăng nhập vào tài khoản của bạn',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(height: 30),
                Image.asset('images/TastyGo.png', height: 150),

                SizedBox(height: 30),

                // Form đăng nhập
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onChanged: (value) => email = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Mật khẩu',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            obscureText: true,
                            onChanged: (value) => password = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      login();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 32),
                                    backgroundColor: Color(0xFFFF3131),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  child: Text('Đăng nhập',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                              );
                            },
                            child: Text('Chưa có tài khoản? Đăng ký ngay',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Thêm Text và Padding bên dưới form đăng nhập
                SizedBox(height: 20), // Khoảng cách giữa form và Text
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 100), // Thêm khoảng cách dưới cùng
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
