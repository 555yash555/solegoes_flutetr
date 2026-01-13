import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/app_user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository(this._firebaseAuth, this._firestore, this._googleSignIn);

  // ===========================================
  // AUTH STATE
  // ===========================================

  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      // Fetch full profile from Firestore
      return await getUserProfile(user.uid);
    });
  }

  User? get currentUser => _firebaseAuth.currentUser;

  // ===========================================
  // EMAIL/PASSWORD AUTH
  // ===========================================

  Future<AppUser> signInWithEmailAndPassword(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return await getUserProfile(credential.user!.uid);
  }

  Future<AppUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    String? phoneNumber,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;

    // Update display name in Firebase Auth
    await user.updateDisplayName(displayName);

    // Create user document in Firestore
    final appUser = AppUser(
      uid: user.uid,
      email: email,
      displayName: displayName,
      phoneNumber: phoneNumber,
      isEmailVerified: user.emailVerified,
      isProfileComplete: false,
      isPreferencesComplete: false,
    );

    await _saveUserToFirestore(appUser);
    return appUser;
  }

  // ===========================================
  // GOOGLE SIGN-IN (v6.x API)
  // ===========================================

  Future<AppUser> signInWithGoogle() async {
    // Trigger the Google Sign-In flow
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in was cancelled');
    }

    // Obtain the auth details from the request
    final googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user!;

    // Check if user exists in Firestore
    final existingUser = await _getUserFromFirestore(user.uid);
    if (existingUser != null) {
      return existingUser;
    }

    // New user - create profile
    final appUser = AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoUrl: user.photoURL,
      isEmailVerified: user.emailVerified,
      isProfileComplete: false,
      isPreferencesComplete: false,
    );

    await _saveUserToFirestore(appUser);
    return appUser;
  }

  // ===========================================
  // PROFILE MANAGEMENT
  // ===========================================

  Future<AppUser> getUserProfile(String uid) async {
    final user = await _getUserFromFirestore(uid);
    if (user != null) return user;

    // Fallback to Firebase Auth user
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null && firebaseUser.uid == uid) {
      return AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        photoUrl: firebaseUser.photoURL,
        isEmailVerified: firebaseUser.emailVerified,
      );
    }

    throw Exception('User not found');
  }

  Future<AppUser?> _getUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      return AppUser(
        uid: uid,
        email: data['email'] ?? '',
        displayName: data['displayName'] ?? '',
        photoUrl: data['photoUrl'],
        phoneNumber: data['phoneNumber'],
        bio: data['bio'],
        city: data['city'],
        gender: data['gender'],
        birthDate: data['birthDate'] != null
            ? (data['birthDate'] as Timestamp).toDate()
            : null,
        personalityTraits: List<String>.from(data['personalityTraits'] ?? []),
        interests: List<String>.from(data['interests'] ?? []),
        budgetRange: data['budgetRange'],
        travelStyle: data['travelStyle'],
        isEmailVerified: data['isEmailVerified'] ?? false,
        isProfileComplete: data['isProfileComplete'] ?? false,
        isPreferencesComplete: data['isPreferencesComplete'] ?? false,
      );
    } catch (e) {
      // Return null if we can't access Firestore (permission issues, network, etc.)
      return null;
    }
  }

  Future<void> _saveUserToFirestore(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'phoneNumber': user.phoneNumber,
      'bio': user.bio,
      'city': user.city,
      'gender': user.gender,
      'birthDate': user.birthDate != null
          ? Timestamp.fromDate(user.birthDate!)
          : null,
      'personalityTraits': user.personalityTraits,
      'interests': user.interests,
      'budgetRange': user.budgetRange,
      'travelStyle': user.travelStyle,
      'isEmailVerified': user.isEmailVerified,
      'isProfileComplete': user.isProfileComplete,
      'isPreferencesComplete': user.isPreferencesComplete,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updatePhoneNumber(String phoneNumber) async {
    final uid = currentUser?.uid;
    if (uid == null) throw Exception('Not authenticated');

    // Use set with merge to create document if it doesn't exist
    await _firestore.collection('users').doc(uid).set({
      'phoneNumber': phoneNumber,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateProfile({
    String? bio,
    String? city,
    String? gender,
    DateTime? birthDate,
    List<String>? personalityTraits,
  }) async {
    final uid = currentUser?.uid;
    if (uid == null) throw Exception('Not authenticated');

    // Use set with merge to create document if it doesn't exist
    await _firestore.collection('users').doc(uid).set({
      'bio': bio,
      'city': city,
      'gender': gender,
      'birthDate': birthDate != null ? Timestamp.fromDate(birthDate) : null,
      'personalityTraits': personalityTraits ?? [],
      'isProfileComplete': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updatePreferences({
    required List<String> interests,
    required String budgetRange,
    required String travelStyle,
  }) async {
    final uid = currentUser?.uid;
    if (uid == null) throw Exception('Not authenticated');

    // Use set with merge to create document if it doesn't exist
    await _firestore.collection('users').doc(uid).set({
      'interests': interests,
      'budgetRange': budgetRange,
      'travelStyle': travelStyle,
      'isPreferencesComplete': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ===========================================
  // SIGN OUT
  // ===========================================

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}

// ===========================================
// PROVIDERS
// ===========================================

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    GoogleSignIn(),
  );
}

@riverpod
Stream<AppUser?> authStateChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
