import 'package:flutter/material.dart';
import 'package:food_del/Models/orderModel.dart';
import 'package:food_del/Models/userModel.dart';
import 'package:food_del/Service/OrderService.dart';
import 'package:provider/provider.dart';
import 'package:food_del/Service/cart_service.dart';
import 'package:food_del/Service/AuthService.dart';

class OrderPage extends StatelessWidget {
  final TextEditingController userPhoneController = TextEditingController();
  final TextEditingController userAddressController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final orderService = OrderService(cartService: cartService);

    // Lấy thông tin người dùng hiện tại từ AuthService (giả sử đã có sau khi đăng nhập)
    final User? user = AuthService.currentUser;

    // Kiểm tra nếu không có thông tin người dùng thì thông báo và thoát
    if (user == null) {
      return Scaffold(
        body: Center(child: Text("User information is missing!")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Confirm Your Order')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Các trường nhập liệu cho người dùng
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: userPhoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                TextField(
                  controller: userAddressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
              ],
            ),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            SizedBox(height: 20),
            // Hiển thị các món ăn trong giỏ
            Text('Items in your cart:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: cartService.items.length,
                itemBuilder: (context, index) {
                  var cartItem = cartService.items[index];
                  return ListTile(
                    title: Text(cartItem.foodName),
                    subtitle: Text(
                        "Quantity: ${cartItem.quantity} x ${cartItem.price} VNĐ"),
                    trailing: Text("${cartItem.price * cartItem.quantity} VNĐ"),
                  );
                },
              ),
            ),
            // Hiển thị tổng tiền
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Total: ${cartService.getTotal()} VNĐ",
                  style: TextStyle(fontSize: 18)),
            ),
            // Nút Đặt hàng
            ElevatedButton(
              onPressed: () {
                // Kiểm tra nếu giỏ hàng trống
                if (cartService.items.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Your cart is empty!')),
                  );
                  return;
                }

                // Lấy thông tin từ controller
                String userPhone = userPhoneController.text;
                String userAddress = userAddressController.text;
                String note = noteController.text;

                // Tạo đơn hàng từ thông tin giỏ hàng và thông tin người dùng
                Order order = orderService.createOrder(
                  user: user, // Truyền đối tượng User đã đăng nhập
                  userPhone: userPhone, // Truyền số điện thoại người dùng
                  userAddress: userAddress, // Truyền địa chỉ
                  note: note, // Truyền ghi chú
                );

                // Lưu đơn hàng vào cơ sở dữ liệu (MongoDB)
                orderService.saveOrder(order);

                // Hiển thị thông báo thành công
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Your order has been placed!')),
                );

                // Chuyển hướng đến trang xác nhận đơn hàng
                Navigator.pushNamed(context, '/order_confirmation',
                    arguments: order);
              },
              child: Text("Place Order"),
            ),
          ],
        ),
      ),
    );
  }
}
