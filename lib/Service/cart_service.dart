import 'package:flutter/foundation.dart';
import 'package:food_del/Models/cart_item.dart'; // Đảm bảo bạn đã import package này
// Giả sử bạn đã có lớp CartItem

class CartService extends ChangeNotifier {
  // Kế thừa từ ChangeNotifier
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Thêm item vào giỏ hàng
  void addItem(CartItem item) {
    var existingItem = _items.firstWhere(
      (cartItem) => cartItem.foodName == item.foodName,
      orElse: () => CartItem(foodName: '', foodImage: '', price: 0),
    );

    if (existingItem.foodName.isNotEmpty) {
      updateQuantity(existingItem.foodName, existingItem.quantity + 1);
    } else {
      _items.add(item);
    }
    notifyListeners(); // Thông báo các listeners khi có sự thay đổi
  }

  void updateQuantity(String foodName, int quantity) {
    if (quantity < 1) return;
    CartItem item = _items.firstWhere(
      (cartItem) => cartItem.foodName == foodName,
    );
    item.quantity = quantity;
    notifyListeners(); // Thông báo các listeners khi có sự thay đổi
  }

  double getTotal() {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void removeItem(String foodName) {
    _items.removeWhere((item) => item.foodName == foodName);
    notifyListeners(); // Thông báo các listeners khi có sự thay đổi
  }
}
