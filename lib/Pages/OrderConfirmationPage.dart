import 'package:flutter/material.dart';
import 'package:food_del/Models/orderModel.dart';
import 'package:intl/intl.dart'; // Import the intl package for currency formatting

class OrderConfirmationPage extends StatelessWidget {
  // Helper function to format the price in Vietnamese currency
  String formatCurrency(double price) {
    return NumberFormat.simpleCurrency(locale: 'vi_VN').format(price);
  }

  @override
  Widget build(BuildContext context) {
    // Get order details from route arguments
    final order = ModalRoute.of(context)?.settings.arguments as Order;

    return Scaffold(
      appBar: AppBar(
        title: Text('Xác nhận đơn hàng'),
        backgroundColor: Colors.red,
        actions: [
          // Back to home button
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
              // Card for order information
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

              // Displaying items in the order
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
                            "Số lượng: ${cartItem.quantity} x ${formatCurrency(cartItem.price)}"),
                        trailing: Text(
                          "${formatCurrency(cartItem.price * cartItem.quantity)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Displaying total price
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tổng tiền:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("${formatCurrency(order.totalPrice)}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ],
                ),
              ),

              // Displaying note and status
              SizedBox(height: 16),
              Text('Ghi chú: ${order.note}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Trạng thái: Đang xử lý',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: order.status == 'Delivered'
                          ? Colors.green
                          : Colors.red)),

              // Button to go back to home
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/'); // Go back to home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for background
                    foregroundColor: Colors.white, // White color for text
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
