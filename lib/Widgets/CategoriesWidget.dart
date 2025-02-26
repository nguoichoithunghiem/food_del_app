import 'package:flutter/material.dart';
import 'package:food_del/Service/CategoriesService.dart'; // Giả sử bạn có CategoryService để lấy danh mục

class CategoriesWidget extends StatelessWidget {
  final Function(String) onCategorySelected;

  CategoriesWidget({required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: CategoriesService.getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Lỗi: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Không có danh mục"));
        }

        List<Map<String, dynamic>> categories = snapshot.data!;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: Row(
              children: categories.map((category) {
                IconData categoryIcon;

                // Chọn icon theo tên danh mục
                switch (category['name']) {
                  case 'Món chính':
                    categoryIcon = Icons.restaurant; // Món Chính -> restaurant
                    break;
                  case 'Món phụ':
                    categoryIcon = Icons.kitchen; // Món Phụ -> kitchen
                    break;
                  case 'Món ăn kèm':
                    categoryIcon = Icons.set_meal; // Món Ăn Kèm -> set_meal
                    break;
                  case 'Nước':
                    categoryIcon = Icons.local_drink; // Nước -> local_drink
                    break;
                  default:
                    categoryIcon =
                        Icons.category; // Mặc định nếu không có tên chính xác
                    break;
                }

                return GestureDetector(
                  onTap: () {
                    // Truyền tên danh mục khi người dùng chọn
                    onCategorySelected(category['name']);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                categoryIcon, // Hiển thị icon tương ứng
                                size: 30,
                                color: Colors.red,
                              ),
                              SizedBox(height: 8),
                              Text(
                                category['name'] ?? 'Không xác định',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2),
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
