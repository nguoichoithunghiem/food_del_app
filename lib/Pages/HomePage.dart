import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_del/Widgets/AppBarWidget.dart';
import 'package:food_del/Widgets/CategoriesWidget.dart';
import 'package:food_del/Widgets/DrawerWidget.dart';
import 'package:food_del/Widgets/NewestItemsWidget.dart';
import 'package:food_del/Widgets/PopularItemsWidget.dart';
import 'package:food_del/Service/FoodService.dart'; // Import FoodService để tìm kiếm món ăn

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  String searchQuery = "";
  List<Map<String, dynamic>> categoryResults = [];

  // Tìm kiếm món ăn theo từ khóa
  void _searchFoods() async {
    // Nếu không có từ khóa tìm kiếm, reset lại kết quả tìm kiếm
    if (searchQuery.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    // Tìm kiếm món ăn theo tên
    var result = await FoodService.getFoodsByName(searchQuery);
    setState(() {
      searchResults = result; // Cập nhật danh sách kết quả tìm kiếm
    });
  }

  // Xử lý khi người dùng chọn một danh mục
  void _onCategorySelected(String categoryName) async {
    var result = await FoodService.getFoodsByCategory(categoryName);
    setState(() {
      categoryResults = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Custom App Bar Widget
          Appbarwidget(),

          // Search
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ]),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.search,
                      color: Colors.red,
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value; // Cập nhật giá trị tìm kiếm
                            });
                            _searchFoods(); // Gọi hàm tìm kiếm khi người dùng nhập
                          },
                          decoration: InputDecoration(
                            hintText: "What would you like to have?",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.filter_list),
                  ],
                ),
              ),
            ),
          ),

          // Nếu có kết quả tìm kiếm, hiển thị
          if (searchResults.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Text(
                "Kết quả tìm kiếm",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

          // Hiển thị kết quả tìm kiếm nếu có
          if (searchResults.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: searchResults.map((food) {
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
                                    "https://food-del-web-backend.onrender.com/images/${food['foodImage']}",
                                    height: 130,
                                    width:
                                        130, // Đảm bảo ảnh có kích thước phù hợp với không gian
                                    fit: BoxFit
                                        .cover, // Điều chỉnh cách hiển thị ảnh
                                  ),
                                ),
                              ),
                              Text(
                                food['foodName'] ?? "No name",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                food['foodTitle'] ?? "No Title",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${food['foodPrice'] ?? 0} VNĐ",
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
            ),

          // Category
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "Danh mục",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          // Truyền vào callback onCategorySelected
          CategoriesWidget(onCategorySelected: _onCategorySelected),

          // Hiển thị các món ăn theo danh mục nếu có
          if (categoryResults.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Text(
                "Kết quả tìm kiếm theo danh mục",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

          // Hiển thị các món ăn theo danh mục
          if (categoryResults.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categoryResults.map((food) {
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
                                    "https://food-del-web-backend.onrender.com/images/${food['foodImage']}",
                                    height: 130,
                                    width:
                                        130, // Đảm bảo ảnh có kích thước phù hợp với không gian
                                    fit: BoxFit
                                        .cover, // Điều chỉnh cách hiển thị ảnh
                                  ),
                                ),
                              ),
                              Text(
                                food['foodName'] ?? "No name",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                food['foodTitle'] ?? "No Title",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${food['foodPrice'] ?? 0} VNĐ",
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
            ),

          // Popular Items
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "Popular",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          PopularItemsWidget(),

          // Newest Items
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "Newest",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          NewestItemsWidget(),
        ],
      ),
      drawer: DrawerWidget(),
      floatingActionButton: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ]),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
          child: Icon(
            CupertinoIcons.cart,
            size: 28,
            color: Colors.red,
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
