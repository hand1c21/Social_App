class Post {
  String? id;
  final String userId;
  String categoryId;
  final String title;
  final String description;
  final String city;
  final DateTime time;
  final String? imagePath;
  bool isAvailable;

  Post({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.city,
    required this.time,
    this.imagePath,
    this.isAvailable = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'description': description,
      'city': city,
      'title': title,
      'userId': userId,
      'imagePath': imagePath,
      'time': time,
      'isAvailable': isAvailable,
    };
  }

  factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
      id: data['uid'],
      categoryId: data['categoryId'],
      description: data['description'],
      title: data['title'],
      city: data['city'],
      imagePath: data['imagePath'],
      userId: data['userId'],
      time: data['time'],
      isAvailable: data['isAvailable'],
    );
  }
}
