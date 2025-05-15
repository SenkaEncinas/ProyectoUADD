class UserRegisterDto {
  final String email;
  final String password;
  final int role; // 0 = User, 1 = Admin

  UserRegisterDto({
    required this.email,
    required this.password,
    required this.role,
  });

  factory UserRegisterDto.fromJson(Map<String, dynamic> json) =>
      UserRegisterDto(
        email: json['email'],
        password: json['password'],
        role: json['role'],
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'role': role,
      };
}
