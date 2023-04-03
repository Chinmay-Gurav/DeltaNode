class User {
  final String firstName;
  final String lastName;
  final String id;
  // final List<String> address;
  final bool admin;

  const User({
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.admin,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'admin': admin,
    };
  }

  static fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'].toString(),
      lastName: json['lastName'].toString(),
      id: json['id'].toString(),
      admin: json['admin'].toString() == 'true',
    );
  }
}
