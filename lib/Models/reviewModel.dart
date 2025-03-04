class Review {
  String reviewId;
  String userId;
  String foodName;
  String userName;
  double rating;
  String comment;
  DateTime reviewDate;

  Review({
    required this.reviewId,
    required this.userId,
    required this.foodName,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.reviewDate,
  });

  // Phương thức khởi tạo từ Map
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      reviewId: map['reviewId'],
      userId: map['userId'],
      foodName: map['foodName'],
      userName: map['userName'],
      rating: map['rating'],
      comment: map['comment'],
      reviewDate: DateTime.parse(map['reviewDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'userId': userId,
      'foodName': foodName,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'reviewDate': reviewDate.toIso8601String(),
    };
  }
}
