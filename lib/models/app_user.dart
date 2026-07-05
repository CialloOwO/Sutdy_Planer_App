class AppUser {
  int? id;
  String fullName;
  String email;
  String password;
  String programme;
  String year;

  AppUser({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.programme = 'Software Engineering',
    this.year = 'Year 3',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'programme': programme,
      'year': year,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as int?,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      programme: map['programme'] as String? ?? 'Software Engineering',
      year: map['year'] as String? ?? 'Year 3',
    );
  }
}
