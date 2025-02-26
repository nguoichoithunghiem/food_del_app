import 'package:flutter/material.dart';
import 'package:food_del/Models/orderModel.dart';

class OrderConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy thông tin đơn hàng từ route arguments
    final order = ModalRoute.of(context)?.settings.arguments as Order;

    return Scaffold(
      appBar: AppBar(
        title: Text('Xác nhận đơn hàng'),
        backgroundColor: Colors.red,
        actions: [
          // Nút quay lại trang chủ
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card cho thông tin đơn hàng
              Card(
                elevation: 4.0,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mã đơn hàng: ${order.orderId}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Tên người nhận: ${order.userName}',
                          style: TextStyle(fontSize: 16)),
                      Text('Số điện thoại: ${order.userPhone}',
                          style: TextStyle(fontSize: 16)),
                      Text('Địa chỉ: ${order.userAddress}',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),

              // Hiển thị các món ăn trong đơn hàng
              Text('Các món ăn trong đơn:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: order.items.map((cartItem) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        title: Text(cartItem.foodName,
                            style: TextStyle(fontSize: 16)),
                        subtitle: Text(
                            "Số lượng: ${cartItem.quantity} x ${cartItem.price} VNĐ"),
                        trailing: Text(
                          "${cartItem.price * cartItem.quantity} VNĐ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Hiển thị tổng tiền
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tổng tiền:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("${order.totalPrice} VNĐ",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ],
                ),
              ),

              // Hiển thị thông tin ghi chú và trạng thái
              SizedBox(height: 16),
              Text('Ghi chú: ${order.note}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Trạng thái: ${order.status}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: order.status == 'Delivered'
                          ? Colors.red
                          : Colors.red)),

              // Nút quay lại
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/'); // Quay lại trang chủ
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Màu cam 0xFFFF5722 cho nền
                    foregroundColor: Colors.white, // Màu trắng cho chữ
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Về trang chủ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
