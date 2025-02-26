import 'package:flutter/material.dart';
import 'package:food_del/Service/FoodService.dart';
import 'package:food_del/Service/WishlistService.dart'; // Import WishlistService
import 'package:food_del/Service/AuthService.dart'; // Import AuthService
import 'package:provider/provider.dart'; // Import Provider

class PopularItemsWidget extends StatefulWidget {
  @override
  _PopularItemsWidgetState createState() => _PopularItemsWidgetState();
}

class _PopularItemsWidgetState extends State<PopularItemsWidget> {
  // Trạng thái lưu thông tin món ăn đã được thêm vào wishlist
  Map<String, bool> _wishlistStatus = {};

  @override
  Widget build(BuildContext context) {
    // Lấy WishlistService từ Provider
    final wishlistService =
        WishlistService(); // Tạo instance của WishlistService

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

        // Lấy userId từ AuthService (người dùng hiện tại)
        final currentUser = AuthService.currentUser;
        final userId = currentUser?.userId;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: Row(
              children: foods.map((food) {
                // Kiểm tra xem món ăn đã có trong wishlist chưa
                bool isInWishlist =
                    _wishlistStatus[food['_id'].toString()] ?? false;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Container(
                    width: 180,
                    height: 250,
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
                              fontSize: 14, // Reduced by 30%
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            food['foodTitle'] ?? "No Title", // Mô tả món ăn
                            style: TextStyle(
                              fontSize: 10, // Reduced by 30%
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${food['foodPrice'] ?? 0} VNĐ", // Giá món ăn
                                style: TextStyle(
                                  fontSize: 12, // Reduced by 30%
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isInWishlist
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                  size: 26,
                                ),
                                onPressed: () {
                                  if (userId != null) {
                                    if (isInWishlist) {
                                      // Nếu món ăn đã có trong wishlist, bỏ vào wishlist
                                      wishlistService.removeFromWishlist(
                                          userId, food['_id'].toString());

                                      setState(() {
                                        _wishlistStatus[
                                            food['_id'].toString()] = false;
                                      });

                                      // Hiển thị thông báo
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "${food['foodName']} removed from wishlist"),
                                        ),
                                      );
                                    } else {
                                      // Thêm món vào wishlist
                                      wishlistService.addToWishlist(
                                        userId,
                                        food['_id'].toString(),
                                        food['foodName'],
                                        food['foodImage'],
                                        (food['foodPrice'] ?? 0).toDouble(),
                                      );

                                      setState(() {
                                        _wishlistStatus[
                                            food['_id'].toString()] = true;
                                      });

                                      // Hiển thị thông báo
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "${food['foodName']} added to wishlist"),
                                        ),
                                      );
                                    }
                                  }
                                },
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
