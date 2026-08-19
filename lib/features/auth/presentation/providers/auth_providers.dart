import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/auth_repository.dart';

final authBoxProvider = Provider<Box<Map>>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(authBoxProvider));
});
