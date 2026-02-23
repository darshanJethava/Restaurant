class User {
  String id;
  String username;
  String password;
  String user_role;
  String restaurantID;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.user_role,
    required this.restaurantID,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['UserID']?.toString() ?? json['id'] ?? '',
      username: json['UserName'] ?? json['username'] ?? '',
      password: json['Password'] ?? json['password'] ?? '',
      user_role: json['UserRole'] ?? json['user_role'] ?? '',
      restaurantID:
          json['RestaurantID']?.toString() ?? json['restaurantID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'UserID': id,
    'UserName': username,
    'Password': password,
    'UserRole': user_role,
    'RestaurantID': restaurantID,
  };
}

// This is a sample user data for testing purposes
