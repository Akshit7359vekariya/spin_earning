import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawalModel {
  final String id;
  final String uid;
  final String upiId;
  final int amount;
  final String status; // pending, completed, rejected
  final DateTime requestDate;

  WithdrawalModel({
    required this.id,
    required this.uid,
    required this.upiId,
    required this.amount,
    required this.status,
    required this.requestDate,
  });

  factory WithdrawalModel.fromMap(Map<String, dynamic> map, String id) {
    return WithdrawalModel(
      id: id,
      uid: map['uid'] ?? '',
      upiId: map['upiId'] ?? '',
      amount: map['amount'] ?? 0,
      status: map['status'] ?? 'pending',
      requestDate: (map['requestDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'upiId': upiId,
      'amount': amount,
      'status': status,
      'requestDate': Timestamp.fromDate(requestDate),
    };
  }
}