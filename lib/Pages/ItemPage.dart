import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_del/Models/cart_item.dart';
import 'package:food_del/Service/OrderService.dart';
import 'package:food_del/Widgets/AppBarWidget.dart';
import 'package:food_del/Widgets/ItemBottomNavBar.dart';
import 'package:food_del/Service/cart_service.dart'; // Import CartService
import 'package:food_del/Models/ReviewModel.dart'; // Import ReviewModel
import 'package:food_del/Widgets/DrawerWidget.dart'; // Import DrawerWidget
import 'package:provider/provider.dart'; // Import Provider

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  int _quantity = 1; // Biến lưu số lượng món ăn
  double _rating = 0.0; // Biến lưu rating của người dùng
  String _comment = ''; // Biến lưu bình luận của người dùng

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin món ăn từ arguments
    final Map<String, dynamic> food =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Lấy CartService từ Provider
    final cartService = Provider.of<CartService>(context);
    final orderService =
        Provider.of<OrderService>(context); // Lấy OrderService từ Provider

    return Scaffold(
      drawer: DrawerWidget(), // Thêm DrawerWidget vào đây
      body: Padding(
        padding: EdgeInsets.only(top: 5),
        child: ListView(
          children: [
            Appbarwidget(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Image.network(
                "https://food-del-web-backend.onrender.com/images/${food['foodImage']}",
                height: 300,
              ),
            ),
            Arc(
              edge: Edge.TOP,
              arcType: ArcType.CONVEY,
              height: 30,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 60, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBar.builder(
                              initialRating:
                                  food['foodRating']?.toDouble() ?? 4.0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemSize: 18,
                              itemPadding: EdgeInsets.symmetric(horizontal: 4),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.red,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            Text(
                              "${food['foodPrice'] ?? 0} VND",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Đặt Text tên món ăn vào Expanded để nó có thể xuống dòng mà không đẩy nút
                            Expanded(
                              child: Text(
                                food['foodName'] ?? "No name",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow
                                      .ellipsis, // Tránh tên quá dài gây tràn
                                ),
                                softWrap: true, // Cho phép tự động xuống dòng
                              ),
                            ),
                            // Container chứa nút tăng giảm số lượng
                            Container(
                              width: 130,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      CupertinoIcons.minus,
                                      color: Colors.white,
                                      size: 16, // Giảm kích thước nút 20%
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (_quantity > 1) _quantity--;
                                      });
                                    },
                                  ),
                                  Text(
                                    "$_quantity",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      CupertinoIcons.add,
                                      color: Colors.white,
                                      size: 16, // Giảm kích thước nút 20%
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _quantity++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          food['foodDescription'] ?? "No description",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "vận chuyển:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Icon(
                                    CupertinoIcons.clock,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  "30 Phút",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Đánh Giá Và Bình Luận",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ]),
                      ),
                      // Hiển thị đánh giá hiện có
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: FutureBuilder<List<Review>>(
                          future: orderService.getReviews(food['foodName']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("Lỗi khi tải đánh giá");
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text("Chưa có đánh giá.");
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: snapshot.data!.map((review) {
                                  return ListTile(
                                    title: Text(review.userName),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RatingBar.builder(
                                          initialRating: review.rating,
                                          minRating: 1,
                                          itemCount: 5,
                                          itemSize: 18,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                        Text(review.comment),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ),
                      // Form nhập đánh giá mới
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ItemBottomNavBar(
        onAddToCart: () {
          // Khi nhấn nút "Add to Cart"
          CartItem newItem = CartItem(
            foodName: food['foodName'],
            foodImage: food['foodImage'],
            price: (food['foodPrice'] ?? 0).toDouble(),
            quantity: _quantity,
          );

          // Thêm món ăn vào giỏ hàng
          cartService.addItem(newItem);

          // Hiển thị thông báo cho người dùng
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${food['foodName']} added to cart"),
            ),
          );
        },
      ),
    );
  }
}
