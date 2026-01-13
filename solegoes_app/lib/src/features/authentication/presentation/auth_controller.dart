import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_repository.dart';
import '../domain/app_user.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }

  // ===========================================
  // EMAIL/PASSWORD AUTH
  // ===========================================

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
        email,
        password,
      );
    });
    return !state.hasError;
  }

  Future<bool> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    String? phoneNumber,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
        phoneNumber: phoneNumber,
      );
    });
    return !state.hasError;
  }

  // ===========================================
  // GOOGLE SIGN-IN
  // ===========================================

  Future<AppUser?> signInWithGoogle() async {
    state = const AsyncLoading();
    AppUser? user;
    state = await AsyncValue.guard(() async {
      user = await ref.read(authRepositoryProvider).signInWithGoogle();
    });
    return state.hasError ? null : user;
  }

  // ===========================================
  // PROFILE UPDATES
  // ===========================================

  Future<bool> updatePhoneNumber(String phoneNumber) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).updatePhoneNumber(phoneNumber);
    });
    return !state.hasError;
  }

  Future<bool> updateProfile({
    String? bio,
    String? city,
    String? gender,
    DateTime? birthDate,
    List<String>? personalityTraits,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).updateProfile(
        bio: bio,
        city: city,
        gender: gender,
        birthDate: birthDate,
        personalityTraits: personalityTraits,
      );
    });
    return !state.hasError;
  }

  Future<bool> updatePreferences({
    required List<String> interests,
    required String budgetRange,
    required String travelStyle,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).updatePreferences(
        interests: interests,
        budgetRange: budgetRange,
        travelStyle: travelStyle,
      );
    });
    return !state.hasError;
  }

  // ===========================================
  // SIGN OUT
  // ===========================================

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
    });
  }
}
