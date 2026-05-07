import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/strings.g.dart';
import '../../../../shared/widgets/settings_tab.dart';
import '../../../apartments/data/apartments_store.dart';
import '../../../apartments/domain/entities/apartment_entity.dart';
import '../../data/buildings_store.dart';
import '../../domain/entities/building_entity.dart';
import 'add_building_screen.dart';
import 'building_residents_screen.dart';
import 'invite_code_screen.dart';
import '../../../../shared/providers/navigation_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

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
      ref.read(managerTabIndexProvider.notifier).state = _tabController.index;
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
      appBar: AppBar(
        title: Text(context.t.features.buildings.managerPanel),
        centerTitle: true,
      ),
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: context.t.common.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.apartment),
            label: context.t.common.buildings,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt),
            label: context.t.common.dues,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: context.t.common.settings,
          ),
        ],
        currentIndex: ref.watch(managerTabIndexProvider),
        onTap: (index) {
          ref.read(managerTabIndexProvider.notifier).state = index;
          _tabController.animateTo(index);
        },
      ),
    );
  }

  Widget _buildHomeTab() {
    final buildings = ref.watch(buildingsStoreProvider);
    final authState = ref.watch(authStateProvider);
    final userName = authState.user?.name ?? context.t.common.user;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${context.t.common.welcome}, $userName',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.spacingL),
          _buildStatsRow(context),
          const SizedBox(height: AppSizes.spacingL),
          Text(
            context.t.common.managedBuildings,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.spacingM),
          ..._buildBuildingCards(buildings),
        ],
      ),
    );
  }

  Widget _buildBuildingsTab() {
    final buildings = ref.watch(buildingsStoreProvider);

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
                    label: Text(context.t.common.addBuilding),
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
                    label: Text(context.t.common.inviteCode),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingL),

          // Başlık
          Text(
            context.t.common.myBuildings,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
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
                  label: context.t.common.apartment,
                  value:
                      '${building.occupiedApartments}/${building.totalApartments}',
                  color: AppColors.primary,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.borderColor),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.trending_up,
                  label: context.t.common.collection,
                  value: '%${building.collectionRate.toStringAsFixed(0)}',
                  color: AppColors.success,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.borderColor),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.payments_outlined,
                  label: context.t.common.monthlyDues,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.body1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _onAddBuildingPressed() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const AddBuildingScreen()),
    );
  }

  void _onCreateInviteCodePressed() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => InviteCodeScreen(
          buildings: ref.read(buildingsStoreProvider),
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
    return ref.read(apartmentsStoreProvider.notifier).apartmentsFor(buildingId);
  }

  Widget _buildDuesTab() {
    return Center(
      child: Text(
        context.t.common.duesTab,
        style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return const SettingsTab();
  }

  Widget _buildStatsRow(BuildContext context) {
    final buildings = ref.watch(buildingsStoreProvider);

    // Toplam daire ve dolu daire hesapla
    int totalApartments = 0;
    int occupiedApartments = 0;
    for (final building in buildings) {
      totalApartments += building.totalApartments;
      occupiedApartments += building.occupiedApartments;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildStatCard(
              title: context.t.common.totalApartments,
              value: totalApartments.toString(),
              icon: Icons.apartment_outlined,
            ),
          ),
          const SizedBox(width: AppSizes.spacingM),
          Expanded(
            child: _buildStatCard(
              title: context.t.common.occupiedApartments,
              value: occupiedApartments.toString(),
              icon: Icons.check_circle_outlined,
            ),
          ),
        ],
      ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(height: AppSizes.spacingXS),
                Text(
                  value,
                  style: AppTypography.h2.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                title,
                style: AppTypography.body2.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
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
                      label: context.t.common.apartments,
                      value:
                          '${building.occupiedApartments}/${building.totalApartments}',
                    ),
                    _buildBuildingInfo(
                      label: context.t.common.duesCollection,
                      value: '${building.collectionRate.toStringAsFixed(1)}%',
                    ),
                    _buildBuildingInfo(
                      label: context.t.common.totalDues,
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
}
