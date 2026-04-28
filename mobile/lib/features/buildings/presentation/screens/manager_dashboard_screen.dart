import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/building_entity.dart';

class ManagerDashboardScreen extends ConsumerWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildings = _getDummyBuildings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yönetici Paneli'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hoş Geldiniz, Furkan Kaya',
              style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSizes.spacingL),
            _buildStatsRow(context),
            const SizedBox(height: AppSizes.spacingL),
            Text(
              'Yönetilen Binalar',
              style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSizes.spacingM),
            ..._buildBuildingCards(buildings),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Binalar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Aidatlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Navigation will be implemented later
        },
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Toplam Daire',
            value: '24',
            icon: Icons.apartment_outlined,
          ),
        ),
        const SizedBox(width: AppSizes.spacingM),
        Expanded(
          child: _buildStatCard(
            title: 'Dolu Daire',
            value: '22',
            icon: Icons.check_circle_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacingM),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: AppSizes.spacingS),
          Text(
            value,
            style: AppTypography.h2.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSizes.spacingXS),
          Text(
            title,
            style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBuildingCards(List<BuildingEntity> buildings) {
    return buildings
        .map(
          (building) => Container(
            margin: const EdgeInsets.only(bottom: AppSizes.spacingM),
            padding: const EdgeInsets.all(AppSizes.spacingM),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            building.name,
                            style: AppTypography.h3
                                .copyWith(color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: AppSizes.spacingXS),
                          Text(
                            building.address,
                            style: AppTypography.body2
                                .copyWith(color: AppColors.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        // Navigate to building details
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacingM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBuildingInfo(
                      label: 'Daireler',
                      value: '${building.occupiedApartments}/${building.totalApartments}',
                    ),
                    _buildBuildingInfo(
                      label: 'Aidat Tahsilatı',
                      value: '${building.collectionRate.toStringAsFixed(1)}%',
                    ),
                    _buildBuildingInfo(
                      label: 'Toplam Aidat',
                      value: '₺${building.totalMonthlyDues.toStringAsFixed(0)}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildBuildingInfo({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: AppTypography.h4.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSizes.spacingXS),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  List<BuildingEntity> _getDummyBuildings() {
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
}
