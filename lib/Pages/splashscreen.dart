import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Khởi tạo AnimationController và Animation
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Bắt đầu animation
    _controller.forward();

    // Sau khi animation hoàn thành, chuyển sang trang đăng nhập
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Màu nền của splash screen
      body: Center(
        child: FadeTransition(
          opacity: _animation, // Điều khiển sự mờ dần của logo qua animation
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo của ứng dụng
              Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQb0ZJ4dX0fFgUUYrn4veEkBTzRpmbFKP0Ptg&s",
                  height: 150), // Đặt logo của bạn tại assets/logo.png
              SizedBox(height: 20),
              Text(
                'Food Delivery App', // Tên ứng dụng
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
