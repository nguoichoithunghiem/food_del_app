class Coupon {
  final String code;
  final String description;
  final String discountType; // "percentage" hoặc "fixed"
  final double discountValue;
  final DateTime expiryDate;
  final bool active;

  Coupon({
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.expiryDate,
    required this.active,
  });

  // Chuyển đổi từ Map vào Object
  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      code: map['code'],
      description: map['description'],
      discountType: map['discountType'],
      discountValue: map['discountValue'],
      expiryDate: DateTime.parse(map['expiryDate']),
      active: map['active'],
    );
  }

  // Chuyển đổi từ Object vào Map
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'expiryDate': expiryDate.toIso8601String(),
      'active': active,
    };
  }
}
