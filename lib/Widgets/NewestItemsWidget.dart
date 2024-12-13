import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_del/Service/FoodService.dart'; // Import FoodService

class NewestItemsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FoodService
          .getFoods(), // Gọi phương thức lấy dữ liệu món ăn từ MongoDB
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
                              "https://food-del-web-backend.onrender.com/images/${food['foodImage']}", // URL ảnh từ MongoDB
                              height: 130,
                              width:
                                  120, // Đảm bảo ảnh có kích thước phù hợp với không gian
                              fit: BoxFit.cover, // Điều chỉnh cách hiển thị ảnh
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
                                " ${food['foodPrice'] ?? 0} VNĐ", // Giá món ăn từ MongoDB
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
                              Icon(
                                CupertinoIcons.cart,
                                color: Colors.red,
                                size: 26,
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
