import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../agency/domain/agency.dart';
import '../domain/app_user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  // Only instantiated on mobile — web uses signInWithPopup instead
  final GoogleSignIn? _googleSignIn;

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
  // GOOGLE SIGN-IN
  // Web  → FirebaseAuth.signInWithPopup (no google_sign_in needed)
  // Mobile → google_sign_in package (existing flow)
  // ===========================================

  Future<AppUser> signInWithGoogle() async {
    final UserCredential userCredential;

    if (kIsWeb) {
      // ── Web: popup-based OAuth flow via Firebase JS SDK ──
      final googleProvider = GoogleAuthProvider()
        ..addScope('email')
        ..addScope('profile');
      userCredential =
          await _firebaseAuth.signInWithPopup(googleProvider);
    } else {
      // ── Mobile: google_sign_in package flow ──
      // _googleSignIn is guaranteed non-null on mobile (see provider factory)
      final googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _firebaseAuth.signInWithCredential(credential);
    }

    final user = userCredential.user!;

    // Check if user already exists in Firestore
    final existingUser = await _getUserFromFirestore(user.uid);
    if (existingUser != null) return existingUser;

    // New user — create profile
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
        // Role-based access — defaults to 'consumer' when field missing
        role: data['role'] ?? 'consumer',
        agencyId: data['agencyId'],
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
      'role': user.role,
      if (user.agencyId != null) 'agencyId': user.agencyId,
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
  // AGENCY REGISTRATION
  // ===========================================

  /// Creates the agency Firestore doc and updates the user's role + agencyId.
  /// Called at the end of AgencySignupScreen (Step 3 submit).
  Future<void> registerAgency({
    required Agency agency,
    required String uid,
  }) async {
    // 1. Write agency doc
    await _firestore.collection('agencies').doc(agency.agencyId).set({
      ...agency.toJson(),
      'agencyId': agency.agencyId,
      'ownerUid': uid,
      'verificationStatus': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2. Update user doc: role → 'agency', agencyId
    await _firestore.collection('users').doc(uid).set({
      'role': 'agency',
      'agencyId': agency.agencyId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ===========================================
  // PASSWORD RESET
  // ===========================================

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // ===========================================
  // SIGN OUT
  // ===========================================

  Future<void> signOut() async {
    await _googleSignIn?.signOut();
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
    // Only create GoogleSignIn on mobile — web crashes if instantiated without clientId in meta tag
    kIsWeb ? null : GoogleSignIn(),
  );
}

@riverpod
Stream<AppUser?> authStateChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
