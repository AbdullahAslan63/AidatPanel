import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/settings_tab.dart';
import '../../../../shared/widgets/toast_overlay.dart';
import '../../../apartments/domain/entities/apartment_entity.dart';
import '../../domain/entities/building_entity.dart';
import 'building_residents_screen.dart';
import 'invite_code_screen.dart';

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
          // Üst buton satırı
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: AppSizes.buttonHeightPrimary,
                  child: ElevatedButton.icon(
                    onPressed: _onAddBuildingPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add_business),
                    label: const Text('Bina Ekle'),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spacingM),
              Expanded(
                child: SizedBox(
                  height: AppSizes.buttonHeightPrimary,
                  child: ElevatedButton.icon(
                    onPressed: _onCreateInviteCodePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.qr_code_2),
                    label: const Text('Davet Kodu'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingL),

          // Başlık
          Text(
            'Binalarım',
            style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSizes.spacingM),

          // Bina listesi - her satırda bir bina, geniş detaylı
          ...buildings.map((building) => _buildDetailedBuildingCard(building)),
        ],
      ),
    );
  }

  Widget _buildDetailedBuildingCard(BuildingEntity building) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _onBuildingTapped(building),
          child: _buildBuildingCardContent(building),
        ),
      ),
    );
  }

  Widget _buildBuildingCardContent(BuildingEntity building) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Üst kısım: ikon + ad + adres
        Padding(
          padding: const EdgeInsets.all(AppSizes.spacingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.apartment,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSizes.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      building.name,
                      style: AppTypography.h4.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingXS),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            building.address,
                            style: AppTypography.body2.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Ayraç
        Container(height: 1, color: AppColors.borderColor),

        // Alt kısım: detaylı istatistikler
        Padding(
          padding: const EdgeInsets.all(AppSizes.spacingM),
          child: Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.door_front_door_outlined,
                  label: 'Daire',
                  value:
                      '${building.occupiedApartments}/${building.totalApartments}',
                  color: AppColors.primary,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.borderColor),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.trending_up,
                  label: 'Tahsilat',
                  value: '%${building.collectionRate.toStringAsFixed(0)}',
                  color: AppColors.success,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.borderColor),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.payments_outlined,
                  label: 'Aylık Aidat',
                  value: '₺${building.totalMonthlyDues.toStringAsFixed(0)}',
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.body1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  void _onAddBuildingPressed() {
    ref
        .read(toastProvider.notifier)
        .show('Bina ekleme özelliği yakında', type: ToastType.info);
  }

  void _onCreateInviteCodePressed() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => InviteCodeScreen(
          buildings: _getDummyBuildings(),
          apartmentsLoader: _getDummyApartments,
        ),
      ),
    );
  }

  void _onBuildingTapped(BuildingEntity building) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => BuildingResidentsScreen(
          building: building,
          residents: _getDummyApartments(building.id),
        ),
      ),
    );
  }

  List<ApartmentEntity> _getDummyApartments(String buildingId) {
    final all = <String, List<ApartmentEntity>>{
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
          residentName: 'Mehmet Demir',
          phone: '+905552223344',
          monthlyDues: 1000,
          paymentStatus: PaymentStatus.pending,
          balance: 1000,
        ),
        ApartmentEntity(
          id: '1-3',
          buildingId: '1',
          apartmentNumber: '2A',
          residentName: 'Ayşe Kaya',
          phone: '+905553334455',
          monthlyDues: 1000,
          paymentStatus: PaymentStatus.paid,
          balance: 0,
        ),
        ApartmentEntity(
          id: '1-4',
          buildingId: '1',
          apartmentNumber: '2B',
          residentName: 'Fatma Şahin',
          phone: '+905554445566',
          monthlyDues: 1000,
          paymentStatus: PaymentStatus.overdue,
          balance: 3000,
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
          phone: '+905556667788',
          monthlyDues: 1500,
          paymentStatus: PaymentStatus.paid,
          balance: 0,
        ),
        ApartmentEntity(
          id: '2-2',
          buildingId: '2',
          apartmentNumber: '1B',
          residentName: 'Zeynep Aydın',
          phone: '+905557778899',
          monthlyDues: 1500,
          paymentStatus: PaymentStatus.paid,
          balance: 0,
        ),
        ApartmentEntity(
          id: '2-3',
          buildingId: '2',
          apartmentNumber: '2A',
          residentName: 'Hasan Çelik',
          phone: '+905558889900',
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
          residentName: 'Emre Öztürk',
          phone: '+905559990011',
          monthlyDues: 1200,
          paymentStatus: PaymentStatus.paid,
          balance: 0,
        ),
        ApartmentEntity(
          id: '3-2',
          buildingId: '3',
          apartmentNumber: '1B',
          residentName: 'Selin Arslan',
          phone: '+905550001122',
          monthlyDues: 1200,
          paymentStatus: PaymentStatus.overdue,
          balance: 3600,
        ),
      ],
    };
    return all[buildingId] ?? const [];
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
}
