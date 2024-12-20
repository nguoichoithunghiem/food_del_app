import 'package:flutter/material.dart';
import 'package:food_del/Service/AuthService.dart';
import 'package:food_del/Pages/SignUpPage.dart';
import 'package:food_del/Pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false; // Biến để kiểm tra trạng thái tải

  // Hàm đăng nhập
  void login() async {
    setState(() {
      isLoading = true; // Bật trạng thái tải khi đăng nhập
    });

    var user = await AuthService.login(email: email, password: password);

    setState(() {
      isLoading = false; // Tắt trạng thái tải khi xong
    });

    if (user != null) {
      // Lưu thông tin người dùng vào SharedPreferences khi đăng nhập thành công
      saveUserDetails(user.email!, user.role);

      // Nếu đăng nhập thành công, chuyển đến trang chủ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } else {
      // Nếu đăng nhập thất bại, hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sai email hoặc mật khẩu')),
      );
    }
  }

  // Lưu thông tin người dùng vào SharedPreferences
  Future<void> saveUserDetails(String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'userEmail', email); // Lưu email vào SharedPreferences
    await prefs.setString('userRole', role); // Lưu role vào SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Đổi nền thành màu đỏ cam
        decoration: BoxDecoration(
          color: Color(0xFFFF5722), // Màu đỏ cam (HEX: #FF5722)
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20), // Thêm padding cho SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tiêu đề trang đăng nhập với padding top 100
                Padding(
                  padding: const EdgeInsets.only(
                      top: 80), // Thêm padding top cho tiêu đề
                  child: Text(
                    'Đăng nhập vào tài khoản của bạn',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
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
                          // Nhập email
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
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

                          // Nhập mật khẩu
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Mật khẩu',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
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

                          // Button đăng nhập
                          isLoading
                              ? CircularProgressIndicator() // Hiển thị loading khi đang đăng nhập
                              : ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      login();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 32),
                                    backgroundColor:
                                        Color(0xFFFF5722), // Màu sắc của nút
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    'Đăng nhập',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                          SizedBox(height: 10),

                          // Link đăng ký
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                              );
                            },
                            child: Text(
                              'Chưa có tài khoản? Đăng ký ngay',
                              style: TextStyle(
                                color: Color(0xFFFF5722), // Màu của TextButton
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: 20), // Khoảng cách giữa form và văn bản bên dưới

                // Thêm Text dưới cùng
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
                      bottom: 100), // Thêm padding bottom cho chữ OK
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
