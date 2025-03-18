import 'dart:async'; // Để sử dụng Timer
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_del/Widgets/AppBarWidget.dart';
import 'package:food_del/Widgets/CategoriesWidget.dart';
import 'package:food_del/Widgets/DrawerWidget.dart';
import 'package:food_del/Widgets/NewestItemsWidget.dart';
import 'package:food_del/Widgets/PopularItemsWidget.dart';
import 'package:food_del/Service/FoodService.dart'; // Import FoodService để tìm kiếm món ăn
import 'package:food_del/Service/cart_service.dart'; // Import CartService
import 'package:provider/provider.dart'; // Để sử dụng Provider

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  String searchQuery = "";
  List<Map<String, dynamic>> categoryResults = [];
  int _currentIndex = 0;

  // Thêm một danh sách các URL của ảnh
  final List<String> imageUrls = [
    'https://inan2h.vn/wp-content/uploads/2022/12/in-banner-quang-cao-do-an-7-1.jpg',
    'https://vill.vn/wp-content/uploads/2023/11/3-WEB-BANNER-MUC-KHUYEN-MAI-1024x410.png',
    'https://vill.vn/wp-content/uploads/2024/08/WEB-Thumail-khuyen-mai-tuan-24.08-1024x641.png',
  ];

  // Tạo một controller cho PageView
  PageController _pageController = PageController();

  // Thực hiện tự động chuyển đổi ảnh mỗi 3 giây
  void _startImageSlideshow() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        if (nextPage >= imageUrls.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(nextPage,
            duration: Duration(seconds: 1), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startImageSlideshow(); // Bắt đầu slideshow khi trang được tạo
  }

  // Tìm kiếm món ăn theo từ khóa
  void _searchFoods() async {
    if (searchQuery.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

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

  // Điều hướng khi chọn mục trong BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/order_history');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/wishlist');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/account');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Custom App Bar Widget
          Appbarwidget(),

          // Tìm kiếm
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
                ],
              ),
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
                            hintText: "Bạn muốn ăn gì?",
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

          // Thêm Slider ảnh dưới thanh tìm kiếm
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Container(
              height: 180, // Chiều cao của slider
              child: PageView.builder(
                controller: _pageController,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
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
                                  Navigator.pushNamed(
                                    context,
                                    "itemPage",
                                    arguments: food,
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Image.network(
                                    "https://food-del-web-backend.onrender.com/images/${food['foodImage']}",
                                    height: 130,
                                    width: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                food['foodName'] ?? "Không có tên",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                food['foodTitle'] ?? "Không có tiêu đề",
                                style: TextStyle(fontSize: 9),
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

          // Danh mục
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "Danh mục",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
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
                                  Navigator.pushNamed(
                                    context,
                                    "itemPage",
                                    arguments: food,
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Image.network(
                                    "https://food-del-web-backend.onrender.com/images/${food['foodImage']}",
                                    height: 130,
                                    width: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                food['foodName'] ?? "Không có tên",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                food['foodTitle'] ?? "Không có tiêu đề",
                                style: TextStyle(fontSize: 9),
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

          // Món ăn phổ biến
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "Món ăn phổ biến",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          PopularItemsWidget(),

          // Món ăn mới nhất
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Text(
              "Món ăn mới nhất",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          NewestItemsWidget(),
        ],
      ),
      drawer: DrawerWidget(),

      // FloatingActionButton with item count
      floatingActionButton: Consumer<CartService>(
        builder: (context, cartService, child) {
          int itemCount = cartService.itemCount;

          return FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Icon(
                  CupertinoIcons.cart,
                  size: 28,
                  color: Colors.red,
                ),
                if (itemCount > 0)
                  Positioned(
                    right: 0,
                    top: -5,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        itemCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            backgroundColor: Colors.white,
          );
        },
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white, // Màu nền trắng
        selectedItemColor: Colors.red, // Màu của icon khi được chọn
        unselectedItemColor: Colors.black, // Màu của icon khi không được chọn
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Đơn Hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.heart_broken),
            label: 'Yêu Thích',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}
