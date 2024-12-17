class CartItem {
  final String foodName;
  final String foodImage;
  final double price;
  int quantity;

  CartItem({
    required this.foodName,
    required this.foodImage,
    required this.price,
    this.quantity = 1,
  });

  // Hàm tạo CartItem từ một đối tượng Map (để lấy từ MongoDB hoặc API)
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      foodName: map['foodName'] ??
          'No Name', // Nếu không có foodName thì dùng 'No Name'
      foodImage: map['foodImage'] ?? '', // Nếu không có foodImage thì để trống
      price: (map['foodPrice'] ?? 0)
          .toDouble(), // Đảm bảo giá là kiểu double, nếu không thì mặc định 0
      quantity:
          map['quantity'] ?? 1, // Số lượng mặc định là 1 nếu không có giá trị
    );
  }

  // Hàm chuyển CartItem thành Map để lưu trữ (nếu cần)
  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'foodImage': foodImage,
      'foodPrice': price, // Lưu giá trị thực tế
      'quantity': quantity,
    };
  }
}
