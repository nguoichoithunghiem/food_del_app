import 'package:flutter/material.dart';
import 'package:food_del/Service/cart_service.dart';
import 'package:food_del/Models/orderModel.dart';
import 'package:food_del/Service/OrderService.dart';
import 'package:food_del/Service/AuthService.dart';
import 'package:food_del/Models/userModel.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import intl package for currency formatting

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController userPhoneController = TextEditingController();
  final TextEditingController userAddressController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController couponController = TextEditingController();
  double totalPrice = 0.0; // Total price after discount
  double discountAmount = 0.0; // Discount amount
  bool isCouponApplied = false; // Flag to check if coupon has been applied

  // Helper function to format the price
  String formatCurrency(double price) {
    return NumberFormat.simpleCurrency(locale: 'vi_VN').format(price);
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final orderService = OrderService(cartService: cartService);

    // Get the current user information from AuthService
    final User? user = AuthService.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text("Thông tin người dùng không có!")),
      );
    }

    // Calculate the original total price
    double originalTotal = cartService.getTotal();

    // Function to calculate total after discount
    double calculateTotalAfterDiscount(double originalTotal, double discount) {
      if (discount < 1) {
        // Discount as a percentage
        return originalTotal * (1 - discount);
      } else {
        // Discount as a fixed amount
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
            // User information form
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
                  SizedBox(height: 16),

                  // Row to place the coupon input and apply button on the same line
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                            couponController, 'Mã giảm giá', Icons.local_offer),
                      ),
                      SizedBox(width: 10),
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
                                    content:
                                        Text('Mã giảm giá đã được áp dụng!')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Mã giảm giá không hợp lệ!')),
                              );
                            }
                          },
                          child: Text("Áp dụng"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Button color
                            foregroundColor: Colors.white, // Button text color
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // List of items in the cart
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
                        "Số lượng: ${cartItem.quantity} x ${formatCurrency(cartItem.price)}"),
                    trailing: Text(
                        "${formatCurrency(cartItem.price * cartItem.quantity)}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // Total price and discount details
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tổng tiền gốc: ${formatCurrency(cartService.getTotal())}",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  if (isCouponApplied)
                    Text(
                        "Giảm giá: -${formatCurrency(discountAmount * cartService.getTotal())}",
                        style: TextStyle(fontSize: 18, color: Colors.green)),
                  if (isCouponApplied)
                    Text(
                      "Tổng sau giảm giá: ${formatCurrency(totalPrice)}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            // Order button
            ElevatedButton(
              onPressed: () async {
                if (cartService.items.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Giỏ hàng của bạn trống!')),
                  );
                  return;
                }

                // Get user info
                String userPhone = userPhoneController.text;
                String userAddress = userAddressController.text;
                String note = noteController.text;

                // Create the order
                Order order = orderService.createOrder(
                  user: user,
                  userPhone: userPhone,
                  userAddress: userAddress,
                  note: note,
                );

                // Set the total price after discount
                order.totalPrice = isCouponApplied ? totalPrice : originalTotal;

                // Save the order to the database
                await orderService.saveOrder(order);

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đơn hàng của bạn đã được đặt!')),
                );

                // Navigate to the order confirmation page
                Navigator.pushNamed(context, '/order_confirmation',
                    arguments: order);
              },
              child: Text("Đặt hàng"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button background color
                foregroundColor: Colors.white, // Button text color
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build text fields
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
