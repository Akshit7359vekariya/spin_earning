import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/withdrawal_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userModel;
  bool _isLoading = false;

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;

  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        _userModel = UserModel.fromMap(userDoc.data()!);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error loading user data: $e');
    }
  }

  Future<bool> spinWheel() async {
    final user = _auth.currentUser;
    if (user == null || _userModel == null) return false;

    try {
      final now = DateTime.now();
      final lastSpinDate = _userModel!.lastSpinDate;

      // Check if it's a new day
      bool isNewDay = lastSpinDate == null ||
          lastSpinDate.day != now.day ||
          lastSpinDate.month != now.month ||
          lastSpinDate.year != now.year;

      int spinsToday = isNewDay ? 0 : _userModel!.spinsToday;

      if (spinsToday >= 5) {
        return false; // Max spins reached
      }

      // Generate random points (10, 25, 50, 100)
      final rewards = [10, 25, 50, 100];
      final randomPoints = rewards[now.millisecond % rewards.length];

      await _firestore.collection('users').doc(user.uid).update({
        'points': FieldValue.increment(randomPoints),
        'totalEarnings': FieldValue.increment(randomPoints),
        'todayEarning': FieldValue.increment(randomPoints),
        'spinsToday': spinsToday + 1,
        'lastSpinDate': Timestamp.fromDate(now),
      });

      // Reload user data
      await loadUserData();
      return true;
    } catch (e) {
      print('Error spinning wheel: $e');
      return false;
    }
  }

  Future<bool> updateUpiId(String upiId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'upiId': upiId,
      });

      if (_userModel != null) {
        _userModel = _userModel!.copyWith(upiId: upiId);
        notifyListeners();
      }

      return true;
    } catch (e) {
      print('Error updating UPI ID: $e');
      return false;
    }
  }

  Future<bool> submitWithdrawalRequest(int amount) async {
    final user = _auth.currentUser;
    if (user == null || _userModel == null) return false;

    if (_userModel!.points < amount * 1000) {
      return false; // Insufficient balance
    }

    try {
      final withdrawal = WithdrawalModel(
        id: '',
        uid: user.uid,
        upiId: _userModel!.upiId,
        amount: amount,
        status: 'pending',
        requestDate: DateTime.now(),
      );

      await _firestore.collection('withdrawalrequest').add(withdrawal.toMap());

      // Deduct points
      await _firestore.collection('users').doc(user.uid).update({
        'points': FieldValue.increment(-amount * 1000),
      });

      await loadUserData();
      return true;
    } catch (e) {
      print('Error submitting withdrawal request: $e');
      return false;
    }
  }

  Future<bool> applyReferralCode(String referralCode) async {
    final user = _auth.currentUser;
    if (user == null || _userModel == null) return false;

    if (_userModel!.referredBy != null) {
      return false; // Already used a referral code
    }

    try {
      // Check if referral code exists
      final referralDoc = await _firestore.collection('referralcodes').doc(referralCode).get();
      if (!referralDoc.exists) {
        return false; // Invalid referral code
      }

      final referrerUid = referralDoc.data()!['uid'] as String;
      if (referrerUid == user.uid) {
        return false; // Cannot refer yourself
      }

      // Update current user
      await _firestore.collection('users').doc(user.uid).update({
        'referredBy': referralCode,
        'points': FieldValue.increment(2000), // ₹2 = 2000 points
        'totalEarnings': FieldValue.increment(2000),
      });

      // Update referrer
      await _firestore.collection('users').doc(referrerUid).update({
        'points': FieldValue.increment(2000), // ₹2 = 2000 points
        'totalEarnings': FieldValue.increment(2000),
      });

      await loadUserData();
      return true;
    } catch (e) {
      print('Error applying referral code: $e');
      return false;
    }
  }

  int getRemainingSpins() {
    if (_userModel == null) return 0;

    final now = DateTime.now();
    final lastSpinDate = _userModel!.lastSpinDate;

    // Check if it's a new day
    bool isNewDay = lastSpinDate == null ||
        lastSpinDate.day != now.day ||
        lastSpinDate.month != now.month ||
        lastSpinDate.year != now.year;

    if (isNewDay) return 5;

    return 5 - _userModel!.spinsToday;
  }
}