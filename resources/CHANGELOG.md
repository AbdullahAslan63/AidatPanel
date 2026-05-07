# AidatPanel Changelog

Tüm versiyon değişikliklerinin kaydı. Format [Keep a Changelog](https://keepachangelog.com/tr/1.1.0/) standardına uygundur.

---

## [0.1.0] - 2026-05-06

### 🌍 i18n (Çoklu Dil) Entegrasyonu

- **Slang Paketi** — Tam i18n altyapısı eklendi
  - `build.yaml` konfigürasyonu (slang code generation)
  - `strings_tr.i18n.json` — Türkçe çeviriler (229 satır)
  - `strings_en.i18n.json` — İngilizce çeviriler
  - `strings.g.dart` — Otomatik generated dosya
  - `main.dart`: `LocaleSettings.useDeviceLocale()` entegrasyonu
- **Dil Değiştirme** — Ayarlar sekmesinde dil seçimi (TR/EN)

### 🎨 Typography İyileştirmeleri

- **Font Boyutları Küçültüldü** — UI dengesi için optimize edildi
  - h1: 32 → 30, h2: 26 → 24, h3: 20 → 18, h4: 18 → 16
  - body1: 17 → 16, body2: 17 → 16, label: 16 → 14
  - caption: 16 → 13, button: 18 → 16, bodyLarge: 19 → 17, small: 15 → 13
- **18 Ekran Güncellendi** — Tüm ekranlar yeni typography'a göre ayarlandı
  - Auth ekranları (login, register, join, splash)
  - Dashboard ekranları (manager, resident)
  - Bina ekranları (add_building, building_residents, invite_code)
  - Widget'lar (invite_confirm_dialogs, invite_step_indicator, invite_code_result_view)
  - Ayarlar sekmesi (settings_tab)

### � Teknik İyileştirmeler

- **Input Validators** — Validasyon mesajları iyileştirildi
- **Providers Klasörü** — `mobile/lib/core/providers/` oluşturuldu
- **.scripts/ Klasörü** — Build ve otomasyon script'leri taşındı
- **.windsurf/ Temizliği** — README.md ve update_reports.ps1 silindi
- **build_release_apk.ps1** — Silindi (.scripts/ altına taşınacak)

### 📋 Dokümantasyon

- `resources/planning/dil_ekleme_promptu.md` — Dil ekleme süreci dokümante edildi

---

## [0.0.10] - 2026-05-05

### � Build & ProGuard Fix

- **Release APK Build Script** — PowerShell otomasyon script'i eklendi (`build_release_apk.ps1`)
  - Versiyon klasör yapısı (`v0.0.10/`) otomatik oluşturma
  - Çıktı: `C:\AidatPanel APK\v0.0.10\aidatpanel-v0.0.10.apk`
- **ProGuard/R8** — Flutter Play Core deferred components için `-dontwarn` kuralları eklendi
  - `com.google.android.play.core.splitinstall.*` sınıfları R8 shrink'ten hariç tutuldu
  - `io.flutter.embedding.engine.deferredcomponents.PlayStoreDeferredComponentManager` keep edildi

---

## [0.0.9] - 2026-05-04

### 🔐 Güvenlik (Aşama A - Tamamlandı)

- **HTTP → HTTPS** — `api_constants.dart:2` güncellendi
- **Token Expiry 15 dakika** — `auth_repository_impl.dart` (3 lokasyon) düzeltildi
- **DioClient Refresh Loop** — Ayrı `_refreshDio` instance ile sonsuz döngü riski ortadan kaldırıldı

### 🐛 Düzeltmeler

- **Versiyon formatı** — `0.0.8` → `0.0.9` (build number desteği)
- **intl paket** — `dependency_overrides` ile Flutter 3.11.5 uyumu sağlandı
- **User storage** — JSON format desteği eklendi

### �📋 Dokümantasyon

- **HATA_ANALIZ_RAPORU.md** v0.0.8 → v0.0.9 güncellendi (Aşama A kapatıldı)
- **AIDATPANEL_GAP_ANALIZI.md** v2.0 → v2.1 güncellendi (6 gap kapatıldı)
- **YOL_HARITASI.md v3.0** oluşturuldu — 7 aşama (0-6) tam detaylandırıldı
- **AGENTS_COMPLIANCE_AUDIT.md** v1.0 → v1.1 güncellendi
- **SECURITY_AUDIT.md** v1.0 → v1.1 güncellendi
- Lokal checkpoint oluşturuldu: `checkpoints/2026-05-04_14-00.checkpoint.md`

---

## [0.0.8+3] - 2026-05-03

### 📚 Dokümantasyon

- Eski prompt_data dosyaları silindi (AGENTS.md, AI_COFOUNDER_PROMPTU.md, vb.)
- `prompt_data/master_promptu_analizi/` klasörü oluşturuldu
- Furkan için kişiselleştirilmiş AI Co-Founder Master Prompt oluşturuldu
- AI Co-Founder 4 çalışma modu tanımlandı: Teknik Danışman, Proje Yöneticisi, Analiz & Review, Stratejik Ortak

---

## [0.0.8+2] - 2026-05-02

### ✨ İyileştirmeler

- Dashboard TabController optimizasyonu — `setState` yerine Riverpod provider kullanımı
- `manager_dashboard_screen.dart` ve `resident_dashboard_screen.dart` tab index state Riverpod'a taşındı
- `navigation_provider.dart` oluşturuldu — merkezi tab yönetimi

### 🔧 Teknik Değişiklikler

- `pubspec.yaml` ve `app_constants.dart` senkronize edildi

---

## [0.0.8+1] - 2026-05-02

### 🔐 Güvenlik

- Token expiry (süre dolma) kontrolü eklendi
- `secure_storage.dart`: `saveTokenExpiry()`, `getTokenExpiry()`, `isTokenExpired()` metodları eklendi
- `dio_client.dart`: API çağrısı öncesi token süresi kontrolü
- `auth_repository_impl.dart`: Login/Register/Join işlemlerinde expiry kaydetme

### 🧪 Test

- Ayarlar sekmesine "Token Süresi Kontrol (Test)" butonu eklendi
- Debug modda token süresi manuel kontrol edilebilir

### 🔧 Teknik Değişiklikler

- `app_constants.dart`: `tokenExpiryKey` eklendi
- Token yönetimi altyapısı hazırlandı (backend entegrasyonuna hazır)

---

## [0.0.8] - 2026-05-02

### 🚀 Yeni Özellikler

- prompt_data klasörü tamamen Türkçe'ye çevrildi
- AGENTS.md, AI_COFOUNDER_PROMPTU.md, GUVENLIK_ANALIZI.md, OPTIMIZASYON_ANALIZI.md (Türkçe)

### ✨ İyileştirmeler

- `promp_ciktilari` klasörü `prompt_data` olarak yeniden adlandırıldı
- Tüm dokümantasyon tek dilde birleştirildi

### 🔧 Teknik Değişiklikler

- 7 dosya güncellendi, 154 satır değiştirildi
- Eski İngilizce dosyalar temizlendi
- Checkpoint-2026-05-02-turkce oluşturuldu

---

## [0.0.7+2] - 2026-04-30

### 🔧 Teknik Değişiklikler

- UserData sınıfı duplicate'ı kaldırıldı (3 dosyadan tek dosyaya)
- `features/auth/data/models/user_data.dart` oluşturuldu
- `login_response.dart`, `register_response.dart`, `join_response.dart` temizlendi

---

## [0.0.7+1] - 2026-04-30

### 🐛 Düzeltmeler

- Uygulama versiyonu 0.0.7 yapıldı (`pubspec.yaml`, `appConstants`, settings)
- LFS kaldırıldı, APK'ler GitHub'dan silindi
- APK yedekleme script'i oluşturuldu (`D:\AidatPanel\build_apk_backup.bat`)
- Versiyon referansları dinamik hale getirildi (login, register, join ekranları)
- Login ekranı layout iyileştirmesi: `MainAxisAlignment.center` eklendi
- Responsive layout tutarlı hale getirildi

---

## [0.0.7] - 2025-04-29

### 🚀 Yeni Özellikler

- **Davet Kodu Üretim Akışı** — 3 adımlı bina → daire → kod akışı
- **Native Paylaşım** — Uygulamalar arası paylaşım + panoya kopyalama
- **Aktif Kod Yönetimi** — Aynı daireye tekrar kod üretimini engelleme
- **Kod İptal (Revoke)** — Aktif kodun manuel iptali
- **Bina Ekleme Ekranı** — Şehir/ilçe seçimli, kat/daire sayısı girişi
- **Dinamik Daire Oluşturma** — Kat × Daire sayısı otomatik daire listesi

### ✨ İyileştirmeler

- Ana menüye dönüş butonu (Davet kodu sonuç ekranı)
- Kod geçerlilik süresi: Gün + saat detaylı gösterim
- Bina kartları: Detaylı bilgi ve tıklanabilir navigasyon
- Daire etiket formatı: "1. Kat - Daire A" gösterimi

### 🔧 Teknik Değişiklikler

- `invite_code_screen.dart` modüler yapıya bölündü (938 satır → 6 dosya)
  - `invite_code_helpers.dart`, `invite_step_indicator.dart`, `invite_selectable_tile.dart`, `invite_confirm_dialogs.dart`, `invite_code_result_view.dart`
- Buildings ve Apartments state management (Riverpod)
- Davet kodu formatı: `AP425-1A-X7K9`

---

## [0.0.6] - 2025-04-28

### 🚀 Yeni Özellikler

- Stacked toast sistemi (max 3 görünür, en eskisi fade out)
- Kapsamlı Ayarlar sekmesi (profil, dil, hakkında, çıkış)
- Clean Architecture klasör yapısı

### ✨ İyileştirmeler

- Stat kartı görünürlüğü: Beyaz metin, primary arka plan
- Hata mesajları: SnackBar → Toast sistemi geçişi
- Tab navigasyonu: BottomNavigationBar + TabBarView senkronizasyonu

### 🔧 Teknik Değişiklikler

- Back button: push/pop navigasyon düzeltmesi
- Splash: Yukarı kayan animasyon
- Register/Join: Back button eklendi

---

## [0.0.5] - 2025-04-27

### 🚀 Yeni Özellikler

- **Bina Sekmesi** — Bina listesi görünümü ve detaylı kartlar
- **Yönetici Dashboard** — Dummy verili yönetici ana ekranı
- **Sakin Dashboard** — Dummy verili sakin ana ekranı
- **Tab Navigasyonu** — Yönetici ve sakin için alt menü navigasyonu

### ✨ İyileştirmeler

- Telefon girişi: +90 prefix ve max 10 haneli validasyon

### 🔧 Teknik Değişiklikler

- Clean Architecture iskelet klasör yapısı oluşturuldu
- Lint hataları düzeltildi (unused fields, deprecated APIs)
- Async safety iyileştirmeleri

---

## [0.0.4] - 2025-04-26

### 🚀 Yeni Özellikler

- **Yönetici Dashboard** — Bina ve sakin yönetimi için ana ekran
- **Sakin Dashboard** — Aidat ve bildirim görünümü için ana ekran
- **Çıkış Akışı** — Auth state temizleme ve splash yönlendirmesi

### 🔧 Teknik Değişiklikler

- Backend API endpoints entegrasyonu
- Kimlik doğrulama flow'u tamamlandı

---

## [0.0.3] - 2025-04-25

### 🚀 Yeni Özellikler

- **Splash Ekranı** — Logo ve marka sunumu
- **Katılım Ekranları** — Yeni kullanıcı kayıt ve davet kodu ile katılım
- **Kimlik Doğrulama Akışı** — Login → Dashboard yönlendirmesi

### ✨ İyileştirmeler

- Splash animasyonu: Yukarıdan kayan geçiş efekti
- Geri butonları: Tüm auth ekranlarına eklendi

---

## [0.0.2] - 2025-04-24

### 🚀 Yeni Özellikler

- **Giriş Ekranı** — Auth providers ve repository'ler ile login
- **Kayıt Ekranı** — Validasyonlu kullanıcı kaydı
- **Telefon Girişi** — +90 ön ekli, max 10 haneli format

### 🔧 Teknik Değişiklikler

- Riverpod state management entegrasyonu
- GoRouter navigasyon yapılandırması
- Repository pattern uygulandı

---

## [0.0.1] - 2025-04-23

### 🚀 Yeni Özellikler

- Flutter projesi başlatıldı
- Clean Architecture klasör yapısı oluşturuldu
- Temel bağımlılıklar eklendi (Riverpod, GoRouter, Dio, vs.)

### 🔧 Teknik Değişiklikler

- Proje iskeleti kuruldu
- Geliştirme ortamı hazırlandı

