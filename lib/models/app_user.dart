class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    this.phoneNumber,
    this.avatarUrl,
  });

  final String name;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;
}
