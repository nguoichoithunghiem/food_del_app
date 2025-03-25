import 'package:flutter/material.dart';
import 'package:food_del/Service/WishlistService.dart'; // Import WishlistService
import 'package:food_del/Models/WishlistItem.dart'; // Import WishlistItem
import 'package:food_del/Service/AuthService.dart'; // Import AuthService
import 'package:intl/intl.dart'; // Import intl package

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late WishlistService _wishlistService;
  int _currentIndex = 2; // Default index to Wishlist (index 2)

  @override
  void initState() {
    super.initState();
    _wishlistService = WishlistService(); // Initialize WishlistService
  }

  // Function to fetch the wishlist items for the current user
  Future<List<WishlistItem>> _fetchWishlist() async {
    final user =
        AuthService.currentUser; // Get the current user from AuthService
    if (user != null) {
      return await _wishlistService
          .getWishlist(user.userId); // Get the wishlist based on userId
    } else {
      return []; // Return an empty list if no user is logged in
    }
  }

  // Function to handle navigation when bottom navigation item is tapped
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
      appBar: AppBar(
        title: Text('Yêu Thích'), // Title of the page
        backgroundColor: Colors.red,
        elevation: 10,
        centerTitle: true, // AppBar background color
      ),
      body: FutureBuilder<List<WishlistItem>>(
        future: _fetchWishlist(), // Get wishlist items
        builder: (context, snapshot) {
          // Check the state of the snapshot
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Wait for data
          } else if (snapshot.hasError) {
            return Center(
                child:
                    Text('Error: ${snapshot.error}')); // Display error if any
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
                    'Bạn chưa thêm món ăn nào vào yêu thích hết')); // No data found
          } else {
            // Display the list of wishlist items if data is available
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
                      "https://food-del-backend-nm2y.onrender.com/images/${item.foodImage}", // Image URL
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover, // Fit the image to the box
                    ),
                    title: Text(item.foodName), // Food name
                    subtitle: Text(
                        'Giá: ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(item.foodPrice)}'), // Price formatted
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // Remove item from wishlist
                        final user = AuthService.currentUser;
                        if (user != null) {
                          await _wishlistService.removeFromWishlist(
                              user.userId, item.foodId);
                          setState(() {}); // Update the UI after removal
                        }
                      },
                    ),
                    onTap: () {
                      // When an item is tapped, you can navigate to the food details page if needed
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      // Bottom navigation bar to switch between pages
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Set the current index to the wishlist
        onTap: _onItemTapped, // Call _onItemTapped function on item tap
        backgroundColor:
            Colors.white, // Background color of the bottom navigation bar
        selectedItemColor: Colors.red, // Color of selected item
        unselectedItemColor: Colors.black, // Color of unselected items
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
