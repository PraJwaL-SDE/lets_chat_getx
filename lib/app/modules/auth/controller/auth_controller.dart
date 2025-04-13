import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lest_chat_5/app/data/provider/auth/auth_provider.dart';
import 'package:lest_chat_5/app/data/provider/message/message_provider.dart';
import 'package:lest_chat_5/app/modules/shell/view/bottom_nav_screen.dart';

class AuthController extends GetxController {
  final AuthProvider authProvider = AuthProvider();
  final MessageProvider messageProvider = MessageProvider();

  final List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _currentUser;

  @override
  void onInit() {
    super.onInit();

    _googleSignIn = GoogleSignIn(
      scopes: scopes,
      clientId: kIsWeb
          ? '552335551456-qk7gj7ru0nfps3snmp6eb4jtbru3qbg2.apps.googleusercontent.com'
          : null,
    );

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      if (account != null) {
        _currentUser = account;
        await _afterSignIn(account);
      }
    });

    // Handle silent sign-in carefully
    _attemptSilentSignIn();
  }

  Future<void> _attemptSilentSignIn() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        _currentUser = account;
        await _afterSignIn(account);
      }
    } catch (e) {
      debugPrint("Silent sign-in failed: $e");
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        Get.snackbar("Sign In Cancelled", "User cancelled sign in");
        return;
      }
      await _afterSignIn(account);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _afterSignIn(GoogleSignInAccount? account) async {
    if (account == null) {
      Get.snackbar("Error", "Google sign-in account is null");
      return;
    }

    try {
      final String email = account.email;
      final String googleId = account.id;
      final String fullName = account.displayName ?? "No Name";
      final String avatar = account.photoUrl ?? "";
      final String deviceToken = "sample_token"; // Replace with actual device token logic

      final userModel = await authProvider.updateUserDetail(
        email,
        googleId,
        avatar,
        fullName,
        deviceToken,
      );

      if (userModel != null) {
        Get.to(() => BottomNavigationView(userModel: userModel));
      } else {
        Get.snackbar("Server Error", "Failed to login");
      }
    } catch (e) {
      print(e);
      // Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
      _currentUser = null;
      Get.snackbar("Signed Out", "You have been signed out");
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
