import 'package:food_del/DB/MongoDB.dart';
import 'package:food_del/Models/couponModel.dart';

class CouponService {
  // Kiểm tra mã giảm giá hợp lệ
  Future<Coupon?> getValidCoupon(String couponCode) async {
    var couponData = await MongoDatabase.checkCoupon(
        couponCode); // Lấy thông tin mã giảm giá từ MongoDB

    if (couponData == null) {
      return null; // Nếu không có coupon hợp lệ, trả về null
    }

    // Chuyển dữ liệu từ MongoDB thành Coupon object
    Coupon coupon = Coupon.fromMap(couponData);
    return coupon;
  }

  // Áp dụng giảm giá cho đơn hàng
  double applyCoupon(double totalPrice, Coupon coupon) {
    double discountValue = coupon.discountValue;
    String discountType = coupon.discountType;

    if (discountType == 'percentage') {
      // Nếu loại giảm giá là percentage, tính giảm giá theo phần trăm
      totalPrice -= totalPrice * (discountValue / 100);
    } else if (discountType == 'fixed') {
      // Nếu loại giảm giá là fixed, trừ đi giá trị giảm trực tiếp
      totalPrice -= discountValue;
    }

    // Đảm bảo rằng giá trị không âm
    if (totalPrice < 0) totalPrice = 0;

    return totalPrice;
  }
}
