import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/interfaces/i_prayer_repository.dart';
import '../../data/repositories/interfaces/i_requester_repository.dart';
import '../../data/repositories/impl/prayer_repository_impl.dart';
import '../../data/repositories/impl/requester_repository_impl.dart';
import 'providers.dart';

/// Prayer Repository Provider
final prayerRepositoryProvider = Provider<IPrayerRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return PrayerRepositoryImpl(supabaseService);
});

/// Requester Repository Provider
final requesterRepositoryProvider = Provider<IRequesterRepository>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return RequesterRepositoryImpl(supabaseService);
});
