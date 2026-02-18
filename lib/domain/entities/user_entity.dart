class UserEntity {
  final String id;
  final String email;
  final String? name;
  final int? age;
  final double? height;
  final double? weight;
  final String? gender;
  final int karmaTotal;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.age,
    this.height,
    this.weight,
    this.gender,
    this.karmaTotal = 0,
  });
}
