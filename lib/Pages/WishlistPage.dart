import 'package:flutter/material.dart';
import 'package:food_del/Service/WishlistService.dart'; // Import WishlistService
import 'package:food_del/Models/WishlistItem.dart'; // Import WishlistItem
import 'package:food_del/Service/AuthService.dart'; // Import AuthService

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late WishlistService _wishlistService;

  @override
  void initState() {
    super.initState();
    _wishlistService = WishlistService(); // Khởi tạo WishlistService
  }

  // Hàm để lấy danh sách wishlist của người dùng
  Future<List<WishlistItem>> _fetchWishlist() async {
    final user =
        AuthService.currentUser; // Lấy người dùng hiện tại từ AuthService
    if (user != null) {
      return await _wishlistService
          .getWishlist(user.userId); // Lấy wishlist dựa trên userId
    } else {
      return []; // Trả về danh sách rỗng nếu không có người dùng đăng nhập
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yêu Thích'), // Tiêu đề của trang
        backgroundColor: Colors.red, // Màu nền appBar
      ),
      body: FutureBuilder<List<WishlistItem>>(
        future: _fetchWishlist(), // Dữ liệu wishlist
        builder: (context, snapshot) {
          // Kiểm tra trạng thái của snapshot
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // Chờ tải dữ liệu
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Hiển thị lỗi nếu có
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
                    'Bạn chưa thêm món ăn nào vào yêu thích hết')); // Hiển thị nếu wishlist trống
          } else {
            // Hiển thị danh sách món ăn nếu có dữ liệu
            var wishlist = snapshot.data!;
            return ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                var item = wishlist[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    leading: Image.network(
                      "https://food-del-web-backend.onrender.com/images/${item.foodImage}", // URL của hình ảnh
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover, // Làm đầy khung hình
                    ),
                    title: Text(item.foodName), // Tên món ăn
                    subtitle: Text(
                        'Giá: ${item.foodPrice.toStringAsFixed(0)} VNĐ'), // Giá món ăn
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // Xóa món ăn khỏi wishlist
                        final user = AuthService.currentUser;
                        if (user != null) {
                          await _wishlistService.removeFromWishlist(
                              user.userId, item.foodId);
                          setState(() {}); // Cập nhật lại giao diện sau khi xóa
                        }
                      },
                    ),
                    onTap: () {
                      // Khi người dùng chọn món ăn, có thể chuyển đến trang chi tiết món ăn
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
