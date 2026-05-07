import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/widgets/toast_overlay.dart';
import 'l10n/strings.g.dart';

void main() {
  initLocale();
  runApp(const ProviderScope(child: MyApp()));
}

void initLocale() {
  // Varsayılan locale'i Türkçe yap
  LocaleSettings.setLocale(AppLocale.tr);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: MaterialApp.router(
        title: 'AidatPanel',
        theme: AppTheme.lightTheme(),
        routerConfig: AppRouter.router,
        locale: LocaleSettings.currentLocale.flutterLocale,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocaleUtils.supportedLocales,
        builder: (context, child) {
          return ToastOverlay(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}
