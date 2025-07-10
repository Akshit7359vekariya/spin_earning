import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> applyActionCode(String code) async {
    try {
      await _auth.applyActionCode(code);
      // You can optionally call a callback or show a snackbar in UI instead of print.
      // Example: logger.i('Action code applied successfully!');
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase auth errors gracefully
      throw Exception('FirebaseAuth error: ${e.message}');
    } catch (e) {
      // Handle other unexpected errors
      throw Exception('Unexpected error applying action code: $e');
    }
  }
}
