class User {
  final String firstName;
  final String lastName;
  final List<String> addr;
  final bool admin;

  const User({
    required this.firstName,
    required this.lastName,
    required this.addr,
    required this.admin,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'admin': admin,
      'addr': addr,
    };
  }

  static fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'].toString(),
      lastName: json['lastName'].toString(),
      addr: (json['addr'] as List).map((e) => e.toString()).toList(),
      admin: json['admin'].toString() == 'true',
    );
  }
}
