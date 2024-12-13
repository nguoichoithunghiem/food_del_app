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
      appBar: AppBar(title: Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mật khẩu'),
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
                  ? CircularProgressIndicator() // Hiển thị loading khi đang đăng nhập
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      child: Text('Đăng nhập'),
                    ),
              TextButton(
                onPressed: () {
                  // Chuyển đến màn hình đăng ký
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text('Chưa có tài khoản? Đăng ký ngay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
