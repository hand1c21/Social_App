class MyUser{
  String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? password;
  final String city;
  final String phoneNum;
  bool? isAdminAllowed;
  

  MyUser({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    required this.city,
    required this.phoneNum,
    this.isAdminAllowed,
  });


  factory MyUser.fromMap(Map<String, dynamic> data) {
    return MyUser(
      id: data['uid'],
      firstName: data['first name'],
      lastName: data['last name'],
      email: data['email'],
      city: data['city'],
      phoneNum: data['phone number'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'city': city,
      'phone number': phoneNum,
    };
  }
}
