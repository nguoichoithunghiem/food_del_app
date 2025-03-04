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
        title:
            Text('Thông tin tài khoản', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.red,
        elevation: 10,
        centerTitle: true,
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
                    _buildHeader(), // Thêm ảnh đại diện người dùng hoặc icon
                    SizedBox(height: 20),
                    _buildInfoCard("Mã người dùng", _user!.userId),
                    _buildInfoCard("Email", _user!.email),
                    _buildInfoCard("Tên người dùng", _user!.userName),
                    _buildInfoCard("Số điện thoại", _user!.phone),
                    _buildInfoCard("Địa chỉ", _user!.address),
                    _buildInfoCard("Vai trò", _user!.role),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Khi người dùng nhấn vào "Cập nhật", chuyển hướng đến trang cập nhật
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UpdateAccountPage(user: _user!),
                          ),
                        );
                      },
                      child: Text(
                        "Cập nhật thông tin",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Đảm bảo chữ có màu đen
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Header with avatar and user name
  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("images/avatar.jpg"),
          ),
          SizedBox(height: 10),
          Text(
            _user?.userName ?? "Tên người dùng",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // Thẻ thông tin người dùng
  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.black),
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
