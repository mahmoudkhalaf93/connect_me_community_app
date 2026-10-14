import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String fullName, String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signIn(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userDoc = await firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      return UserModel.fromJson(userDoc.data()!);
    } else {
      // Fallback if document doesn't exist but auth succeeded
      final user = UserBuilder()
          .setId(userCredential.user!.uid)
          .setFullName(userCredential.user!.displayName ?? 'Unknown')
          .setEmail(userCredential.user!.email ?? email)
          .build();
      return user;
    }
  }

  @override
  Future<UserModel> signUp(
    String fullName,
    String email,
    String password,
  ) async {
    UserCredential? userCredential;
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Apply the Builder Pattern to construct the User model
      final newUser = UserBuilder()
          .setId(userCredential.user!.uid)
          .setFullName(fullName)
          .setEmail(email)
          .build();

      // Save user to Firestore
      await firestore.collection('users').doc(newUser.id).set(newUser.toJson());

      return newUser;
    } catch (e) {
      // If Firestore save fails (like permission denied), rollback the Auth user creation
      if (userCredential != null && userCredential.user != null) {
        try {
          await userCredential.user!.delete();
        } catch (deleteError) {
          // Log rollback error if needed, but primary focus is throwing the original error
          print('Rollback failed: $deleteError');
        }
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      final userDoc = await firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists && userDoc.data() != null) {
        return UserModel.fromJson(userDoc.data()!);
      }
    }
    return null;
  }
}
