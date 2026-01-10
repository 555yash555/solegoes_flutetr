import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_repository.g.dart';

/// Repository to manage onboarding completion state
class OnboardingRepository {
  static const String _onboardingCompleteKey = 'onboarding_complete';

  final SharedPreferences _prefs;

  OnboardingRepository(this._prefs);

  /// Check if onboarding has been completed
  bool get isOnboardingComplete {
    return _prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  /// Mark onboarding as complete
  Future<void> completeOnboarding() async {
    await _prefs.setBool(_onboardingCompleteKey, true);
  }

  /// Reset onboarding (for testing)
  Future<void> resetOnboarding() async {
    await _prefs.remove(_onboardingCompleteKey);
  }
}

/// Provider for SharedPreferences instance
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return await SharedPreferences.getInstance();
}

/// Provider for OnboardingRepository
@Riverpod(keepAlive: true)
Future<OnboardingRepository> onboardingRepository(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return OnboardingRepository(prefs);
}

/// Provider to check if onboarding is complete (sync access after init)
@Riverpod(keepAlive: true)
Future<bool> isOnboardingComplete(Ref ref) async {
  final repo = await ref.watch(onboardingRepositoryProvider.future);
  return repo.isOnboardingComplete;
}
