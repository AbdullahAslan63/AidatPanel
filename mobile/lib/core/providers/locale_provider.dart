import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/strings.g.dart';

final localeProvider = StateProvider<AppLocale>((ref) {
  return LocaleSettings.currentLocale;
});

void changeLocale(WidgetRef ref, AppLocale locale) {
  LocaleSettings.setLocale(locale);
  ref.read(localeProvider.notifier).state = locale;
}
