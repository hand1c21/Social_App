class Category{
  String? id;
  final String name;
  late final String imagePath;

  Category({this.id, required this.name, required this.imagePath});
  
  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      id: data['uid'],
      name: data['name'],
      imagePath: data['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'name': name,
      'imagePath': imagePath
    };
  }
}