import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final int points;
  final int totalEarnings;
  final int todayEarning;
  final double walletBalance;
  final String referralCode;
  final String? referredBy;
  final String myReferralCode;
  final String upiId;
  final DateTime lastLoginDate;
  final int spinsToday;
  final DateTime? lastSpinDate;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.walletBalance,
    required this.referralCode,
    required this.points,
    required this.totalEarnings,
    required this.todayEarning,
    this.referredBy,
    required this.myReferralCode,
    required this.upiId,
    required this.lastLoginDate,
    required this.spinsToday,
    this.lastSpinDate,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      walletBalance: (map['walletBalance'] ?? 0).toDouble(),
      referralCode: map['referralCode'] ?? '',
      points: map['points'] ?? 0,
      totalEarnings: map['totalEarnings'] ?? 0,
      todayEarning: map['todayEarning'] ?? 0,
      referredBy: map['referredBy'],
      myReferralCode: map['myReferralCode'] ?? '',
      upiId: map['upiId'] ?? '',
      lastLoginDate: (map['lastLoginDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      spinsToday: map['spinsToday'] ?? 0,
      lastSpinDate: (map['lastSpinDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'walletBalance': walletBalance,
      'referralCode': referralCode,
      'points': points,
      'totalEarnings': totalEarnings,
      'todayEarning': todayEarning,
      'referredBy': referredBy,
      'myReferralCode': myReferralCode,
      'upiId': upiId,
      'lastLoginDate': Timestamp.fromDate(lastLoginDate),
      'spinsToday': spinsToday,
      'lastSpinDate': lastSpinDate != null ? Timestamp.fromDate(lastSpinDate!) : null,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    double? walletBalance,
    String? referralCode,
    int? points,
    int? totalEarnings,
    int? todayEarning,
    String? referredBy,
    String? myReferralCode,
    String? upiId,
    DateTime? lastLoginDate,
    int? spinsToday,
    DateTime? lastSpinDate,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      walletBalance: walletBalance ?? this.walletBalance,
      referralCode: referralCode ?? this.referralCode,
      points: points ?? this.points,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      todayEarning: todayEarning ?? this.todayEarning,
      referredBy: referredBy ?? this.referredBy,
      myReferralCode: myReferralCode ?? this.myReferralCode,
      upiId: upiId ?? this.upiId,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      spinsToday: spinsToday ?? this.spinsToday,
      lastSpinDate: lastSpinDate ?? this.lastSpinDate,
    );
  }
}