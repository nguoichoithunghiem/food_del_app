import 'package:flutter/material.dart';
import 'package:food_del/Service/FoodService.dart';

class PopularItemsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FoodService.getFoods(), // Gọi phương thức lấy dữ liệu món ăn
      builder: (context, snapshot) {
        // Kiểm tra trạng thái kết nối
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
              child: Text("No foods found")); // Hiển thị khi không có dữ liệu
        }

        List<Map<String, dynamic>> foods =
            snapshot.data!; // Lấy danh sách món ăn

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: Row(
              children: foods.map((food) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Container(
                    width: 170,
                    height: 225,
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    130, // Đảm bảo ảnh có kích thước phù hợp với không gian
                                fit: BoxFit
                                    .cover, // Điều chỉnh cách hiển thị ảnh
                              ),
                            ),
                          ),
                          Text(
                            food['foodName'] ?? "No name", // Tên món ăn
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            food['foodTitle'] ?? "No Title", // Mô tả món ăn
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${food['foodPrice'] ?? 0} VNĐ", // Giá món ăn
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                                size: 26,
                              ),
                            ],
                          ),
                        ],
                      ),
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
