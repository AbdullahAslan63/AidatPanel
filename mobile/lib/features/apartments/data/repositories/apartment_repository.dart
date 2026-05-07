import '../../domain/entities/apartment_entity.dart';

abstract class ApartmentRepository {
  Future<List<ApartmentEntity>> fetchApartments(String buildingId);
  Future<ApartmentEntity> createApartment({
    required String buildingId,
    required String number,
    int? floor,
  });
  Future<ApartmentEntity> updateApartment({
    required String buildingId,
    required String id,
    String? number,
    int? floor,
  });
  Future<void> deleteApartment({
    required String buildingId,
    required String id,
  });
}
