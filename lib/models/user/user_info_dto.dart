class UserInfoDto {
  final int id;
  final String email;
  final int role; // 0 = User, 1 = Admin

  UserInfoDto({
    required this.id,
    required this.email,
    required this.role,
  });

  factory UserInfoDto.fromJson(Map<String, dynamic> json) => UserInfoDto(
        id: json['id'],
        email: json['email'],
        role: json['role'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'role': role,
      };
}
