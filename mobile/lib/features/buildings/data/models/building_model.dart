import '../../domain/entities/building_entity.dart';

class BuildingModel {
  final String id;
  final String name;
  final String address;
  final String? city;
  final int? totalFloors;
  final int? apartmentsPerFloor;
  final String managerId;

  BuildingModel({
    required this.id,
    required this.name,
    required this.address,
    this.city,
    this.totalFloors,
    this.apartmentsPerFloor,
    required this.managerId,
  });

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String?,
      totalFloors: json['totalFloors'] as int?,
      apartmentsPerFloor: json['apartmentsPerFloor'] as int?,
      managerId: json['managerId'] as String,
    );
  }

  BuildingEntity toEntity() {
    final total = (totalFloors ?? 0) * (apartmentsPerFloor ?? 0);
    return BuildingEntity(
      id: id,
      name: name,
      address: city != null ? '$address, $city' : address,
      totalApartments: total,
      occupiedApartments: 0,
      totalMonthlyDues: 0.0,
      collectedDues: 0.0,
    );
  }
}
