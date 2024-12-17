import 'package:flutter/material.dart';
import 'package:food_del/Models/orderModel.dart';

class OrderConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy thông tin đơn hàng từ route arguments
    final order = ModalRoute.of(context)?.settings.arguments as Order;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
        actions: [
          // Nút quay lại trang chủ
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị thông tin đơn hàng
            Text('Order ID: ${order.orderId}', style: TextStyle(fontSize: 18)),
            Text('Name: ${order.userName}', style: TextStyle(fontSize: 16)),
            Text('Phone: ${order.userPhone}', style: TextStyle(fontSize: 16)),
            Text('Address: ${order.userAddress}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),

            // Hiển thị các món ăn trong đơn hàng
            Text('Items:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  var cartItem = order.items[index];
                  return ListTile(
                    title: Text(cartItem.foodName),
                    subtitle: Text(
                        "Quantity: ${cartItem.quantity} x ${cartItem.price} VNĐ"),
                    trailing: Text(
                      "${cartItem.price * cartItem.quantity} VNĐ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            // Hiển thị tổng tiền
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Total: ${order.totalPrice} VNĐ",
                  style: TextStyle(fontSize: 18)),
            ),

            // Hiển thị thông tin ghi chú và trạng thái
            Text('Note: ${order.note}', style: TextStyle(fontSize: 16)),
            Text('Status: ${order.status}', style: TextStyle(fontSize: 16)),

            // Nút quay lại
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/'); // Quay lại trang chủ
                },
                child: Text('Go to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
