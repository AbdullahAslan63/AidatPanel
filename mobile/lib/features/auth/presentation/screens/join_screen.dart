import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/utils/auth_validators.dart';
import '../../../../core/utils/input_validators.dart';
import '../../../../l10n/strings.g.dart';
import '../../../../shared/widgets/alt_action_button.dart';
import '../../../../shared/widgets/password_field.dart';
import '../../../../shared/widgets/password_criterion.dart';
import '../../../../shared/widgets/toast_overlay.dart';
import '../providers/auth_provider.dart';
import '../../domain/entities/user_entity.dart';

class JoinScreen extends ConsumerStatefulWidget {
  const JoinScreen({super.key});

  @override
  ConsumerState<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends ConsumerState<JoinScreen> {
  static final _upperRegex = RegExp(r'[A-Z]');
  static final _lowerRegex = RegExp(r'[a-z]');
  static final _digitRegex = RegExp(r'\d');
  static final _specialRegex = RegExp(r'[@$!%*?&]');
  late TextEditingController _inviteCodeController;
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _inviteCodeError;
  String? _phoneError;
  bool _hasMinLength = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    _inviteCodeController = TextEditingController();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleJoin(BuildContext context) {
    final inviteCode = _inviteCodeController.text.trim();
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (inviteCode.isEmpty || email.isEmpty || name.isEmpty || password.isEmpty) {
      ref
          .read(toastProvider.notifier)
          .show(
            context.t.features.auth.inviteCodeAndPasswordRequired,
            type: ToastType.error,
          );
      return;
    }

    if (!AuthValidators.isValidInviteCode(inviteCode)) {
      ref
          .read(toastProvider.notifier)
          .show(
            context.t.features.auth.invalidInviteCodeFormat,
            type: ToastType.error,
          );
      return;
    }

    final emailError = InputValidators.validateEmail(email);
    if (emailError != null) {
      final errorMessage = emailError == 'email_required'
          ? context.t.validation.emailRequired
          : emailError == 'email_invalid'
          ? context.t.validation.emailInvalid
          : context.t.validation.emailTooLong;
      ref.read(toastProvider.notifier).show(errorMessage, type: ToastType.error);
      return;
    }

    if (phone.isNotEmpty && !AuthValidators.isValidPhone(phone)) {
      ref
          .read(toastProvider.notifier)
          .show(
            context.t.features.auth.invalidPhoneFormat,
            type: ToastType.error,
          );
      return;
    }

    if (password != confirmPassword) {
      ref
          .read(toastProvider.notifier)
          .show(
            context.t.features.auth.passwordsDoNotMatch,
            type: ToastType.error,
          );
      return;
    }

    final passwordError = InputValidators.validatePassword(password);
    if (passwordError != null) {
      final errorMessage = passwordError == 'password_required'
          ? context.t.validation.passwordRequired
          : passwordError == 'password_too_short'
          ? context.t.validation.passwordTooShort
          : passwordError == 'password_too_long'
          ? context.t.validation.passwordTooLong
          : passwordError == 'password_uppercase_required'
          ? context.t.validation.passwordUppercaseRequired
          : passwordError == 'password_lowercase_required'
          ? context.t.validation.passwordLowercaseRequired
          : passwordError == 'password_number_required'
          ? context.t.validation.passwordNumberRequired
          : context.t.validation.passwordSpecialCharRequired;
      ref
          .read(toastProvider.notifier)
          .show(errorMessage, type: ToastType.error);
      return;
    }

    ref
        .read(authStateProvider.notifier)
        .join(inviteCode, email, password, name, phone.isEmpty ? null : phone);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    ref.listen(authStateProvider, (previous, next) {
      if (next.isAuthenticated) {
        if (next.user?.role == UserRole.manager) {
          context.go('/manager-dashboard');
        } else {
          context.go('/resident-dashboard');
        }
      } else if (next.error != null && next.error != previous?.error) {
        ref
            .read(toastProvider.notifier)
            .show(
              next.error ?? context.t.features.auth.errorOccurred,
              type: ToastType.error,
            );
      }
    });

    return PopScope(
      canPop: !authState.isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.spacingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.t.features.auth.appTitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.h1.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingL),
                    Text(
                      context.t.features.auth.joinApartment,
                      textAlign: TextAlign.center,
                      style: AppTypography.h2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingL),
                    TextField(
                      controller: _inviteCodeController,
                      enabled: !authState.isLoading,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: context.t.features.auth.inviteCode,
                        hintText: context.t.features.auth.inviteCodeHint,
                        prefixIcon: const Icon(Icons.vpn_key_outlined),
                        errorText: _inviteCodeError,
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty &&
                              !AuthValidators.isValidInviteCode(value)) {
                            _inviteCodeError =
                                context.t.features.auth.invalidInviteCodeFormat;
                          } else {
                            _inviteCodeError = null;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingM),
                    TextField(
                      controller: _emailController,
                      enabled: !authState.isLoading,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: context.t.features.auth.email,
                        hintText: context.t.features.auth.emailHint,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingM),
                    TextField(
                      controller: _nameController,
                      enabled: !authState.isLoading,
                      decoration: InputDecoration(
                        labelText: context.t.features.auth.name,
                        hintText: context.t.features.auth.nameHint,
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
                        labelText: context.t.features.auth.phoneOptional,
                        hintText: context.t.features.auth.phoneHintOptional,
                        prefixText: '+90 ',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        counterText: '',
                        errorText: _phoneError,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty &&
                              !AuthValidators.isValidPhone(value)) {
                            _phoneError =
                                context.t.features.auth.invalidPhoneNumber;
                          } else {
                            _phoneError = null;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: AppSizes.spacingM),
                    PasswordField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      labelText: context.t.features.auth.password,
                      hintText: context.t.features.auth.passwordHint,
                      onToggleVisibility: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      enabled: !authState.isLoading,
                      onChanged: (value) {
                        setState(() {
                          _hasMinLength = value.length >= 8;
                          _hasUpperCase = _upperRegex.hasMatch(value);
                          _hasLowerCase = _lowerRegex.hasMatch(value);
                          _hasNumber = _digitRegex.hasMatch(value);
                          _hasSpecialChar = _specialRegex.hasMatch(value);
                        });
                      },
                      focusNode: _passwordFocusNode,
                      passwordCriteria: _passwordFocusNode.hasFocus
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PasswordCriterion(text: context.t.features.auth.minLength, isMet: _hasMinLength),
                                PasswordCriterion(text: context.t.features.auth.hasUpperCase, isMet: _hasUpperCase),
                                PasswordCriterion(text: context.t.features.auth.hasLowerCase, isMet: _hasLowerCase),
                                PasswordCriterion(text: context.t.features.auth.hasNumber, isMet: _hasNumber),
                                PasswordCriterion(text: context.t.features.auth.hasSpecialChar, isMet: _hasSpecialChar),
                              ],
                            )
                          : null,
                    ),
                    const SizedBox(height: AppSizes.spacingM),
                    PasswordField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      labelText: context.t.features.auth.confirmPassword,
                      hintText: context.t.features.auth.passwordHint,
                      onToggleVisibility: () {
                        setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        );
                      },
                      enabled: !authState.isLoading,
                      onChanged: (value) {
                        setState(() {
                          _passwordsMatch = value == _passwordController.text;
                        });
                      },
                      helperText: _confirmPasswordController.text.isEmpty
                          ? null
                          : _passwordsMatch
                          ? null
                          : context.t.features.auth.passwordsDoNotMatch,
                    ),
                    const SizedBox(height: AppSizes.spacingL),
                    ElevatedButton(
                      onPressed: authState.isLoading
                          ? null
                          : () => _handleJoin(context),
                      child: authState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(context.t.features.auth.join),
                    ),
                    const SizedBox(height: AppSizes.spacingM),
                    AltActionButton(
                      icon: Icons.person_add_outlined,
                      title: context.t.features.auth.areYouManager,
                      onTap: authState.isLoading
                          ? null
                          : () => context.push('/register'),
                      isEnabled: !authState.isLoading,
                    ),
                    const SizedBox(height: AppSizes.spacingXL),
                    Text(
                      '${context.t.features.auth.copyright} v${AppConstants.appVersion}',
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: AppSizes.spacingM,
                left: AppSizes.spacingM,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: authState.isLoading ? null : () => context.pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
