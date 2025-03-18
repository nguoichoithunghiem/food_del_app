import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_del/Service/OrderService.dart';
import 'package:food_del/Service/cart_service.dart';
import 'package:food_del/Widgets/CartBottomNavBar.dart';
import 'package:food_del/Widgets/DrawerWidget.dart';
import 'package:provider/provider.dart'; // Import provider

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy CartService từ Provider
    final cartService = Provider.of<CartService>(context);
    final orderService =
        OrderService(cartService: cartService); // Khởi tạo OrderService

    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng của bạn"),
      ),
      body: cartService.items.isEmpty
          ? Center(child: Text("Giỏ hàng của bạn hiện đang trống"))
          : ListView.builder(
              itemCount: cartService.items.length,
              itemBuilder: (context, index) {
                var cartItem = cartService.items[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Hình ảnh món ăn
                        Container(
                          alignment: Alignment.center,
                          child: Image.network(
                            'https://food-del-backend-nm2y.onrender.com/images/${cartItem.foodImage}', // Đảm bảo bạn dùng Image.network
                            height: 80,
                            width: 80, // Giảm kích thước hình ảnh để tránh tràn
                            fit: BoxFit.cover, // Đảm bảo hình ảnh không bị vỡ
                          ),
                        ),
                        // Thông tin món ăn
                        Expanded(
                          // Dùng Expanded thay cho Flexible để đảm bảo chiếm toàn bộ không gian còn lại
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem.foodName,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow
                                      .ellipsis, // Tránh tràn văn bản dài
                                  maxLines: 1,
                                ),
                                Text(
                                  "Thưởng thức ${cartItem.foodName}",
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  "${cartItem.price.toStringAsFixed(0)} VNĐ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Số lượng và cập nhật số lượng món ăn
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                // Nút cộng số lượng
                                IconButton(
                                  icon: Icon(CupertinoIcons.add,
                                      color: Colors.white),
                                  onPressed: () {
                                    cartService.updateQuantity(
                                        cartItem.foodName,
                                        cartItem.quantity + 1);
                                  },
                                ),
                                Text(
                                  "${cartItem.quantity}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                // Nút trừ số lượng
                                IconButton(
                                  icon: Icon(CupertinoIcons.minus,
                                      color: Colors.white),
                                  onPressed: () {
                                    if (cartItem.quantity > 1) {
                                      cartService.updateQuantity(
                                          cartItem.foodName,
                                          cartItem.quantity - 1);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Xóa món ăn khỏi giỏ hàng
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            cartService.removeItem(cartItem.foodName);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      // Thanh điều hướng dưới cùng
      bottomNavigationBar: CartBottomNavBar(),
      // Menu điều hướng
      drawer: DrawerWidget(),
    );
  }
}
