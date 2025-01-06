class UserPreferences {
  String name = 'User';
  final String gender;
  final bool enableNotifications;

  UserPreferences({
    required this.name,
    required this.gender,
    required this.enableNotifications,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'gender': gender,
    'enableNotifications': enableNotifications,
  };

  factory UserPreferences.fromJson(Map<String, dynamic> json) => UserPreferences(
    name: json['name'] as String,
    gender: json['gender'] as String,
    enableNotifications: json['enableNotifications'] as bool,
  );
}