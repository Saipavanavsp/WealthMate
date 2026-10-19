import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({required this.id, required this.email, required this.name});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(id: json['id'] as String, email: json['email'] as String, name: json['name'] as String);
  }

  final String id;
  final String email;
  final String name;

  Map<String, Object?> toJson() => {'id': id, 'email': email, 'name': name};

  @override
  List<Object?> get props => [id, email, name];
}

/// A signed-in user. Demo sessions have no tokens and never talk to the server.
class Session extends Equatable {
  const Session({required this.user, this.accessToken, this.refreshToken, this.isDemo = false});

  const Session.demo()
    : user = const AppUser(id: 'demo', email: 'demo@wealthmate.app', name: 'Demo User'),
      accessToken = null,
      refreshToken = null,
      isDemo = true;

  final AppUser user;
  final String? accessToken;
  final String? refreshToken;
  final bool isDemo;

  bool get canSync => !isDemo && refreshToken != null;

  Session copyWith({String? accessToken, String? refreshToken}) {
    return Session(
      user: user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      isDemo: isDemo,
    );
  }

  @override
  List<Object?> get props => [user, accessToken, refreshToken, isDemo];
}
