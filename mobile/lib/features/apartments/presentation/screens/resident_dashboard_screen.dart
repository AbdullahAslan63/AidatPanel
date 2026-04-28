import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../apartments/domain/entities/apartment_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ResidentDashboardScreen extends ConsumerStatefulWidget {
  const ResidentDashboardScreen({super.key});

  @override
  ConsumerState<ResidentDashboardScreen> createState() => _ResidentDashboardScreenState();
}

class _ResidentDashboardScreenState extends ConsumerState<ResidentDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Sakin Paneli'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (mounted) {
                context.go('/');
              }
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(),
          _buildDuesTab(),
          _buildIssuesTab(),
          _buildSettingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Aidatlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_outlined),
            label: 'Arızalar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        currentIndex: _tabController.index,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
            _tabController.animateTo(index);
          });
        },
      ),
    );
  }

  Widget _buildHomeTab() {
    final apartment = _getDummyApartment();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hoş Geldiniz, ${apartment.residentName}',
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSizes.spacingXS),
          Text(
            'Daire ${apartment.apartmentNumber}',
            style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.spacingL),
          _buildPaymentStatusCard(apartment),
          const SizedBox(height: AppSizes.spacingL),
          _buildQuickActionsRow(),
          const SizedBox(height: AppSizes.spacingL),
          Text(
            'Son İşlemler',
            style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSizes.spacingM),
          _buildTransactionHistory(),
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

  Widget _buildIssuesTab() {
    return Center(
      child: Text(
        'Arızalar Sekmesi',
        style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Center(
      child: Text(
        'Ayarlar Sekmesi',
        style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildPaymentStatusCard(ApartmentEntity apartment) {
    final statusColor = apartment.paymentStatus == PaymentStatus.paid
        ? AppColors.success
        : apartment.paymentStatus == PaymentStatus.pending
            ? AppColors.warning
            : AppColors.error;

    final statusText = apartment.paymentStatus == PaymentStatus.paid
        ? 'Ödendi'
        : apartment.paymentStatus == PaymentStatus.pending
            ? 'Beklemede'
            : 'Gecikmiş';

    return Container(
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
              Text(
                'Aylık Aidat',
                style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingS,
                  vertical: AppSizes.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: AppTypography.label.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingM),
          Text(
            '₺${apartment.monthlyDues.toStringAsFixed(2)}',
            style: AppTypography.h1.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSizes.spacingM),
          if (apartment.balance != 0)
            Text(
              apartment.balance > 0
                  ? 'Bakiye: ₺${apartment.balance.toStringAsFixed(2)}'
                  : 'Ödenmesi Gereken: ₺${(-apartment.balance).toStringAsFixed(2)}',
              style: AppTypography.body2.copyWith(
                color: apartment.balance > 0 ? AppColors.success : AppColors.error,
              ),
            ),
          if (apartment.lastPaymentDate != null) ...[
            const SizedBox(height: AppSizes.spacingS),
            Text(
              'Son Ödeme: ${apartment.lastPaymentDate!.day}/${apartment.lastPaymentDate!.month}/${apartment.lastPaymentDate!.year}',
              style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActionsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.payment_outlined,
            label: 'Ödeme Yap',
            onTap: () {},
          ),
        ),
        const SizedBox(width: AppSizes.spacingM),
        Expanded(
          child: _buildActionButton(
            icon: Icons.receipt_outlined,
            label: 'Faturalar',
            onTap: () {},
          ),
        ),
        const SizedBox(width: AppSizes.spacingM),
        Expanded(
          child: _buildActionButton(
            icon: Icons.help_outline,
            label: 'Destek',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacingM),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: AppSizes.spacingS),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistory() {
    final transactions = [
      {'date': '15 Nisan 2024', 'amount': '₺5,000', 'type': 'Ödeme', 'status': 'Başarılı'},
      {'date': '15 Mart 2024', 'amount': '₺5,000', 'type': 'Ödeme', 'status': 'Başarılı'},
      {'date': '15 Şubat 2024', 'amount': '₺5,000', 'type': 'Ödeme', 'status': 'Başarılı'},
    ];

    return Column(
      children: transactions
          .map(
            (tx) => Container(
              margin: const EdgeInsets.only(bottom: AppSizes.spacingM),
              padding: const EdgeInsets.all(AppSizes.spacingM),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx['type']!,
                        style: AppTypography.h4.copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: AppSizes.spacingXS),
                      Text(
                        tx['date']!,
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        tx['amount']!,
                        style: AppTypography.h4.copyWith(color: AppColors.success),
                      ),
                      const SizedBox(height: AppSizes.spacingXS),
                      Text(
                        tx['status']!,
                        style: AppTypography.caption.copyWith(color: AppColors.success),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  ApartmentEntity _getDummyApartment() {
    return ApartmentEntity(
      id: '1',
      buildingId: '1',
      apartmentNumber: '4B',
      residentName: 'Furkan Kaya',
      phone: '+905551234567',
      monthlyDues: 5000,
      paymentStatus: PaymentStatus.paid,
      lastPaymentDate: DateTime(2024, 4, 15),
      balance: 0,
    );
  }
}
