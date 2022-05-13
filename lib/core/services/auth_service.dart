import 'package:network_calls_with_repository_pattern/core/models/user.dart';

class AuthService {
  ///Making the Auth Service class a Singleton
  AuthService._();
  static final AuthService _instance = AuthService._();
  static AuthService get instance => _instance;

  User? _currentUser;
  User? get currentUser => _currentUser;
}
