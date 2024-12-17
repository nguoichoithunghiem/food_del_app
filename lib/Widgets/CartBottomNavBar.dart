import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_del/Service/cart_service.dart'; // Import CartService

class CartBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy CartService từ Provider
    final cartService = Provider.of<CartService>(context);

    double totalPrice = cartService.getTotal(); // Lấy tổng tiền từ CartService

    return BottomAppBar(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Total:",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "${totalPrice.toStringAsFixed(0)} VNĐ", // Hiển thị tổng tiền
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Chuyển hướng tới trang OrderPage
                if (cartService.items.isNotEmpty) {
                  Navigator.pushNamed(context, '/order_page');
                } else {
                  // Hiển thị thông báo nếu giỏ hàng trống
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Your cart is empty!')),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: Text(
                "Order Now",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
