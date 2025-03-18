import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_del/Models/cart_item.dart';
import 'package:food_del/Service/FoodService.dart';
import 'package:food_del/Service/cart_service.dart'; // Import CartService
import 'package:food_del/Service/WishlistService.dart'; // Import WishlistService
import 'package:food_del/Service/AuthService.dart'; // Import AuthService
import 'package:provider/provider.dart'; // Import Provider

class NewestItemsWidget extends StatefulWidget {
  @override
  _NewestItemsWidgetState createState() => _NewestItemsWidgetState();
}

class _NewestItemsWidgetState extends State<NewestItemsWidget> {
  // Trạng thái lưu thông tin món ăn đã được thêm vào wishlist
  Map<String, bool> _wishlistStatus = {};

  @override
  Widget build(BuildContext context) {
    // Lấy CartService và WishlistService từ Provider
    final cartService = Provider.of<CartService>(context);
    final wishlistService =
        WishlistService(); // Tạo instance của WishlistService

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FoodService.getFoods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No items found"));
        }

        // Lấy danh sách món ăn và giới hạn chỉ 10 món
        List<Map<String, dynamic>> foods = snapshot.data!;
        List<Map<String, dynamic>> limitedFoods =
            foods.take(10).toList(); // Lấy 10 món ăn đầu tiên

        // Đảo ngược danh sách để hiển thị từ dưới lên
        List<Map<String, dynamic>> reversedFoods =
            limitedFoods.reversed.toList();

        final currentUser = AuthService.currentUser;
        final userId = currentUser?.userId;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: reversedFoods.map((food) {
                bool isInWishlist =
                    _wishlistStatus[food['_id'].toString()] ?? false;

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
                            Navigator.pushNamed(
                              context,
                              "itemPage",
                              arguments: food,
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.network(
                              "https://food-del-backend-nm2y.onrender.com/images/${food['foodImage']}",
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
                                food['foodName'] ?? "No name",
                                style: TextStyle(
                                  fontSize: 15, // Reduced by 30% from 22
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                food['foodDescription'] ?? "No description",
                                style: TextStyle(
                                  fontSize: 11, // Reduced by 30% from 16
                                ),
                              ),
                              RatingBar.builder(
                                initialRating:
                                    food['foodRating']?.toDouble() ?? 4.0,
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
                                " ${(food['foodPrice'] ?? 0).toDouble().toStringAsFixed(0)} VNĐ",
                                style: TextStyle(
                                  fontSize: 14, // Reduced by 30% from 20
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
                              IconButton(
                                icon: Icon(
                                  CupertinoIcons.cart,
                                  color: Colors.red,
                                  size: 26,
                                ),
                                onPressed: () {
                                  CartItem newItem = CartItem(
                                    foodName: food['foodName'],
                                    foodImage: food['foodImage'],
                                    price: (food['foodPrice'] ?? 0).toDouble(),
                                    quantity: 1,
                                  );

                                  cartService.addItem(newItem);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "${food['foodName']} added to cart"),
                                    ),
                                  );
                                },
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
                                      wishlistService.removeFromWishlist(
                                          userId, food['_id'].toString());

                                      setState(() {
                                        _wishlistStatus[
                                            food['_id'].toString()] = false;
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "${food['foodName']} removed from wishlist"),
                                        ),
                                      );
                                    } else {
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
