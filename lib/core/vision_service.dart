// shared/vision_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:visionary_project/constants.dart';
import 'package:visionary_project/core/vision_item.dart';

/// Enum representing the result of an authentication operation
enum AuthResult {
  success,
  failure,
  unknownError,
}

/// Enum representing the result of a vision operation
enum VisionResult {
  success,
  failure,
}

/// Service class for interacting with Firebase
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Gets the collection reference for vision items
  CollectionReference get visionCollection =>
      _firestore.collection(Constants.visionItemsCollection);

  /// Checks if the user is logged in
  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  /// Signs in the user with Google authentication
  Future<AuthResult> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      await _auth.signInWithPopup(googleProvider);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: ${e.message}");
      return AuthResult.failure;
    } catch (e) {
      debugPrint("Unknown error: $e");
      return AuthResult.unknownError;
    }
  }

  /// Signs out the current user
  Future<AuthResult> signOut() async {
    try {
      await _auth.signOut();
      return AuthResult.success;
    } catch (e) {
      debugPrint("Error signing out: $e");
      return AuthResult.failure;
    }
  }

  /// Gets the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Adds a new vision item to the collection
  Future<void> addVisionItem(String itemText, String imageUrl) async {
    await visionCollection.add({
      Constants.itemTextField: itemText,
      Constants.imageUrlField: imageUrl,
      Constants.timestampField: FieldValue.serverTimestamp(),
    });
  }

  /// Updates an existing vision item in the collection
  Future<void> updateVisionItem(
      String documentId, String itemText, String imageUrl) async {
    await visionCollection.doc(documentId).update({
      Constants.itemTextField: itemText,
      Constants.imageUrlField: imageUrl,
    });
  }

  /// Deletes a vision item from the collection
  Future<void> deleteVisionItem(String documentId) async {
    await visionCollection.doc(documentId).delete();
  }

  /// Gets a stream of vision items from the collection
  Stream<List<VisionItem>> getVisionItems() {
    try {
      return visionCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return VisionItem(
            id: doc.id,
            itemText: doc[Constants.itemTextField],
            imageUrl: doc[Constants.imageUrlField],
          );
        }).toList();
      });
    } catch (e) {
      debugPrint("Error getting vision items: $e");
      return Stream.empty();
    }
  }
}
