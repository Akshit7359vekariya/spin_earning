import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/referral_code_generator.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email'],);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;

      if (_user != null) {
        await _createOrUpdateUser(_user!);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error signing in with Google: $e');
      return false;
    }
  }

  Future<void> _createOrUpdateUser(User user) async {
    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // Create new user
        final referralCode = ReferralCodeGenerator.generateReferralCode();

        final userModel = UserModel(
          uid: user.uid,
          name: user.displayName ?? 'User',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          walletBalance: 0.0,
          referralCode: referralCode,
          points: 0,
          totalEarnings: 0,
          todayEarning: 0,
          myReferralCode: referralCode,
          upiId: '',
          lastLoginDate: DateTime.now(),
          spinsToday: 0,
        );

        await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

        // Store referral code mapping
        await _firestore.collection('referralcodes').doc(referralCode).set({
          'uid': user.uid,
        });
      } else {
        // Update last login date and check for daily bonus
        final userData = UserModel.fromMap(userDoc.data()!);
        final now = DateTime.now();
        final lastLogin = userData.lastLoginDate;

        if (lastLogin.day != now.day || lastLogin.month != now.month || lastLogin.year != now.year) {
          // Give daily bonus
          final dailyBonus = _generateDailyBonus();
          await _firestore.collection('users').doc(user.uid).update({
            'lastLoginDate': Timestamp.fromDate(now),
            'points': FieldValue.increment(dailyBonus),
            'totalEarnings': FieldValue.increment(dailyBonus),
            'todayEarning': dailyBonus,
          });
        }
      }
    } catch (e) {
      debugPrint('Error creating/updating user: $e');
    }
  }

  int _generateDailyBonus() {
    // Random bonus between ₹1-₹3 (1000-3000 points)
    return 1000 + (DateTime.now().millisecond % 2001);
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }
}