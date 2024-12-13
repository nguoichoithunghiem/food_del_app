import 'package:flutter/material.dart';

class FoodItemWidget extends StatelessWidget {
  final Map<String, dynamic> food;

  FoodItemWidget({required this.food});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset("images/${food['image']}", width: 50, height: 50),
      title: Text(food['name']),
      subtitle: Text("\$${food['price']}"),
      onTap: () {
        // Xử lý khi bấm vào món ăn (ví dụ: điều hướng đến trang chi tiết món ăn)
      },
    );
  }
}
