import 'package:flutter/material.dart';
import 'package:food_del/Service/AuthService.dart';
import 'package:food_del/Models/userModel.dart';
import 'package:food_del/Pages/UpdateAccountPage.dart'; // Import trang cập nhật thông tin

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    // Lấy thông tin người dùng hiện tại sau khi trang được xây dựng
    _fetchUserInfo();
  }

  // Lấy thông tin người dùng từ AuthService
  Future<void> _fetchUserInfo() async {
    final userId = AuthService.currentUser?.userId;

    if (userId != null) {
      // Lấy thông tin người dùng theo userId
      User? user = await AuthService.getUserInfo(userId);
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Information'),
        backgroundColor: Colors.red,
      ),
      body: _user == null
          ? Center(
              child:
                  CircularProgressIndicator()) // Hiển thị khi đang tải dữ liệu
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard("User ID", _user!.userId),
                    _buildInfoCard("Email", _user!.email),
                    _buildInfoCard("Username", _user!.userName),
                    _buildInfoCard("Phone", _user!.phone),
                    _buildInfoCard("Address", _user!.address),
                    _buildInfoCard("Role", _user!.role),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Khi người dùng nhấn vào "Update", chuyển hướng đến trang cập nhật
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UpdateAccountPage(user: _user!),
                          ),
                        );
                      },
                      child: Text("Cập nhật thông tin"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
