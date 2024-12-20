import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_del/Pages/LoginPage.dart'; // Import LoginPage
import 'package:food_del/Pages/OrderHistoryPage.dart'; // Import OrderHistoryPage
import 'package:food_del/Pages/AccountPage.dart'; // Import AccountPage

class DrawerWidget extends StatelessWidget {
  // Hàm đăng xuất
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa tất cả dữ liệu trong SharedPreferences

    // Sau khi đăng xuất, chuyển hướng về màn hình đăng nhập
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              accountName: Text(
                "Programer",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                "dearprogrammer@etc.com",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("images/avatar.jpg"),
              ),
            ),
          ),
          // Các ListTile khác
          ListTile(
            leading: Icon(
              CupertinoIcons.home,
              color: Colors.red,
            ),
            title: Text(
              "Home",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.person,
              color: Colors.red,
            ),
            title: Text(
              "My Account",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // Điều hướng tới trang AccountPage khi bấm vào "My Account"
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AccountPage()), // Thay thế bằng AccountPage
              );
            },
          ),
          // Cập nhật ListTile cho "My Orders"
          ListTile(
            leading: Icon(
              CupertinoIcons.cart,
              color: Colors.red,
            ),
            title: Text(
              "My Orders",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // Điều hướng tới trang OrderHistoryPage khi bấm vào "My Orders"
              Navigator.pushNamed(context, '/order_history');
            },
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.heart_fill,
              color: Colors.red,
            ),
            title: Text(
              "My WishList",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.settings,
              color: Colors.red,
            ),
            title: Text(
              "Settings",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Thêm ListTile cho đăng xuất
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text(
              "Log Out",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              logout(context); // Gọi hàm đăng xuất khi nhấn vào "Log Out"
            },
          ),
        ],
      ),
    );
  }
}
