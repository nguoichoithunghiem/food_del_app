import 'package:flutter/material.dart';
import 'package:food_del/Service/OrderService.dart';
import 'package:food_del/Models/orderModel.dart';
import 'package:food_del/Service/AuthService.dart';
import 'package:provider/provider.dart';

class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Order History'),
          backgroundColor: Colors.red, // Màu sắc AppBar
        ),
        body: Center(child: Text("User information is missing!")),
      );
    }

    final orderService = Provider.of<OrderService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: Colors.red, // Màu sắc AppBar
      ),
      body: FutureBuilder<List<Order>>(
        future: orderService.getOrderHistory(user.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("There was an error loading orders."));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No orders found."));
          }

          // Lấy danh sách đơn hàng và sắp xếp theo orderId (càng lớn thì đơn hàng càng mới)
          List<Order> orders = snapshot.data!;
          orders.sort((a, b) => b.orderId.compareTo(
              a.orderId)); // Sắp xếp theo orderId, đơn hàng mới nhất lên trên

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(order: order);
            },
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID: ${order.orderId}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
            ),
            SizedBox(height: 8),
            Text("Status: ${order.status}",
                style: TextStyle(fontSize: 14, color: Colors.green)),
            Text("Total Price: ${order.totalPrice} VND",
                style: TextStyle(fontSize: 14, color: Colors.black87)),
            SizedBox(height: 8),
            Text("Delivery Address: ${order.userAddress}",
                style: TextStyle(fontSize: 14, color: Colors.black54)),
            Text("Phone: ${order.userPhone}",
                style: TextStyle(fontSize: 14, color: Colors.black54)),
            SizedBox(height: 8),
            Text("Note: ${order.note}",
                style: TextStyle(fontSize: 14, color: Colors.black54)),
            SizedBox(height: 8),
            Divider(),
            Text("Items:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87)),
            ...order.items.map((item) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.fastfood, color: Colors.red),
                title: Text(item.foodName, style: TextStyle(fontSize: 14)),
                subtitle: Text("Price: ${item.price} VND x ${item.quantity}",
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
              );
            }).toList(),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
