import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_typography.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../l10n/strings.g.dart';
import 'toast_overlay.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final currentLocale = ref.watch(localeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (user != null) _ProfileCard(user: user),
          const SizedBox(height: AppSizes.spacingL),

          _SectionHeader(title: context.t.common.account),
          const SizedBox(height: AppSizes.spacingS),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.lock_outline,
                title: context.t.common.changePassword,
                onTap: () => _showComingSoon(context, ref),
              ),
              const _Divider(),
              _SettingsTile(
                icon: Icons.language,
                title: context.t.common.language,
                trailing: currentLocale == AppLocale.tr ? 'Türkçe' : 'English',
                onTap: () => _showLanguageDialog(context, ref),
              ),
              const _Divider(),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: context.t.common.notifications,
                onTap: () => _showComingSoon(context, ref),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingL),

          _SectionHeader(title: context.t.common.info),
          const SizedBox(height: AppSizes.spacingS),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: context.t.common.privacyPolicy,
                onTap: () => _showComingSoon(context, ref),
              ),
              const _Divider(),
              _SettingsTile(
                icon: Icons.shield_outlined,
                title: context.t.common.kvkk,
                onTap: () => _showComingSoon(context, ref),
              ),
              const _Divider(),
              _SettingsTile(
                icon: Icons.help_outline,
                title: context.t.common.helpSupport,
                onTap: () => _showComingSoon(context, ref),
              ),
              const _Divider(),
              _SettingsTile(
                icon: Icons.info_outline,
                title: context.t.common.about,
                trailing: 'v${AppConstants.appVersion}',
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingXL),

          // Token expiry test button (DEBUG ONLY - production'da gizli)
          if (kDebugMode) ...[
            _TokenTestButton(),
            const SizedBox(height: AppSizes.spacingM),
          ],

          _LogoutButton(),
          const SizedBox(height: AppSizes.spacingL),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, WidgetRef ref) {
    ref
        .read(toastProvider.notifier)
        .show(context.t.common.comingSoon, type: ToastType.info);
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(context.t.common.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context: dialogContext,
              title: context.t.common.turkishLanguage,
              isSelected: currentLocale == AppLocale.tr,
              onTap: () {
                changeLocale(ref, AppLocale.tr);
                Navigator.pop(dialogContext);
              },
            ),
            const SizedBox(height: 12),
            _buildLanguageOption(
              context: dialogContext,
              title: context.t.common.englishLanguage,
              isSelected: currentLocale == AppLocale.en,
              onTap: () {
                changeLocale(ref, AppLocale.en);
                Navigator.pop(dialogContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.body1.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: 'v${AppConstants.appVersion}',
      applicationLegalese: context.t.common.copyright,
      children: [
        const SizedBox(height: AppSizes.spacingM),
        Text(
          context.t.common.aboutDescription,
          style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final UserEntity user;

  const _ProfileCard({required this.user});

  String get _initials {
    final parts = user.name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.isNotEmpty ? parts[0][0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final roleLabel = user.role == UserRole.manager
        ? context.t.common.manager
        : context.t.common.resident;
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary,
            child: Text(
              _initials,
              style: AppTypography.h2.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: AppSizes.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: AppTypography.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.spacingXS),
                if (user.email.isNotEmpty) ...[
                  Text(
                    user.email,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ] else if (user.phone != null && user.phone!.isNotEmpty) ...[
                  Text(
                    user.phone!,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ] else ...[
                  Text(
                    '-',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.spacingS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    roleLabel,
                    style: AppTypography.label.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingS),
      child: Text(
        title,
        style: AppTypography.label.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingM,
          vertical: AppSizes.spacingM,
        ),
        child: Row(
          children: [
            Icon(icon, size: AppSizes.iconSize, color: AppColors.primary),
            const SizedBox(width: AppSizes.spacingM),
            Expanded(
              child: Text(
                title,
                style: AppTypography.body1.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing!,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSizes.spacingS),
            ],
            const Icon(
              Icons.chevron_right,
              size: AppSizes.iconSize,
              color: AppColors.textDisabled,
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingM),
      child: Divider(height: 1, color: AppColors.border),
    );
  }
}

class _LogoutButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return ElevatedButton.icon(
      onPressed: authState.isLoading
          ? null
          : () => _confirmLogout(context, ref),
      icon: const Icon(Icons.logout, size: AppSizes.iconSize),
      label: Text(context.t.common.logout),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, AppSizes.buttonHeightPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
        textStyle: AppTypography.button,
        elevation: 0,
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout, color: AppColors.error),
            const SizedBox(width: 8),
            Text(context.t.common.logout),
          ],
        ),
        content: Text(
          context.t.common.logoutConfirm,
          style: AppTypography.body1,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSizes.spacingM,
          0,
          AppSizes.spacingM,
          AppSizes.spacingM,
        ),
        actions: [
          _DialogActionRow(
            confirmLabel: context.t.common.logout,
            confirmColor: AppColors.error,
            onConfirm: () async {
              Navigator.pop(dialogContext);
              await ref.read(authStateProvider.notifier).logout();
              if (!context.mounted) return;
              context.go('/');
            },
          ),
        ],
      ),
    );
  }
}

class _DialogActionRow extends StatelessWidget {
  final String confirmLabel;
  final Color confirmColor;
  final VoidCallback onConfirm;

  const _DialogActionRow({
    required this.confirmLabel,
    required this.confirmColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: AppSizes.buttonHeightSecondary,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: BorderSide(color: AppColors.borderColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                context.t.common.cancel,
                style: const TextStyle(fontSize: 16),
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
                backgroundColor: confirmColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onConfirm,
              child: Text(
                confirmLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TokenTestButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => _checkTokenExpiry(context, ref),
      icon: const Icon(Icons.timer_outlined, size: AppSizes.iconSize),
      label: Text(context.t.common.tokenExpiryTest),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.warning,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, AppSizes.buttonHeightPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
        textStyle: AppTypography.button,
        elevation: 0,
      ),
    );
  }

  Future<void> _checkTokenExpiry(BuildContext context, WidgetRef ref) async {
    final secureStorage = ref.read(secureStorageProvider);
    final isExpired = await secureStorage.isTokenExpired();
    final expiry = await secureStorage.getTokenExpiry();

    if (!context.mounted) return;

    if (isExpired) {
      ref
          .read(toastProvider.notifier)
          .show(context.t.common.tokenExpired, type: ToastType.error);
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) {
        context.go('/login');
      }
    } else {
      final remaining = expiry?.difference(DateTime.now()) ?? Duration.zero;
      ref
          .read(toastProvider.notifier)
          .show(
            '${context.t.common.tokenActive} ${remaining.inSeconds} saniye',
            type: ToastType.success,
          );
    }
  }
}
