import 'package:food_del/DB/MongoDB.dart';
import 'package:food_del/Models/WishlistItem.dart';

class WishlistService {
  // Thêm món ăn vào wishlist của người dùng
  Future<void> addToWishlist(String userId, String foodId, String foodName,
      String foodImage, double foodPrice) async {
    try {
      // Gọi MongoDatabase để thêm món ăn vào wishlist
      await MongoDatabase.addToWishlist(
          userId, foodId, foodName, foodImage, foodPrice);
      print("Item added to wishlist");
    } catch (e) {
      print("Error adding to wishlist: $e");
    }
  }

  // Lấy danh sách wishlist của người dùng
  Future<List<WishlistItem>> getWishlist(String userId) async {
    try {
      // Gọi MongoDatabase để lấy danh sách wishlist của người dùng
      return await MongoDatabase.getWishlist(userId);
    } catch (e) {
      print("Error getting wishlist: $e");
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  // Lấy danh sách wishlist của người dùng (new method with a different name)
  Future<List<WishlistItem>> getWishlistByUserId(String userId) async {
    try {
      // Gọi MongoDatabase để lấy danh sách wishlist của người dùng
      return await MongoDatabase.getWishlist(userId);
    } catch (e) {
      print("Error getting wishlist by userId: $e");
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  // Xóa món ăn khỏi wishlist của người dùng
  Future<void> removeFromWishlist(String userId, String foodId) async {
    try {
      // Gọi MongoDatabase để xóa món ăn khỏi wishlist
      await MongoDatabase.removeFromWishlist(userId, foodId);
      print("Item removed from wishlist");
    } catch (e) {
      print("Error removing from wishlist: $e");
    }
  }
}
