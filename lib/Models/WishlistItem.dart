// WishlistItem.dart
class WishlistItem {
  final String userId;
  final String foodId;
  final String foodName;
  final String foodImage;
  final double foodPrice;

  WishlistItem({
    required this.userId,
    required this.foodId,
    required this.foodName,
    required this.foodImage,
    required this.foodPrice,
  });

  // Chuyển đổi WishlistItem thành Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'foodId': foodId,
      'foodName': foodName,
      'foodImage': foodImage,
      'foodPrice': foodPrice,
    };
  }

  // Khôi phục WishlistItem từ Map<String, dynamic>
  factory WishlistItem.fromMap(Map<String, dynamic> map) {
    return WishlistItem(
      userId: map['userId'],
      foodId: map['foodId'],
      foodName: map['foodName'],
      foodImage: map['foodImage'],
      foodPrice: map['foodPrice'],
    );
  }
}
