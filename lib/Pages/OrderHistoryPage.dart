import 'package:flutter/material.dart';
import 'package:food_del/Models/cart_item.dart';
import 'package:food_del/Service/OrderService.dart';
import 'package:food_del/Models/orderModel.dart';
import 'package:food_del/Service/AuthService.dart';
import 'package:food_del/Models/ReviewModel.dart';
import 'package:food_del/Service/cart_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import để sử dụng DateFormat

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  int _currentIndex = 1; // Set default index to 1 (Lịch sử đơn hàng)

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Lịch sử đơn hàng'),
          backgroundColor: Colors.red, // Màu sắc AppBar
        ),
        body: Center(child: Text("Thông tin người dùng không có!")),
      );
    }

    final orderService = Provider.of<OrderService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử đơn hàng'),
        backgroundColor: Colors.red,
        elevation: 10,
        centerTitle: true, // Màu sắc AppBar
      ),
      body: FutureBuilder<List<Order>>(
        future: orderService.getOrderHistory(user.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Đã có lỗi xảy ra khi tải đơn hàng."));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Không có đơn hàng nào."));
          }

          // Lấy danh sách đơn hàng và sắp xếp theo orderId (càng lớn thì đơn hàng càng mới)
          List<Order> orders = snapshot.data!;
          orders.sort((a, b) => b.orderId.compareTo(a.orderId));

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(order: order, orderService: orderService);
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
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
        },
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // Màu nền trắng
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

class OrderCard extends StatefulWidget {
  final Order order;
  final OrderService orderService;

  OrderCard({required this.order, required this.orderService});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late Order _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order; // Gán đơn hàng ban đầu
  }

  @override
  Widget build(BuildContext context) {
    // Định dạng ngày giờ
    String formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(_order.orderDate);

    // Cập nhật trạng thái
    String statusMessage = _getStatusMessage(_order.status);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mã đơn hàng: ${_order.orderId}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
            ),
            SizedBox(height: 8),
            Text(
              "Trạng thái: $statusMessage",
              style: TextStyle(fontSize: 14, color: Colors.green),
            ),
            Text("Tổng giá: ${_order.totalPrice} VND",
                style: TextStyle(fontSize: 14, color: Colors.black87)),
            SizedBox(height: 8),
            Text("Địa chỉ giao hàng: ${_order.userAddress}",
                style: TextStyle(fontSize: 14, color: Colors.black54)),
            Text("Số điện thoại: ${_order.userPhone} ",
                style: TextStyle(fontSize: 14, color: Colors.black54)),
            SizedBox(height: 8),
            Text("Ghi chú: ${_order.note}",
                style: TextStyle(fontSize: 14, color: Colors.black54)),
            SizedBox(height: 8),
            Divider(),
            Text("Món ăn: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87)),
            ..._order.items.map((item) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.fastfood, color: Colors.red),
                title: Text(item.foodName, style: TextStyle(fontSize: 14)),
                subtitle: Text("Giá: ${item.price} VND x ${item.quantity}",
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
                trailing: _order.status == 'completed' // Kiểm tra trạng thái
                    ? IconButton(
                        icon: Icon(Icons.rate_review, color: Colors.amber),
                        onPressed: () => _showReviewDialog(context, item),
                      )
                    : null, // Không hiển thị nút đánh giá nếu trạng thái không phải 'completed'
              );
            }).toList(),
            SizedBox(height: 8),
            Divider(),
            // Hiển thị thời gian đặt
            Text("Thời gian đặt: $formattedDate",
                style: TextStyle(fontSize: 14, color: Colors.black54)),

            // Chỉ hiển thị nút Hủy Đơn Hàng khi trạng thái đơn hàng không phải 'completed' hoặc 'cancelled'
            if (_order.status != 'completed' &&
                _order.status != 'canceled') ...[
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  bool confirmCancel = await _showCancelDialog(context);
                  if (confirmCancel) {
                    await widget.orderService.cancelOrder(_order.orderId);
                    setState(() {
                      // Cập nhật trạng thái đơn hàng sau khi hủy
                      _order.status = 'canceled'; // Cập nhật trạng thái hủy
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Đơn hàng đã được hủy."),
                    ));
                  }
                },
                child: Text('Hủy Đơn Hàng'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Màu nền của nút
                  foregroundColor: Colors.white, // Màu chữ của nút
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Hàm để lấy trạng thái hiển thị cho đơn hàng
  String _getStatusMessage(String status) {
    switch (status) {
      case 'canceled':
        return 'Đã hủy đơn';
      case 'shipping':
        return 'Đang trên đường giao';
      case 'confirmed':
        return 'Đã xác nhận đơn';
      case 'completed':
        return 'Đã giao';
      default:
        return 'Đang xử lý';
    }
  }

  // Hiển thị hộp thoại xác nhận hủy đơn hàng
  Future<bool> _showCancelDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Xác nhận hủy đơn hàng"),
              content: Text("Bạn có chắc chắn muốn hủy đơn hàng này?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Không"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Có"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _showReviewDialog(BuildContext context, CartItem item) async {
    TextEditingController commentController = TextEditingController();
    double rating = 0.0;

    // Kiểm tra xem người dùng đã đánh giá món ăn này chưa
    bool hasReviewed =
        await widget.orderService.getReviews(item.foodName).then((reviews) {
      return reviews
          .any((review) => review.userId == AuthService.currentUser!.userId);
    });

    if (hasReviewed) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Bạn đã đánh giá món ăn này rồi."),
      ));
      return; // Nếu đã đánh giá rồi, không cho phép đánh giá thêm
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Sử dụng StatefulBuilder để cập nhật trạng thái rating
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                "Đánh giá món ăn",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tiêu đề món ăn cần đánh giá
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Đánh giá ${item.foodName}:",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  // Các ngôi sao cho người dùng chọn
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            // Cập nhật rating khi người dùng chọn sao
                            rating = (index + 1).toDouble();
                          });
                        },
                        child: Icon(
                          index < rating
                              ? Icons.star // Sao đầy
                              : Icons.star_border, // Sao rỗng
                          color: Colors.amber,
                          size: 40,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 8),

                  // Hiển thị số sao đã chọn
                  Text(
                    "Bạn đã chọn $rating sao",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  // TextField cho nhận xét của người dùng
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Viết nhận xét...",
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: <Widget>[
                // Nút Hủy
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Hủy", style: TextStyle(color: Colors.red)),
                ),

                // Nút Gửi
                TextButton(
                  onPressed: () async {
                    // Gửi đánh giá khi người dùng đã chọn xong
                    await widget.orderService.addReview(
                      userId: AuthService.currentUser!.userId,
                      foodName: item.foodName,
                      userName: AuthService.currentUser!.userName,
                      rating: rating,
                      comment: commentController.text,
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Đánh giá của bạn đã được gửi."),
                    ));
                  },
                  child: Text("Gửi"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
