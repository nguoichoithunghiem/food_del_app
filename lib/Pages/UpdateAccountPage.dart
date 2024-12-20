import 'package:flutter/material.dart';
import 'package:food_del/Service/AuthService.dart';
import 'package:food_del/Models/userModel.dart';

class UpdateAccountPage extends StatefulWidget {
  final User user; // Nhận đối tượng User từ trang trước

  UpdateAccountPage({required this.user});

  @override
  _UpdateAccountPageState createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller và gán giá trị ban đầu từ đối tượng user
    _userNameController = TextEditingController(text: widget.user.userName);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
  }

  @override
  void dispose() {
    // Hủy controller khi không còn sử dụng
    _userNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Hàm cập nhật thông tin người dùng
  Future<void> _updateUserInfo() async {
    if (_formKey.currentState!.validate()) {
      // Lấy thông tin đã chỉnh sửa
      String userName = _userNameController.text;
      String phone = _phoneController.text;
      String address = _addressController.text;

      // Gửi thông tin cập nhật lên backend (hoặc cơ sở dữ liệu)
      bool isUpdated = await AuthService.updateUserInfo(
        widget.user.userId,
        userName,
        phone,
        address,
      );

      if (isUpdated) {
        // Nếu cập nhật thành công, thông báo và trở về trang AccountPage
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Information updated successfully")));
        Navigator.pop(context); // Quay lại trang AccountPage
      } else {
        // Nếu có lỗi trong quá trình cập nhật
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to update information")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Information'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: "Username"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Address"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserInfo,
                child: Text("Cập nhật thông tin"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
