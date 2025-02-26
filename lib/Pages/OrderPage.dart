import 'package:flutter/material.dart';
import 'package:food_del/Service/cart_service.dart';
import 'package:food_del/Models/orderModel.dart';
import 'package:food_del/Service/OrderService.dart';
import 'package:food_del/Service/AuthService.dart';
import 'package:food_del/Models/userModel.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController userPhoneController = TextEditingController();
  final TextEditingController userAddressController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController couponController = TextEditingController();
  double totalPrice = 0.0; // Tổng tiền sau khi giảm giá
  double discountAmount = 0.0; // Số tiền giảm
  bool isCouponApplied =
      false; // Cờ kiểm tra xem mã giảm giá đã được áp dụng chưa

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final orderService = OrderService(cartService: cartService);

    // Lấy thông tin người dùng hiện tại từ AuthService
    final User? user = AuthService.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text("Thông tin người dùng không có!")),
      );
    }

    // Tính tổng tiền gốc
    double originalTotal = cartService.getTotal();

    // Hàm tính tổng tiền sau khi áp dụng giảm giá
    double calculateTotalAfterDiscount(double originalTotal, double discount) {
      if (discount < 1) {
        // Giảm giá theo tỷ lệ phần trăm
        return originalTotal * (1 - discount);
      } else {
        // Giảm giá theo số tiền cố định
        return originalTotal - discount;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Xác nhận đơn hàng'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Form thông tin người dùng
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                      userPhoneController, 'Số điện thoại', Icons.phone),
                  _buildTextField(
                      userAddressController, 'Địa chỉ', Icons.location_on),
                  _buildTextField(
                      noteController, 'Ghi chú (Tùy chọn)', Icons.note_add),
                  _buildTextField(
                      couponController, 'Mã giảm giá', Icons.local_offer),
                  SizedBox(height: 16),
                  if (!isCouponApplied)
                    ElevatedButton(
                      onPressed: () async {
                        String couponCode = couponController.text;
                        double discount =
                            await orderService.applyCoupon(couponCode);

                        if (discount > 0) {
                          setState(() {
                            discountAmount = discount;
                            totalPrice = calculateTotalAfterDiscount(
                                cartService.getTotal(), discount);
                            isCouponApplied = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Mã giảm giá đã được áp dụng!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Mã giảm giá không hợp lệ!')),
                          );
                        }
                      },
                      child: Text("Áp dụng mã giảm giá"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Màu nền nút
                        foregroundColor: Colors.white, // Màu chữ nút
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Danh sách món trong giỏ hàng
            Text('Món trong giỏ hàng của bạn:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: cartService.items.map((cartItem) {
                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    title:
                        Text(cartItem.foodName, style: TextStyle(fontSize: 16)),
                    subtitle: Text(
                        "Số lượng: ${cartItem.quantity} x ${cartItem.price} VNĐ"),
                    trailing: Text("${cartItem.price * cartItem.quantity} VNĐ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // Thông tin tổng tiền và chi tiết giảm giá
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tổng tiền gốc: ${cartService.getTotal()} VNĐ",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  if (isCouponApplied)
                    Text(
                        "Giảm giá: -${(discountAmount * cartService.getTotal()).toStringAsFixed(0)} VNĐ",
                        style: TextStyle(fontSize: 18, color: Colors.green)),
                  if (isCouponApplied)
                    Text(
                      "Tổng sau giảm giá: $totalPrice VNĐ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            // Nút đặt hàng
            ElevatedButton(
              onPressed: () async {
                if (cartService.items.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Giỏ hàng của bạn trống!')),
                  );
                  return;
                }

                // Lấy thông tin người dùng
                String userPhone = userPhoneController.text;
                String userAddress = userAddressController.text;
                String note = noteController.text;

                // Tạo đơn hàng
                Order order = orderService.createOrder(
                  user: user,
                  userPhone: userPhone,
                  userAddress: userAddress,
                  note: note,
                );

                // Cập nhật giá tổng sau giảm giá
                order.totalPrice = isCouponApplied ? totalPrice : originalTotal;

                // Lưu đơn hàng vào cơ sở dữ liệu
                await orderService.saveOrder(order);

                // Hiển thị thông báo thành công
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đơn hàng của bạn đã được đặt!')),
                );

                // Chuyển hướng đến trang xác nhận đơn hàng
                Navigator.pushNamed(context, '/order_confirmation',
                    arguments: order);
              },
              child: Text("Đặt hàng"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Màu nền nút
                foregroundColor: Colors.white, // Màu chữ nút
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Phương thức phụ để xây dựng các trường nhập liệu
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
