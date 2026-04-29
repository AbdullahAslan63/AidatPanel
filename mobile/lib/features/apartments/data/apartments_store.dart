import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/apartment_entity.dart';

/// Bina başına daireleri tutan in-memory store.
/// Üretim ortamında bu veri backend'den (GET /api/buildings/:id/apartments) çekilecek.
/// `Map<buildingId, List<ApartmentEntity>>`
class ApartmentsStore
    extends StateNotifier<Map<String, List<ApartmentEntity>>> {
  ApartmentsStore() : super(_initialApartments());

  static Map<String, List<ApartmentEntity>> _initialApartments() {
    return {
      '1': [
        ApartmentEntity(
          id: '1-1',
          buildingId: '1',
          apartmentNumber: '1A',
          residentName: 'Ahmet Yılmaz',
          phone: '+905551112233',
          monthlyDues: 1000,
          paymentStatus: PaymentStatus.paid,
          balance: 0,
        ),
        ApartmentEntity(
          id: '1-2',
          buildingId: '1',
          apartmentNumber: '1B',
          residentName: 'Fatma Demir',
          phone: '+905552223344',
          monthlyDues: 1000,
          paymentStatus: PaymentStatus.pending,
          balance: 1000,
        ),
        ApartmentEntity(
          id: '1-3',
          buildingId: '1',
          apartmentNumber: '2A',
          residentName: 'Mehmet Öztürk',
          phone: '+905553334455',
          monthlyDues: 1000,
          paymentStatus: PaymentStatus.overdue,
          balance: 3000,
        ),
        ApartmentEntity(
          id: '1-4',
          buildingId: '1',
          apartmentNumber: '2B',
          residentName: 'Ayşe Kaya',
          phone: '+905554445566',
          monthlyDues: 1000,
          paymentStatus: PaymentStatus.paid,
          balance: 0,
        ),
        ApartmentEntity(
          id: '1-5',
          buildingId: '1',
          apartmentNumber: '3A',
          residentName: 'Boş Daire',
          monthlyDues: 1000,
          paymentStatus: PaymentStatus.pending,
          balance: 0,
        ),
      ],
      '2': [
        ApartmentEntity(
          id: '2-1',
          buildingId: '2',
          apartmentNumber: '1A',
          residentName: 'Ali Veli',
          phone: '+905555556677',
          monthlyDues: 1500,
          paymentStatus: PaymentStatus.paid,
          balance: 0,
        ),
        ApartmentEntity(
          id: '2-2',
          buildingId: '2',
          apartmentNumber: '1B',
          residentName: 'Zeynep Aydın',
          phone: '+905556667788',
          monthlyDues: 1500,
          paymentStatus: PaymentStatus.pending,
          balance: 1500,
        ),
      ],
      '3': [
        ApartmentEntity(
          id: '3-1',
          buildingId: '3',
          apartmentNumber: '1A',
          residentName: 'Hasan Çelik',
          phone: '+905557778899',
          monthlyDues: 1200,
          paymentStatus: PaymentStatus.paid,
          balance: 0,
        ),
        ApartmentEntity(
          id: '3-2',
          buildingId: '3',
          apartmentNumber: '1B',
          residentName: 'Boş Daire',
          monthlyDues: 1200,
          paymentStatus: PaymentStatus.pending,
          balance: 0,
        ),
      ],
    };
  }

  List<ApartmentEntity> apartmentsFor(String buildingId) {
    return state[buildingId] ?? const [];
  }

  /// Yeni bina için otomatik daire üret.
  /// [floors] = kat sayısı, [apartmentsPerFloor] = her kattaki daire sayısı.
  /// Daireler A, B, C, ... harflerle isimlendirilir (örn: 1A, 1B, 2A, 2B).
  void generateApartmentsForBuilding({
    required String buildingId,
    required int floors,
    required int apartmentsPerFloor,
    required double monthlyDues,
  }) {
    if (floors <= 0 || apartmentsPerFloor <= 0) {
      state = {...state, buildingId: const []};
      return;
    }
    const allLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final apartments = <ApartmentEntity>[];
    int counter = 1;
    for (int floor = 1; floor <= floors; floor++) {
      for (int i = 0; i < apartmentsPerFloor; i++) {
        final letter = i < allLetters.length
            ? allLetters[i]
            : '${i + 1}'; // 26'dan fazla daire varsa sayıya geç
        apartments.add(
          ApartmentEntity(
            id: '$buildingId-$counter',
            buildingId: buildingId,
            apartmentNumber: '$floor$letter',
            residentName: 'Boş Daire',
            monthlyDues: monthlyDues,
            paymentStatus: PaymentStatus.pending,
            balance: 0,
          ),
        );
        counter++;
      }
    }
    state = {...state, buildingId: apartments};
  }
}

final apartmentsStoreProvider =
    StateNotifierProvider<ApartmentsStore, Map<String, List<ApartmentEntity>>>(
      (ref) => ApartmentsStore(),
    );
