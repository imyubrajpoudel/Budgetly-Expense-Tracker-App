import 'package:hive/hive.dart';

const String authBoxName = 'auth_box';

class AuthRepository {
  AuthRepository(this.box);

  final Box<Map> box;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final key = email.trim().toLowerCase();
    if (box.containsKey(key)) return false;

    await box.put(key, {
      'name': name.trim(),
      'email': key,
      'password': password,
    });
    return true;
  }

  bool login({required String email, required String password}) {
    final key = email.trim().toLowerCase();
    final raw = box.get(key);
    if (raw == null) return false;
    return raw['password'] == password;
  }

  String? getUserName(String email) {
    final raw = box.get(email.trim().toLowerCase());
    return raw?['name'] as String?;
  }

  bool hasUsers() => box.isNotEmpty;
}
