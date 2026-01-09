class AppUser {
  String? username;
  String? accessToken;
  String? refreshToken;

  AppUser({
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  });

  AppUser.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppUser &&
        other.username == username &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode =>
      username.hashCode ^ accessToken.hashCode ^ refreshToken.hashCode;

  @override
  String toString() =>
      'AppUser(username: $username, accessToken: $accessToken,refreshToken: $refreshToken)';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    return data;
  }

  AppUser copyWith({
    String? username,
    String? accessToken,
    String? refreshToken,
  }) {
    return AppUser(
      username: username ?? this.username,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
