// lib/auth_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visionary_project/constants.dart';
import 'package:visionary_project/core/vision_provider.dart';

/// A screen that handles user authentication
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

/// State class for AuthScreen
class _AuthScreenState extends ConsumerState<AuthScreen> {
  /// initState() is called after the widget is built for the first time
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // read the authProvider.notifier and call the checkLoginStatus() method
      ref.read(authProvider.notifier).checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    // The ref.listen() method is used to listen to changes in the state of a provider.
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isLoggedIn) {
        // replace the current screen with the VisionBoardScreen
        Navigator.pushReplacementNamed(context, Constants.boardScreen);
      } else if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'An error occurred'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              Constants.appTitle,
              style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              // read the authProvider.notifier and call the signIn() method
              onPressed: () => ref.read(authProvider.notifier).signIn(),
              icon: const Icon(FontAwesomeIcons.google),
              label: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
