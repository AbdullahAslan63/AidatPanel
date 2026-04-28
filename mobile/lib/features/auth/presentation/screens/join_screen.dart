import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/toast_overlay.dart';
import '../providers/auth_provider.dart';

class JoinScreen extends ConsumerStatefulWidget {
  const JoinScreen({super.key});

  @override
  ConsumerState<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends ConsumerState<JoinScreen> {
  late TextEditingController _inviteCodeController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _inviteCodeController = TextEditingController();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleJoin() {
    final inviteCode = _inviteCodeController.text.trim();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (inviteCode.isEmpty || name.isEmpty || password.isEmpty) {
      ref
          .read(toastProvider.notifier)
          .show(
            'Davet kodu, ad ve şifre boş bırakılamaz',
            type: ToastType.error,
          );
      return;
    }

    if (password != confirmPassword) {
      ref
          .read(toastProvider.notifier)
          .show('Şifreler eşleşmiyor', type: ToastType.error);
      return;
    }

    if (password.length < 6) {
      ref
          .read(toastProvider.notifier)
          .show('Şifre en az 6 karakter olmalı', type: ToastType.error);
      return;
    }

    ref
        .read(authStateProvider.notifier)
        .join(inviteCode, password, name, phone.isEmpty ? null : phone);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    ref.listen(authStateProvider, (previous, next) {
      if (next.isAuthenticated) {
        if (next.user?.role.name == 'manager') {
          context.go('/manager-dashboard');
        } else {
          context.go('/resident-dashboard');
        }
      } else if (next.error != null) {
        ref
            .read(toastProvider.notifier)
            .show(next.error ?? 'Bir hata oluştu', type: ToastType.error);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Davet Koduyla Katıl'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Apartmana Katıl',
                style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSizes.spacingL),
              TextField(
                controller: _inviteCodeController,
                enabled: !authState.isLoading,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'Davet Kodu',
                  hintText: 'AP3-B12-X7K9',
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                ),
              ),
              const SizedBox(height: AppSizes.spacingM),
              TextField(
                controller: _nameController,
                enabled: !authState.isLoading,
                decoration: InputDecoration(
                  labelText: 'Ad Soyad',
                  hintText: 'Örn: Furkan Kaya',
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: AppSizes.spacingM),
              TextField(
                controller: _phoneController,
                enabled: !authState.isLoading,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: 'Telefon (Opsiyonel)',
                  hintText: '5XX XXX XXXX',
                  prefixText: '+90 ',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  counterText: '',
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: AppSizes.spacingM),
              TextField(
                controller: _passwordController,
                enabled: !authState.isLoading,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacingM),
              TextField(
                controller: _confirmPasswordController,
                enabled: !authState.isLoading,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Şifre Tekrar',
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacingL),
              ElevatedButton(
                onPressed: authState.isLoading ? null : _handleJoin,
                child: authState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Katıl'),
              ),
              const SizedBox(height: AppSizes.spacingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Yönetici misiniz? ',
                    style: AppTypography.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: authState.isLoading
                        ? null
                        : () => context.push('/register'),
                    child: const Text('Kaydol'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
