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
            SnackBar(content: Text("Cập nhật thông tin thành công")));
        Navigator.pop(context); // Quay lại trang AccountPage
      } else {
        // Nếu có lỗi trong quá trình cập nhật
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Cập nhật thông tin thất bại")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật thông tin',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tên người dùng
              _buildTextField(
                controller: _userNameController,
                label: "Tên người dùng",
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên người dùng';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Số điện thoại
              _buildTextField(
                controller: _phoneController,
                label: "Số điện thoại",
                icon: Icons.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Địa chỉ
              _buildTextField(
                controller: _addressController,
                label: "Địa chỉ",
                icon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Nút Cập nhật thông tin
              ElevatedButton(
                onPressed: _updateUserInfo,
                child: Text("Cập nhật thông tin"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor:
                      Colors.white, // Thêm dòng này để đặt màu chữ là trắng
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget tùy chỉnh cho các trường nhập liệu
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red), // Icon phía trước
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red), // Viền trường nhập liệu
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      validator: validator,
    );
  }
}
