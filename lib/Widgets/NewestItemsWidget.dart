import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_del/Models/cart_item.dart';
import 'package:food_del/Service/FoodService.dart';
import 'package:food_del/Service/cart_service.dart'; // Import CartService
import 'package:provider/provider.dart'; // Import Provider

class NewestItemsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy CartService từ Provider
    final cartService = Provider.of<CartService>(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      // Lấy danh sách món ăn từ FoodService
      future: FoodService.getFoods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Hiển thị khi đang tải
        }

        if (snapshot.hasError) {
          return Center(
              child: Text("Error: ${snapshot.error}")); // Hiển thị lỗi nếu có
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text("No items found")); // Nếu không có món ăn nào
        }

        List<Map<String, dynamic>> foods = snapshot.data!; // Danh sách món ăn

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: foods.map((food) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: 380,
                    height: 150,
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
                        InkWell(
                          onTap: () {
                            // Điều hướng đến trang chi tiết món ăn và truyền dữ liệu
                            Navigator.pushNamed(
                              context,
                              "itemPage",
                              arguments: food, // Truyền dữ liệu món ăn
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.network(
                              "https://food-del-web-backend.onrender.com/images/${food['foodImage']}",
                              height: 130,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: 190,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                food['foodName'] ??
                                    "No name", // Tên món ăn từ MongoDB
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                food['foodDescription'] ??
                                    "No description", // Mô tả món ăn từ MongoDB
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              RatingBar.builder(
                                initialRating: food['foodRating']?.toDouble() ??
                                    4.0, // Đánh giá món ăn
                                minRating: 1,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 18,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.red,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              Text(
                                " ${(food['foodPrice'] ?? 0).toDouble().toStringAsFixed(0)} VNĐ", // Ép kiểu int sang double
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                                size: 26,
                              ),
                              IconButton(
                                icon: Icon(
                                  CupertinoIcons.cart,
                                  color: Colors.red,
                                  size: 26,
                                ),
                                onPressed: () {
                                  // Khi nhấn vào giỏ hàng, thêm món vào giỏ hàng
                                  CartItem newItem = CartItem(
                                    foodName: food['foodName'],
                                    foodImage: food['foodImage'],
                                    price: (food['foodPrice'] ?? 0).toDouble(),
                                    quantity: 1, // Thêm số lượng mặc định là 1
                                  );

                                  // Thêm món ăn vào giỏ hàng
                                  cartService.addItem(newItem);

                                  // Hiển thị thông báo cho người dùng
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "${food['foodName']} added to cart"),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
