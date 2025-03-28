import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_del/Pages/LoginPage.dart'; // Trang đăng nhập
import 'package:food_del/Pages/OrderHistoryPage.dart'; // Trang lịch sử đơn hàng
import 'package:food_del/Pages/AccountPage.dart'; // Trang tài khoản
import 'package:food_del/Pages/WishlistPage.dart'; // Trang danh sách yêu thích

class DrawerWidget extends StatelessWidget {
  // Hàm đăng xuất
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .clear(); // Xóa tất cả dữ liệu người dùng trong SharedPreferences

    // Quay lại trang đăng nhập sau khi đăng xuất
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Lấy thông tin người dùng từ SharedPreferences
  Future<Map<String, String?>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('userName');
    String? userEmail = prefs.getString('userEmail');
    return {
      'userName': userName ?? 'Người dùng', // Giá trị mặc định là "Người dùng"
      'userEmail': userEmail ??
          'user@example.com', // Giá trị mặc định là "user@example.com"
    };
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, String?>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi tải thông tin người dùng'));
          }

          final userName = snapshot.data?['userName'] ?? 'Người dùng';
          final userEmail = snapshot.data?['userEmail'] ?? 'user@example.com';

          return ListView(
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  accountName: Text(
                    userName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(
                    userEmail,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://cdn.oneesports.vn/cdn-data/sites/4/2022/12/LQM-ThayGiaoBa-choi-LienQuan-1.jpg"),
                  ),
                ),
              ),

              // Các ListTile khác
              ListTile(
                  leading: Icon(CupertinoIcons.home, color: Colors.red),
                  title: Text("Home",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  }),
              ListTile(
                leading: Icon(CupertinoIcons.person, color: Colors.red),
                title: Text("My Account",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AccountPage()));
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.cart, color: Colors.red),
                title: Text("My Orders",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pushNamed(context, '/order_history');
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.heart_fill, color: Colors.red),
                title: Text("My WishList",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WishlistPage()));
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.settings, color: Colors.red),
                title: Text("Settings",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.red),
                title: Text("Log Out",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onTap: () {
                  logout(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
