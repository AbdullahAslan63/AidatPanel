import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/toast_overlay.dart';
import '../../../apartments/domain/entities/apartment_entity.dart';
import '../../data/invite_code_store.dart';
import '../../domain/entities/building_entity.dart';

class InviteCodeScreen extends ConsumerStatefulWidget {
  final List<BuildingEntity> buildings;
  final List<ApartmentEntity> Function(String buildingId) apartmentsLoader;

  const InviteCodeScreen({
    super.key,
    required this.buildings,
    required this.apartmentsLoader,
  });

  @override
  ConsumerState<InviteCodeScreen> createState() => _InviteCodeScreenState();
}

class _InviteCodeScreenState extends ConsumerState<InviteCodeScreen> {
  int _step = 0; // 0: bina seç, 1: daire seç, 2: kod göster
  BuildingEntity? _selectedBuilding;
  ApartmentEntity? _selectedApartment;
  String? _generatedCode;
  DateTime? _activeExpiresAt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Davet Kodu Oluştur'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _onBackPressed,
        ),
      ),
      body: Column(
        children: [
          _buildStepper(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildStepContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    final steps = [
      ('Bina', Icons.apartment),
      ('Daire', Icons.door_front_door_outlined),
      ('Kod', Icons.qr_code_2),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingL,
        vertical: AppSizes.spacingM,
      ),
      color: Colors.white,
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            // Çizgi
            final lineActive = _step >= (i ~/ 2) + 1;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color: lineActive ? AppColors.primary : AppColors.borderColor,
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final active = _step >= stepIndex;
          final (label, icon) = steps[stepIndex];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: active ? AppColors.primary : AppColors.borderColor,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 18,
                  color: active ? Colors.white : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: active ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _buildBuildingStep();
      case 1:
        return _buildApartmentStep();
      case 2:
        return _buildCodeStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------- ADIM 1: BİNA ----------
  Widget _buildBuildingStep() {
    return ListView(
      key: const ValueKey('step-0'),
      padding: const EdgeInsets.all(AppSizes.spacingL),
      children: [
        Text(
          'Hangi binadan kod üretilecek?',
          style: AppTypography.h4.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSizes.spacingM),
        ...widget.buildings.map(
          (b) => _buildSelectableTile(
            icon: Icons.apartment,
            iconColor: AppColors.primary,
            title: b.name,
            subtitle: b.address,
            onTap: () {
              setState(() {
                _selectedBuilding = b;
                _selectedApartment = null;
                _step = 1;
              });
            },
          ),
        ),
      ],
    );
  }

  // ---------- ADIM 2: DAİRE ----------
  Widget _buildApartmentStep() {
    final apartments = widget.apartmentsLoader(_selectedBuilding!.id);
    return ListView(
      key: const ValueKey('step-1'),
      padding: const EdgeInsets.all(AppSizes.spacingL),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.spacingM),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.apartment, color: AppColors.primary),
              const SizedBox(width: AppSizes.spacingS),
              Expanded(
                child: Text(
                  _selectedBuilding!.name,
                  style: AppTypography.body1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spacingL),
        Text(
          'Hangi daire için kod üretilecek?',
          style: AppTypography.h4.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSizes.spacingM),
        if (apartments.isEmpty)
          _buildEmptyApartments()
        else
          ...apartments.map((apt) {
            final isOccupied = apt.phone != null;
            final activeCode = ref.watch(inviteCodeStoreProvider)[apt.id];
            final hasActiveCode = activeCode != null && !activeCode.isExpired;
            return _buildSelectableTile(
              icon: hasActiveCode
                  ? Icons.qr_code_2
                  : Icons.door_front_door_outlined,
              iconColor: hasActiveCode
                  ? AppColors.accent
                  : (isOccupied ? AppColors.textSecondary : AppColors.success),
              title: _formatApartmentLabel(apt.apartmentNumber),
              subtitle: hasActiveCode
                  ? 'Aktif kod: ${activeCode.code} • ${_remainingText(activeCode.remaining)}'
                  : (isOccupied ? 'Sakin: ${apt.residentName}' : 'Boş daire'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: hasActiveCode
                      ? AppColors.accent.withValues(alpha: 0.12)
                      : (isOccupied
                            ? AppColors.warning.withValues(alpha: 0.12)
                            : AppColors.success.withValues(alpha: 0.12)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  hasActiveCode ? 'Aktif Kod' : (isOccupied ? 'Dolu' : 'Boş'),
                  style: AppTypography.caption.copyWith(
                    color: hasActiveCode
                        ? AppColors.accent
                        : (isOccupied ? AppColors.warning : AppColors.success),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              onTap: () => _onApartmentSelected(apt),
            );
          }),
      ],
    );
  }

  Widget _buildEmptyApartments() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacingXL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.door_back_door_outlined,
            size: 56,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spacingM),
          Text(
            'Bu binaya henüz daire eklenmemiş',
            style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _onApartmentSelected(ApartmentEntity apt) {
    // Önce aktif kod var mı kontrol et
    final active = ref.read(inviteCodeStoreProvider.notifier).activeFor(apt.id);
    if (active != null) {
      _showActiveCode(apt, active);
      return;
    }
    if (apt.phone != null) {
      _showOccupiedConfirm(apt);
    } else {
      _generateAndShow(apt);
    }
  }

  /// Daire için zaten aktif kod varsa o kodu göster (yenisi üretilmesin).
  void _showActiveCode(ApartmentEntity apt, ActiveInviteCode active) {
    setState(() {
      _selectedApartment = apt;
      _generatedCode = active.code;
      _activeExpiresAt = active.expiresAt;
      _step = 2;
    });
  }

  void _showOccupiedConfirm(ApartmentEntity apt) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warning),
            const SizedBox(width: 8),
            const Text('Daire Dolu'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_formatApartmentLabel(apt.apartmentNumber)} dairesinde "${apt.residentName}" kayıtlı.',
              style: AppTypography.body1.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSizes.spacingS),
            RichText(
              text: TextSpan(
                style: AppTypography.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                children: [
                  const TextSpan(text: 'Yeni kod üretirsen '),
                  TextSpan(
                    text: 'eski kullanıcı çıkarılır',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: '. Emin misiniz?'),
                ],
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSizes.spacingM,
          0,
          AppSizes.spacingM,
          AppSizes.spacingM,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: AppSizes.buttonHeightSecondary,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(
                        color: AppColors.borderColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Vazgeç',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spacingS),
              Expanded(
                child: SizedBox(
                  height: AppSizes.buttonHeightSecondary,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _generateAndShow(apt);
                    },
                    child: const Text(
                      'Yine de Üret',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _generateAndShow(ApartmentEntity apt) {
    final code = _generateCode(_selectedBuilding!, apt);
    final now = DateTime.now();
    final expires = now.add(const Duration(days: 7));
    // Store'a kaydet (aktif kod havuzu)
    ref
        .read(inviteCodeStoreProvider.notifier)
        .save(
          apt.id,
          ActiveInviteCode(code: code, createdAt: now, expiresAt: expires),
        );
    setState(() {
      _selectedApartment = apt;
      _generatedCode = code;
      _activeExpiresAt = expires;
      _step = 2;
    });
  }

  // ---------- ADIM 3: KOD ----------
  Widget _buildCodeStep() {
    final code = _generatedCode!;
    final building = _selectedBuilding!;
    final apt = _selectedApartment!;
    return ListView(
      key: const ValueKey('step-2'),
      padding: const EdgeInsets.all(AppSizes.spacingL),
      children: [
        // Üst banner
        Container(
          padding: const EdgeInsets.all(AppSizes.spacingL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.success, Color(0xFF10B981)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: AppSizes.spacingM),
              Text(
                'Davet Kodu Hazır',
                style: AppTypography.h3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${building.name} • ${_formatApartmentLabel(apt.apartmentNumber)}',
                style: AppTypography.body2.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spacingL),

        // Kod kartı
        Container(
          padding: const EdgeInsets.all(AppSizes.spacingL),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            children: [
              Text(
                'KOD',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.spacingS),
              SelectableText(
                code,
                style: AppTypography.h1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacingM),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingM,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule, size: 14, color: AppColors.warning),
                    const SizedBox(width: 6),
                    Text(
                      '7 gün geçerli',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spacingS),
              if (_activeExpiresAt != null) ...[
                Text(
                  'Son kullanma: ${_formatDate(_activeExpiresAt!)}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  'Kalan: ${_remainingText(_activeExpiresAt!.difference(DateTime.now()))}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spacingL),

        // Aksiyonlar
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: AppSizes.buttonHeightPrimary,
                child: ElevatedButton.icon(
                  onPressed: () => _copyCode(code),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.copy),
                  label: const Text('Kopyala'),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spacingM),
            Expanded(
              child: SizedBox(
                height: AppSizes.buttonHeightPrimary,
                child: OutlinedButton.icon(
                  onPressed: () => _shareCode(code, building, apt),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.share),
                  label: const Text('Paylaş'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacingM),

        // Bilgilendirme: aynı daireye yeniden üretmek için iptal et
        Container(
          padding: const EdgeInsets.all(AppSizes.spacingM),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.info.withValues(alpha: 0.25)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 18, color: AppColors.info),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bu kod aktifken aynı daireye yeni kod üretilemez. Yeni kod için önce mevcut kodu iptal etmelisin.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spacingM),

        // Aksiyonlar: Başa dön + Kodu iptal et
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: AppSizes.buttonHeightSecondary,
                child: OutlinedButton.icon(
                  onPressed: _resetFlow,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(color: AppColors.borderColor, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.list_alt),
                  label: const Text('Başka Daire'),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spacingS),
            Expanded(
              child: SizedBox(
                height: AppSizes.buttonHeightSecondary,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmRevoke(apt),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Kodu İptal Et'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacingL),

        // Ana menüye dön
        SizedBox(
          height: AppSizes.buttonHeightPrimary,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.home),
            label: const Text(
              'Ana Menüye Dön',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmRevoke(ApartmentEntity apt) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.cancel_outlined, color: AppColors.error),
            const SizedBox(width: 8),
            const Text('Kodu İptal Et'),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
            children: [
              const TextSpan(text: 'Mevcut kod '),
              TextSpan(
                text: 'geçersiz hale gelir',
                style: AppTypography.body2.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const TextSpan(text: '. Emin misiniz?'),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSizes.spacingM,
          0,
          AppSizes.spacingM,
          AppSizes.spacingM,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: AppSizes.buttonHeightSecondary,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(
                        color: AppColors.borderColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Vazgeç',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spacingS),
              Expanded(
                child: SizedBox(
                  height: AppSizes.buttonHeightSecondary,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ref.read(inviteCodeStoreProvider.notifier).revoke(apt.id);
                      ref
                          .read(toastProvider.notifier)
                          .show('Kod iptal edildi', type: ToastType.success);
                      _resetFlow();
                    },
                    child: const Text(
                      'İptal Et',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- YARDIMCILAR ----------
  Widget _buildSelectableTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacingM),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: AppSizes.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.body1.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTypography.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSizes.spacingS),
                  trailing,
                ] else
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatApartmentLabel(String apartmentNumber) {
    final match = RegExp(r'(\d+)([A-Za-z]?)').firstMatch(apartmentNumber);
    if (match == null) return apartmentNumber;
    final floor = match.group(1);
    final letter = match.group(2);
    if (letter != null && letter.isNotEmpty) {
      return '$floor. Kat - Daire $letter';
    }
    return '$floor. Kat';
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d.$m.${date.year}';
  }

  /// Süre formatı: "5 gün 3 saat", "12 saat 30 dk", "45 dk"
  String _remainingText(Duration d) {
    if (d.isNegative) return 'Süresi doldu';
    if (d.inDays > 0) {
      final hours = d.inHours - d.inDays * 24;
      return hours > 0 ? '${d.inDays} gün $hours saat' : '${d.inDays} gün';
    }
    if (d.inHours > 0) {
      final mins = d.inMinutes - d.inHours * 60;
      return mins > 0 ? '${d.inHours} saat $mins dk' : '${d.inHours} saat';
    }
    return '${d.inMinutes} dk';
  }

  String _generateCode(BuildingEntity b, ApartmentEntity a) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rnd = Random.secure();
    String pick(int n) =>
        List.generate(n, (_) => chars[rnd.nextInt(chars.length)]).join();
    final prefix = b.name.isNotEmpty
        ? b.name.substring(0, 1).toUpperCase()
        : 'A';
    return '$prefix${b.id}-${a.apartmentNumber.toUpperCase()}-${pick(4)}';
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ref
        .read(toastProvider.notifier)
        .show('Kod kopyalandı: $code', type: ToastType.success);
  }

  Future<void> _shareCode(
    String code,
    BuildingEntity b,
    ApartmentEntity a,
  ) async {
    final expiry = _activeExpiresAt != null
        ? _formatDate(_activeExpiresAt!)
        : _formatDate(DateTime.now().add(const Duration(days: 7)));
    final message =
        'AidatPanel davet kodu\n\n'
        'Bina: ${b.name}\n'
        'Daire: ${_formatApartmentLabel(a.apartmentNumber)}\n'
        'Kod: $code\n\n'
        'Son kullanma: $expiry (7 gün geçerli)\n\n'
        'AidatPanel uygulamasını indirip kayıt olurken bu kodu kullanabilirsiniz.';

    try {
      final box = context.findRenderObject() as RenderBox?;
      await SharePlus.instance.share(
        ShareParams(
          text: message,
          subject: 'AidatPanel Davet Kodu',
          sharePositionOrigin: box != null
              ? box.localToGlobal(Offset.zero) & box.size
              : null,
        ),
      );
    } catch (_) {
      // Paylaşım başarısız olursa panoya kopyalama yedek
      Clipboard.setData(ClipboardData(text: message));
      if (mounted) {
        ref
            .read(toastProvider.notifier)
            .show('Mesaj panoya kopyalandı', type: ToastType.info);
      }
    }
  }

  void _resetFlow() {
    setState(() {
      _step = 0;
      _selectedBuilding = null;
      _selectedApartment = null;
      _generatedCode = null;
      _activeExpiresAt = null;
    });
  }

  void _onBackPressed() {
    if (_step == 0) {
      Navigator.pop(context);
    } else if (_step == 1) {
      setState(() {
        _step = 0;
        _selectedBuilding = null;
      });
    } else {
      setState(() {
        _step = 1;
        _selectedApartment = null;
        _generatedCode = null;
      });
    }
  }
}
