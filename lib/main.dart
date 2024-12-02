import 'package:flutter/material.dart';
import 'package:food_del/DB/MongoDB.dart';
import 'package:food_del/Pages/HomePage.dart';
import 'package:food_del/Pages/CartPage.dart';
import 'package:food_del/Pages/ItemPage.dart';
import 'package:food_del/Pages/LoginPage.dart'; // Import LoginPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Food App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFFF5F5F3)),
      initialRoute: '/login', // Đặt trang login là màn hình đầu tiên khi mở app
      routes: {
        '/': (context) => Homepage(), // Trang chủ
        '/login': (context) => LoginPage(), // Màn hình đăng nhập
        'cartPage': (context) => Cartpage(), // Trang giỏ hàng
        'itemPage': (context) => ItemPage(), // Trang chi tiết món ăn
      },
    );
  }
}
