import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/settings_tab.dart';
import '../../../../shared/widgets/toast_overlay.dart';
import '../../domain/entities/building_entity.dart';
import '../../../apartments/domain/entities/apartment_entity.dart';

class ManagerDashboardScreen extends ConsumerStatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  ConsumerState<ManagerDashboardScreen> createState() =>
      _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends ConsumerState<ManagerDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yönetici Paneli'), centerTitle: true),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(),
          _buildBuildingsTab(),
          _buildDuesTab(),
          _buildSettingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Binalar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Aidatlar'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
        currentIndex: _tabController.index,
        onTap: (index) {
          setState(() {
            _tabController.animateTo(index);
          });
        },
      ),
    );
  }

  Widget _buildHomeTab() {
    final buildings = _getDummyBuildings();
    return SingleChildScrollView(
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
    );
  }

  Widget _buildBuildingsTab() {
    final buildings = _getDummyBuildings();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(toastProvider.notifier)
                        .show(
                          'Bina ekleme özelliği yakında',
                          type: ToastType.info,
                        );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Bina Ekle'),
                ),
              ),
              const SizedBox(width: AppSizes.spacingM),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showInviteCodeDialog();
                  },
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('Davet Kodu'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingL),
          Text(
            'Binalar',
            style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSizes.spacingM),
          ...buildings.map((building) {
            return GestureDetector(
              onTap: () {
                _showBuildingDetails(building);
              },
              child: Container(
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
                    Text(
                      building.name,
                      style: AppTypography.h4.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingS),
                    Text(
                      building.address,
                      style: AppTypography.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.spacingM),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${building.totalApartments} Daire',
                          style: AppTypography.body2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '%${building.collectionRate.toStringAsFixed(0)} Tahsilat',
                          style: AppTypography.body2.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showBuildingDetails(BuildingEntity building) {
    final apartments = _getDummyApartments(building.id);
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Bina Detayı'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  building.name,
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingS),
                Text(
                  building.address,
                  style: AppTypography.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Toplam Daire',
                          style: AppTypography.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingXS),
                        Text(
                          '${building.totalApartments}',
                          style: AppTypography.h2.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dolu Daire',
                          style: AppTypography.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingXS),
                        Text(
                          '${building.occupiedApartments}',
                          style: AppTypography.h2.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tahsilat',
                          style: AppTypography.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingXS),
                        Text(
                          '%${building.collectionRate.toStringAsFixed(0)}',
                          style: AppTypography.h2.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacingL),
                Text(
                  'Sakinler (${apartments.length})',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingM),
                ...apartments.map((apt) {
                  return Container(
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
                        Text(
                          'Daire ${apt.apartmentNumber}',
                          style: AppTypography.h4.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingXS),
                        Text(
                          apt.residentName,
                          style: AppTypography.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (apt.phone != null) ...[
                          const SizedBox(height: AppSizes.spacingXS),
                          Text(
                            apt.phone!,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInviteCodeDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Davet Kodu Oluştur'),
        content: const Text('Davet kodu özelliği yakında eklenecek'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  Widget _buildDuesTab() {
    return Center(
      child: Text(
        'Aidatlar Sekmesi',
        style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return const SettingsTab();
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
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: AppSizes.spacingS),
          Text(value, style: AppTypography.h2.copyWith(color: Colors.white)),
          const SizedBox(height: AppSizes.spacingXS),
          Text(
            title,
            style: AppTypography.body2.copyWith(color: Colors.white70),
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
                            style: AppTypography.h3.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSizes.spacingXS),
                          Text(
                            building.address,
                            style: AppTypography.body2.copyWith(
                              color: AppColors.textSecondary,
                            ),
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
                      value:
                          '${building.occupiedApartments}/${building.totalApartments}',
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

  Widget _buildBuildingInfo({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value, style: AppTypography.h4.copyWith(color: AppColors.primary)),
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

  List<ApartmentEntity> _getDummyApartments(String buildingId) {
    final allApartments = [
      ApartmentEntity(
        id: '1',
        buildingId: '1',
        apartmentNumber: '1A',
        residentName: 'Ahmet Yılmaz',
        phone: '+905551234567',
        monthlyDues: 5000,
        paymentStatus: PaymentStatus.paid,
        lastPaymentDate: DateTime(2024, 4, 15),
        balance: 0,
      ),
      ApartmentEntity(
        id: '2',
        buildingId: '1',
        apartmentNumber: '1B',
        residentName: 'Fatma Kaya',
        phone: '+905559876543',
        monthlyDues: 5000,
        paymentStatus: PaymentStatus.pending,
        lastPaymentDate: null,
        balance: -5000,
      ),
      ApartmentEntity(
        id: '3',
        buildingId: '2',
        apartmentNumber: '2A',
        residentName: 'Mehmet Demir',
        phone: '+905555555555',
        monthlyDues: 6000,
        paymentStatus: PaymentStatus.paid,
        lastPaymentDate: DateTime(2024, 4, 10),
        balance: 0,
      ),
    ];
    return allApartments.where((apt) => apt.buildingId == buildingId).toList();
  }
}
