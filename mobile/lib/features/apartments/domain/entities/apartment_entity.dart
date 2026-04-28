import 'package:equatable/equatable.dart';

enum PaymentStatus { paid, pending, overdue }

class ApartmentEntity extends Equatable {
  final String id;
  final String buildingId;
  final String apartmentNumber;
  final String residentName;
  final String? phone;
  final double monthlyDues;
  final PaymentStatus paymentStatus;
  final DateTime? lastPaymentDate;
  final double balance;

  const ApartmentEntity({
    required this.id,
    required this.buildingId,
    required this.apartmentNumber,
    required this.residentName,
    this.phone,
    required this.monthlyDues,
    required this.paymentStatus,
    this.lastPaymentDate,
    required this.balance,
  });

  @override
  List<Object?> get props => [
        id,
        buildingId,
        apartmentNumber,
        residentName,
        phone,
        monthlyDues,
        paymentStatus,
        lastPaymentDate,
        balance,
      ];
}
