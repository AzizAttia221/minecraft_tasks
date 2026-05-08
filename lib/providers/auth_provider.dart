import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user_account.dart';

class AuthProvider with ChangeNotifier {
  String? _currentUser;
  final Box<UserAccount> _accounts = Hive.box<UserAccount>('accounts');
  final Box<String> _session = Hive.box<String>('session');

  AuthProvider() {
    final storedUser = _session.get('currentUser');
    if (storedUser != null && _accounts.containsKey(storedUser)) {
      _currentUser = storedUser;
    } else {
      _session.delete('currentUser');
    }
  }

  String? get currentUser => _currentUser;

  Map<String, String>? get currentUserProfile {
    final user = _currentUser == null ? null : _accounts.get(_currentUser!);
    return user == null
        ? null
        : {
            'fullName': user.fullName,
            'email': user.email,
            'phoneNumber': user.phoneNumber,
          };
  }

  String get currentUserDisplayName =>
      currentUserProfile?['fullName'] ?? _currentUser ?? 'Player';
  bool get isAuthenticated => _currentUser != null;

  bool login(String username, String password) {
    final user = _accounts.get(username);
    if (user != null && user.password == password) {
      _currentUser = username;
      _session.put('currentUser', username);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool register(String username, String fullName, String email, String phoneNumber, String password) {
    if (_accounts.containsKey(username)) {
      return false;
    }

    _accounts.put(
      username,
      UserAccount(
        username: username,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      ),
    );
    return true;
  }

  void logout() {
    _currentUser = null;
    _session.delete('currentUser');
    notifyListeners();
  }
}