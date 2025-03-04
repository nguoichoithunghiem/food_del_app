import 'package:flutter/foundation.dart';
import 'package:food_del/Models/cart_item.dart'; // Đảm bảo bạn đã import package này

class CartService extends ChangeNotifier {
  // Danh sách các món ăn trong giỏ hàng
  List<CartItem> _items = [];

  // Getter để lấy danh sách món ăn trong giỏ hàng
  List<CartItem> get items => _items;

  // Getter để lấy tổng số lượng món ăn trong giỏ hàng
  int get itemCount {
    int count = 0;
    for (var item in _items) {
      count += item.quantity;
    }
    return count;
  }

  // Thêm item vào giỏ hàng
  void addItem(CartItem item) {
    var existingItem = _items.firstWhere(
      (cartItem) => cartItem.foodName == item.foodName,
      orElse: () => CartItem(foodName: '', foodImage: '', price: 0),
    );

    // Nếu món ăn đã có trong giỏ hàng, tăng số lượng lên
    if (existingItem.foodName.isNotEmpty) {
      updateQuantity(existingItem.foodName, existingItem.quantity + 1);
    } else {
      // Nếu món ăn chưa có, thêm món ăn mới vào giỏ hàng
      _items.add(item);
    }
    notifyListeners(); // Thông báo các listeners khi có sự thay đổi
  }

  // Cập nhật số lượng của món ăn
  void updateQuantity(String foodName, int quantity) {
    if (quantity < 1) return;
    CartItem item = _items.firstWhere(
      (cartItem) => cartItem.foodName == foodName,
    );
    item.quantity = quantity;
    notifyListeners(); // Thông báo các listeners khi có sự thay đổi
  }

  // Tính tổng giá trị của giỏ hàng
  double getTotal() {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // Xóa món ăn khỏi giỏ hàng
  void removeItem(String foodName) {
    _items.removeWhere((item) => item.foodName == foodName);
    notifyListeners(); // Thông báo các listeners khi có sự thay đổi
  }
}
