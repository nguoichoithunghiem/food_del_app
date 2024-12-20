import 'package:flutter/material.dart';
import 'package:food_del/DB/MongoDB.dart';
import 'package:food_del/Pages/AccountPage.dart';
import 'package:food_del/Pages/HomePage.dart';
import 'package:food_del/Pages/CartPage.dart';
import 'package:food_del/Pages/ItemPage.dart';
import 'package:food_del/Pages/LoginPage.dart';
import 'package:food_del/Pages/OrderConfirmationPage.dart';
import 'package:food_del/Pages/OrderHistoryPage.dart';
import 'package:food_del/Pages/OrderPage.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:food_del/Service/cart_service.dart'; // Import CartService
import 'package:food_del/Service/OrderService.dart'; // Import OrderService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartService>(
            create: (context) => CartService()), // Cung cấp CartService
        ProxyProvider<CartService, OrderService>(
          create: (context) => OrderService(
              cartService:
                  context.read<CartService>()), // Cung cấp OrderService
          update: (context, cartService, orderService) => orderService!,
        ),
      ],
      child: MyApp(),
    ),
  );
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
        '/cart': (context) => CartPage(), // Trang giỏ hàng
        'itemPage': (context) => ItemPage(), // Trang chi tiết món ăn
        '/order_confirmation': (context) => OrderConfirmationPage(),
        '/order_page': (context) => OrderPage(),
        '/order_history': (context) => OrderHistoryPage(),
        '/account': (context) => AccountPage(), // Trang lịch sử đơn hàng
      },
    );
  }
}
