// shared/vision_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visionary_project/core/vision_item.dart';
import 'package:visionary_project/core/vision_service.dart';

/// Provides an instance of FirebaseService
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

/// Provides an instance of AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return AuthNotifier(firebaseService);
});

/// Represents the authentication state
class AuthState {
  final bool isLoggedIn;
  final String? errorMessage;

  AuthState({required this.isLoggedIn, this.errorMessage});
}

/// Manages the authentication state and provides methods to update it
class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseService _firebaseService;

  AuthNotifier(this._firebaseService) : super(AuthState(isLoggedIn: false));

  /// Checks the login status and updates the state
  Future<void> checkLoginStatus() async {
    state = AuthState(isLoggedIn: await _firebaseService.isLoggedIn());
  }

  /// Signs in the user using Google authentication and updates the state
  Future<void> signIn() async {
    final result = await _firebaseService.signInWithGoogle();
    if (result == AuthResult.success) {
      state = AuthState(isLoggedIn: true);
    } else {
      state = AuthState(isLoggedIn: false, errorMessage: 'Sign in failed');
    }
  }

  /// Signs out the user and updates the state
  Future<void> signOut() async {
    final result = await _firebaseService.signOut();
    if (result == AuthResult.success) {
      state = AuthState(isLoggedIn: false);
    } else {
      state = AuthState(isLoggedIn: true, errorMessage: 'Sign out failed');
    }
  }
}

/// Manages the state of vision items and provides methods to update it
class VisionItemsNotifier extends StateNotifier<List<VisionItem>> {
  final FirebaseService firebaseService;

  VisionItemsNotifier(this.firebaseService) : super([]);

  /// Adds or updates a vision item
  Future<void> addOrUpdateItem(
    String itemText,
    String imageUrl,
    VisionItem? visionItem,
  ) async {
    if (visionItem == null) {
      await firebaseService.addVisionItem(
        itemText,
        imageUrl,
      );
    } else {
      await firebaseService.updateVisionItem(
        visionItem.id,
        itemText,
        imageUrl,
      );
    }
  }

  /// Deletes a vision item by its ID
  Future<void> deleteItem(String id) async {
    await firebaseService.deleteVisionItem(id);
    state = state.where((item) => item.id != id).toList();
  }
}

/// Provides a stream of vision items
final visionItemsProvider = StreamProvider<List<VisionItem>>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return firebaseService.getVisionItems();
});

/// Provides an instance of VisionItemsNotifier
final visionItemsNotifierProvider =
    StateNotifierProvider<VisionItemsNotifier, List<VisionItem>>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return VisionItemsNotifier(firebaseService);
});
