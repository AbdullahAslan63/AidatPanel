import '../../domain/entities/apartment_entity.dart';

class ApartmentModel {
  final String id;
  final String number;
  final int? floor;
  final String buildingId;

  ApartmentModel({
    required this.id,
    required this.number,
    this.floor,
    required this.buildingId,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    return ApartmentModel(
      id: json['id'] as String,
      number: json['number'] as String,
      floor: json['floor'] as int?,
      buildingId: json['buildingId'] as String,
    );
  }

  ApartmentEntity toEntity() {
    return ApartmentEntity(
      id: id,
      buildingId: buildingId,
      apartmentNumber: number,
      residentName: 'Boş Daire',
      monthlyDues: 0.0,
      paymentStatus: PaymentStatus.pending,
      balance: 0.0,
    );
  }
}
