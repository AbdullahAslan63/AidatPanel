import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/building_entity.dart';

/// Yöneticinin binalarını tutan in-memory store.
/// Üretim ortamında bu liste backend'den (GET /api/buildings) çekilecek.
class BuildingsStore extends StateNotifier<List<BuildingEntity>> {
  BuildingsStore() : super(_initialBuildings());

  static List<BuildingEntity> _initialBuildings() {
    return [
      BuildingEntity(
        id: '1',
        name: 'Güneş Apartmanı',
        address: 'Atatürk Cad. No: 45, Beşiktaş, İstanbul',
        totalApartments: 12,
        occupiedApartments: 11,
        totalMonthlyDues: 12000,
        collectedDues: 10500,
      ),
      BuildingEntity(
        id: '2',
        name: 'Mavi Gözler Sitesi',
        address: 'Cumhuriyet Cad. No: 78, Taksim, İstanbul',
        totalApartments: 24,
        occupiedApartments: 22,
        totalMonthlyDues: 24000,
        collectedDues: 21600,
      ),
      BuildingEntity(
        id: '3',
        name: 'Yeşil Vadi Konutları',
        address: 'Bağdat Cad. No: 123, Kadıköy, İstanbul',
        totalApartments: 18,
        occupiedApartments: 16,
        totalMonthlyDues: 18000,
        collectedDues: 16200,
      ),
    ];
  }

  /// Yeni bina ekler ve oluşturulan binanın ID'sini döndürür.
  /// Backend bağlanınca POST /api/buildings çağrısına dönüşecek.
  String addBuilding({
    required String name,
    required String address,
    int totalApartments = 0,
    double monthlyDuesPerApartment = 0,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newBuilding = BuildingEntity(
      id: id,
      name: name,
      address: address,
      totalApartments: totalApartments,
      occupiedApartments: 0,
      totalMonthlyDues: totalApartments * monthlyDuesPerApartment,
      collectedDues: 0,
    );
    state = [...state, newBuilding];
    return id;
  }
}

final buildingsStoreProvider =
    StateNotifierProvider<BuildingsStore, List<BuildingEntity>>(
      (ref) => BuildingsStore(),
    );
