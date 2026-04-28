import 'package:equatable/equatable.dart';

class BuildingEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final int totalApartments;
  final int occupiedApartments;
  final double totalMonthlyDues;
  final double collectedDues;

  const BuildingEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.totalApartments,
    required this.occupiedApartments,
    required this.totalMonthlyDues,
    required this.collectedDues,
  });

  double get collectionRate {
    if (totalMonthlyDues == 0) return 0;
    return (collectedDues / totalMonthlyDues) * 100;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        totalApartments,
        occupiedApartments,
        totalMonthlyDues,
        collectedDues,
      ];
}
